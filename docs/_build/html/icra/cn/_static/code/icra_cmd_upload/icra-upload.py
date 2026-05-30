#!/usr/bin/env python3
"""
ICRA Work Upload Tool (type=2 on-site tasks only)

Interactive:
    python3 icra-upload.py

Batch mode:
    python3 icra-upload.py -u <user> -p <pass> -t <task> -n <title> -f <file> [-d <desc>]
"""

import argparse
import getpass
import json
import os
import sys
import urllib.request
import urllib.error

SM2_PK = "04c26b92b92a4f1b1839bcc1ff599cfb697a14ca25a02e34119cf9436e594f073aa2d00344c8b9acdf4aa93222d6c1a1010765982606c8792b6cf0c5fe682a7bf9"
API_BASE = os.environ.get("API_BASE", "https://www.kdc.icra.lejurobot.com/api")

GREEN = "\033[1;32m"
BLUE = "\033[1;34m"
RED = "\033[1;31m"
RESET = "\033[0m"


def log(msg):
    print(f"{BLUE}[INFO]{RESET} {msg}")


def ok(msg):
    print(f"{GREEN}  OK{RESET} {msg}")


def err(msg):
    print(f"{RED}[ERROR]{RESET} {msg}")
    sys.exit(1)


def api_post(path, data=None, files=None):
    url = f"{API_BASE}{path}"
    headers = {"Content-Type": "application/json;charset=UTF-8", "Authorization": f"Bearer {_TOKEN}"}

    if files:
        import uuid
        boundary = f"----FormBoundary{uuid.uuid4().hex}"
        parts = []
        for name, filepath in files.items():
            filename = os.path.basename(filepath)
            with open(filepath, "rb") as f:
                content = f.read()
            parts.append(f"--{boundary}".encode())
            parts.append(f'Content-Disposition: form-data; name="{name}"; filename="{filename}"'.encode())
            parts.append(b"Content-Type: application/octet-stream")
            parts.append(b"")
            parts.append(content)
        parts.append(f"--{boundary}--".encode())
        body = b"\r\n".join(parts)
        headers["Content-Type"] = f"multipart/form-data; boundary={boundary}"
        req = urllib.request.Request(url, data=body, headers=headers, method="POST")
    else:
        body = json.dumps(data or {}).encode("utf-8")
        req = urllib.request.Request(url, data=body, headers=headers, method="POST")

    try:
        with urllib.request.urlopen(req, timeout=30) as resp:
            return json.loads(resp.read().decode("utf-8"))
    except urllib.error.HTTPError as e:
        body = e.read().decode("utf-8", errors="replace")
        try:
            return json.loads(body)
        except json.JSONDecodeError:
            return {"code": e.code, "message": body}


def sm2_encrypt(plain):
    try:
        from gmssl import sm2
    except ImportError:
        log("gmssl not installed, installing...")
        import subprocess
        subprocess.check_call([sys.executable, "-m", "pip", "install", "gmssl", "-q"])
        from gmssl import sm2
    return sm2.CryptSM2(public_key=SM2_PK, private_key="").encrypt(plain.encode()).hex()


def do_login(user, password):
    global _TOKEN, _USER_ID, _USER_NAME, _TEAM_NUMBER

    if len(password) >= 128 and all(c in "0123456789abcdefABCDEF" for c in password):
        encrypted_pw = password
    else:
        log("Encrypting password...")
        encrypted_pw = sm2_encrypt(password)

    url = f"{API_BASE}/registration/login"
    body = json.dumps({"name": user, "password": encrypted_pw}).encode("utf-8")
    headers = {"Content-Type": "application/json;charset=UTF-8"}
    req = urllib.request.Request(url, data=body, headers=headers, method="POST")
    try:
        with urllib.request.urlopen(req, timeout=30) as resp:
            data = json.loads(resp.read().decode("utf-8"))
    except urllib.error.HTTPError as e:
        data = json.loads(e.read().decode("utf-8", errors="replace"))

    if data.get("code") != 20000:
        err(f"Login failed: {data.get('message', data)}")

    info = data.get("data", {})
    _TOKEN = info.get("token") or info.get("accessToken", "")
    _USER_ID = info.get("id", "")
    _USER_NAME = info.get("name", "")
    _TEAM_NUMBER = info.get("team_number", "")
    ok(f"Logged in as {_USER_NAME} (team: {_TEAM_NUMBER or 'N/A'})")


def fetch_tasks():
    log("Fetching available tasks...")
    resp = api_post("/task/find", {})
    data = resp.get("data", [])
    records = data.get("records", []) if isinstance(data, dict) else data
    tasks = [(r["id"], r["task"]) for r in records if r.get("type") == "2"]
    if not tasks:
        err("No type=2 tasks available")
    ok(f"Found {len(tasks)} task(s)")
    return tasks


def resolve_task(tasks, task_ref):
    """Resolve task by index (1-based)."""
    try:
        idx = int(task_ref)
        if 1 <= idx <= len(tasks):
            return tasks[idx - 1]
    except ValueError:
        pass
    err(f"Invalid task index: {task_ref} (must be 1-{len(tasks)})")


def pick_task_interactive(tasks):
    print()
    print("Available tasks:")
    for i, (tid, tname) in enumerate(tasks, 1):
        print(f"  [{i}] {tname}")
    print()
    while True:
        try:
            n = int(input(f"Select [1-{len(tasks)}]: "))
            if 1 <= n <= len(tasks):
                tid, tname = tasks[n - 1]
                ok(f"Selected: {tname}")
                return tid, tname
        except ValueError:
            pass


def check_limit(task_id):
    log("Checking submission limit...")
    resp = api_post("/registration/checkSubmitLimit", {
        "type": "2", "task": task_id, "team_number": _TEAM_NUMBER or "",
    })
    if resp.get("code") != 20000:
        err(f"Limit check failed: {resp.get('message', resp)}")
    ok("Limit check passed")


def do_upload(filepath):
    if not os.path.isfile(filepath):
        err(f"File not found: {filepath}")
    size_kb = os.path.getsize(filepath) / 1024
    log(f"Uploading ({size_kb:.1f} KB)...")
    resp = api_post("/registration/upload", files={"file": filepath})
    if resp.get("code") != 20000:
        err(f"Upload failed: {resp}")
    oss_path = resp.get("data", "")
    if not oss_path:
        err("Upload response missing OSS path")
    ok(f"Uploaded: {oss_path}")
    return oss_path


def save_work(filename, description, task_id, oss_path):
    log("Saving...")
    resp = api_post("/registration/saveUpload", {
        "id": _USER_ID,
        "file": oss_path,
        "type": "2",
        "task": task_id,
        "submitname": _USER_NAME or "",
        "filename": filename,
        "description": description,
        "team_number": _TEAM_NUMBER or "",
    })
    if resp.get("code") != 20000:
        err(f"Save failed: {resp.get('message', resp)}")
    ok("Saved successfully")


# ---- state ----
_TOKEN = ""
_USER_ID = ""
_USER_NAME = ""
_TEAM_NUMBER = ""


def run_workflow(user, password, task_ref, work_name, work_desc, file_path):
    do_login(user, password)
    tasks = fetch_tasks()
    task_id, task_name = resolve_task(tasks, task_ref)
    ok(f"Task: {task_name}")
    check_limit(task_id)
    print()
    oss = do_upload(file_path)
    save_work(work_name, work_desc, task_id, oss)
    print()
    print("====================================")
    print("  Done!")
    print("====================================")


def main():
    parser = argparse.ArgumentParser(
        prog="icra-upload",
        description="Upload work to ICRA on-site competition (type=2 tasks only)",
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog="""
Tasks:
  1  Metal Parts Righting
  2  Daily Chemical Bottle
  3  Express Package Scanning

Example:
  python3 icra-upload.py -u <username> -p <password> -t 1 -n mywork -f ./result.zip
        """,
    )
    required = parser.add_argument_group("required in batch mode")
    required.add_argument("-u", metavar="USER", help="Login username")
    required.add_argument("-p", metavar="PASS", help="Login password (plaintext, auto SM2 encrypted)")
    required.add_argument("-t", metavar="N", help="Task number (see task list above)")
    required.add_argument("-n", metavar="TITLE", help="Work title")
    optional = parser.add_argument_group("optional")
    optional.add_argument("-d", metavar="DESC", default="", help="Work description (default: empty)")
    required.add_argument("-f", metavar="FILE", help="Path to the file to upload")
    args = parser.parse_args()

    # Interactive mode
    if not args.u:
        print("====================================")
        print("  ICRA Upload Tool  (type=2 on-site)")
        print("====================================")
        print()

        user = input("Username: ").strip()
        password = getpass.getpass("Password: ")
        print()
        do_login(user, password)

        tasks = fetch_tasks()
        task_id, task_name = pick_task_interactive(tasks)

        check_limit(task_id)

        print()
        work_name = input("Work title: ").strip()
        work_desc = input("Description: ").strip()
        file_path = input("File path: ").strip()

        print()
        oss = do_upload(file_path)
        save_work(work_name, work_desc, task_id, oss)

        print()
        print("====================================")
        print("  Done!")
        print("====================================")
        return

    # Batch mode
    if not args.p or not args.t or not args.n or not args.f:
        err("Batch mode requires: -u -p -t -n -f")

    run_workflow(args.u, args.p, args.t, args.n, args.d, args.f)


if __name__ == "__main__":
    main()
