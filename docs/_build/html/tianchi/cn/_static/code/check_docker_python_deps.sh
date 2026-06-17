#!/usr/bin/env bash
set -euo pipefail

IMAGE_NAME="${IMAGE_NAME:-}"
IMAGE_TAR="${IMAGE_TAR:-}"
RUN_SCRIPT="${RUN_SCRIPT:-run_with_gpu.sh}"
EXPECTED_ROS_MASTER_URI="${EXPECTED_ROS_MASTER_URI:-http://kuavo_master:11311}"
EXPECTED_ROS_IP="${EXPECTED_ROS_IP:-192.168.26.10}"
DEPLOY_CONFIG_PATH="${DEPLOY_CONFIG_PATH:-/root/kuavo_data_challenge/configs/deploy/kuavo_env.yaml}"
OUTPUTS_TRAIN_ROOT="${OUTPUTS_TRAIN_ROOT:-/root/kuavo_data_challenge/outputs/train}"

if [[ -t 1 && -z "${NO_COLOR:-}" ]]; then
  COLOR_OUTPUT=1
  RED=$'\033[31m'
  GREEN=$'\033[32m'
  BLUE=$'\033[34m'
  BOLD=$'\033[1m'
  RESET=$'\033[0m'
else
  COLOR_OUTPUT=0
  RED=""
  GREEN=""
  BLUE=""
  BOLD=""
  RESET=""
fi

ok() {
  printf '%sOK%s   %s\n' "${GREEN}" "${RESET}" "$*"
}

fail() {
  printf '%sFAIL%s %s\n' "${RED}" "${RESET}" "$*"
}

error() {
  printf '%sERROR:%s %s\n' "${RED}" "${RESET}" "$*" >&2
}

section() {
  printf '%s%s%s\n' "${BOLD}" "$*" "${RESET}"
}

# Add more expected packages here, one per line:
#   package-name==version
#   package-name
EXPECTED_PACKAGES=(
  "kuavo-humanoid-sdk==1.3.3"
)

usage() {
  cat <<EOF
Usage:
  ./check_docker_python_deps.sh [image.tar] [package==version ...]

Environment:
  IMAGE_NAME   Existing Docker image name to inspect. Optional.
  IMAGE_TAR    Docker image tar to load. Optional.
  RUN_SCRIPT   Docker startup script to inspect. Default: run_with_gpu.sh
  EXPECTED_ROS_MASTER_URI  Default: http://kuavo_master:11311
  EXPECTED_ROS_IP          Default: 192.168.26.10
  DEPLOY_CONFIG_PATH       Default: /root/kuavo_data_challenge/configs/deploy/kuavo_env.yaml
  OUTPUTS_TRAIN_ROOT       Default: /root/kuavo_data_challenge/outputs/train

Examples:
  ./check_docker_python_deps.sh
  ./check_docker_python_deps.sh dywp_v21.tar
  ./check_docker_python_deps.sh kuavo-humanoid-sdk==1.3.3 torch
  ./check_docker_python_deps.sh other_image.tar kuavo-humanoid-sdk==1.3.3 torch
  IMAGE_TAR=other_image.tar ./check_docker_python_deps.sh
  IMAGE_NAME=already_loaded:latest ./check_docker_python_deps.sh
  RUN_SCRIPT=run_with_gpu.sh ./check_docker_python_deps.sh dywp_v21.tar
  DEPLOY_CONFIG_PATH=/root/kuavo_data_challenge/configs/deploy/kuavo_env.yaml ./check_docker_python_deps.sh dywp_v21.tar
EOF
}

check_run_script() {
  local script_path="$1"
  local expected_master="$2"
  local expected_ip="$3"
  local docker_run_cmd=""
  local failed=0

  section "Checking Docker startup script: ${script_path}"

  if [[ ! -f "${script_path}" ]]; then
    fail "${script_path}: file not found"
    return 1
  fi

  docker_run_cmd="$(
    sed ':again; /\\$/ { N; s/\\\n/ /; b again; }' "${script_path}" \
      | awk '/docker run / { line = $0 } END { print line }'
  )"

  if [[ -z "${docker_run_cmd}" ]]; then
    fail "${script_path}: no docker run command found"
    return 1
  fi

  if [[ "${docker_run_cmd}" == *"-e ROS_MASTER_URI=${expected_master}"* ]]; then
    ok "ROS_MASTER_URI: ${expected_master}"
  else
    fail "ROS_MASTER_URI: expected ${expected_master}"
    failed=1
  fi

  if [[ "${docker_run_cmd}" == *"-e ROS_IP=${expected_ip}"* ]]; then
    ok "ROS_IP: ${expected_ip}"
  else
    fail "ROS_IP: expected ${expected_ip}"
    failed=1
  fi

  return "${failed}"
}

if [[ "${1:-}" == "-h" || "${1:-}" == "--help" ]]; then
  usage
  exit 0
fi

ARGS=("$@")
if ((${#ARGS[@]} > 0)) && [[ "${ARGS[0]}" == *.tar ]]; then
  IMAGE_TAR="${ARGS[0]}"
  ARGS=("${ARGS[@]:1}")
fi

if ((${#ARGS[@]} > 0)); then
  EXPECTED_PACKAGES=("${ARGS[@]}")
fi

if ! command -v docker >/dev/null 2>&1; then
  error "docker command not found."
  exit 127
fi

script_check_failed=0
if ! check_run_script "${RUN_SCRIPT}" "${EXPECTED_ROS_MASTER_URI}" "${EXPECTED_ROS_IP}"; then
  script_check_failed=1
fi

if [[ -z "${IMAGE_NAME}" ]]; then
  if [[ -z "${IMAGE_TAR}" ]]; then
    tar_files=(*.tar)
    if ((${#tar_files[@]} == 1)) && [[ -f "${tar_files[0]}" ]]; then
      IMAGE_TAR="${tar_files[0]}"
    elif ((${#tar_files[@]} == 0)) || [[ ! -f "${tar_files[0]}" ]]; then
      error "no image specified and no .tar file found in current directory."
      echo "Usage: ./check_docker_python_deps.sh image.tar [package==version ...]" >&2
      exit 1
    else
      error "multiple .tar files found. Please specify one:"
      printf '  %s\n' "${tar_files[@]}" >&2
      exit 1
    fi
  fi

  if [[ ! -f "${IMAGE_TAR}" ]]; then
    error "image tar '${IMAGE_TAR}' does not exist."
    exit 1
  fi

  section "Loading Docker image from ${IMAGE_TAR}..."
  load_output="$(docker load -i "${IMAGE_TAR}")"
  echo "${load_output}"

  IMAGE_NAME="$(
    printf '%s\n' "${load_output}" \
      | sed -n 's/^Loaded image: //p; s/^Loaded image ID: //p' \
      | tail -n 1
  )"

  if [[ -z "${IMAGE_NAME}" ]]; then
    error "could not determine image name from docker load output."
    exit 1
  fi
elif ! docker image inspect "${IMAGE_NAME}" >/dev/null 2>&1; then
  if [[ -n "${IMAGE_TAR}" && -f "${IMAGE_TAR}" ]]; then
    section "Loading Docker image from ${IMAGE_TAR}..."
    load_output="$(docker load -i "${IMAGE_TAR}")"
    echo "${load_output}"
  else
    error "image '${IMAGE_NAME}' not found."
    exit 1
  fi
fi

section "Checking image content: ${IMAGE_NAME}"

dep_check_failed=0
if ! docker run --rm -i \
  -e EXPECTED_PACKAGES="$(printf '%s\n' "${EXPECTED_PACKAGES[@]}")" \
  -e DEPLOY_CONFIG_PATH="${DEPLOY_CONFIG_PATH}" \
  -e OUTPUTS_TRAIN_ROOT="${OUTPUTS_TRAIN_ROOT}" \
  -e NO_COLOR="${NO_COLOR:-}" \
  -e COLOR_OUTPUT="${COLOR_OUTPUT}" \
  "${IMAGE_NAME}" \
  python - <<'PY'
import importlib.metadata as metadata
import os
from pathlib import Path
import sys

USE_COLOR = os.environ.get("COLOR_OUTPUT") == "1" and not os.environ.get("NO_COLOR")
RED = "\033[31m" if USE_COLOR else ""
GREEN = "\033[32m" if USE_COLOR else ""
BLUE = "\033[34m" if USE_COLOR else ""
BOLD = "\033[1m" if USE_COLOR else ""
RESET = "\033[0m" if USE_COLOR else ""


def ok(message: str) -> None:
    print(f"{GREEN}OK{RESET}   {message}")


def fail_line(message: str) -> None:
    print(f"{RED}FAIL{RESET} {message}")


def info(message: str) -> None:
    print(f"{BLUE}INFO{RESET} {message}")


def section(message: str) -> None:
    print(f"{BOLD}{message}{RESET}")


def parse_expected(line: str) -> tuple[str, str | None]:
    if "==" in line:
        name, expected = line.split("==", 1)
        return name.strip(), expected.strip()
    return line.strip(), None


expected_packages = [
    parse_expected(line)
    for line in os.environ.get("EXPECTED_PACKAGES", "").splitlines()
    if line.strip()
]

failed = False

section("Checking Python packages")
for package, expected_version in expected_packages:
    try:
        actual_version = metadata.version(package)
    except metadata.PackageNotFoundError:
        fail_line(f"{package}: not installed")
        failed = True
        continue

    if expected_version is None:
        ok(f"{package}: {actual_version}")
    elif actual_version == expected_version:
        ok(f"{package}: {actual_version}")
    else:
        fail_line(f"{package}: expected {expected_version}, got {actual_version}")
        failed = True

section("Checking deploy config outputs path")
config_path = Path(os.environ["DEPLOY_CONFIG_PATH"])
outputs_train_root = Path(os.environ["OUTPUTS_TRAIN_ROOT"])

if not config_path.exists():
    fail_line(f"deploy config: {config_path} not found")
    failed = True
else:
    try:
        import yaml

        with config_path.open("r", encoding="utf-8") as f:
            config = yaml.safe_load(f) or {}
    except Exception as exc:
        fail_line(f"deploy config: could not parse {config_path}: {exc}")
        failed = True
    else:
        inference = config.get("inference") or {}
        task = inference.get("task")
        method = inference.get("method")
        timestamp = inference.get("timestamp")
        epoch = inference.get("epoch")
        pretrained_path = str(inference.get("pretrained_path") or "").strip()

        info(
            "deploy config: "
            f"task={task!r}, method={method!r}, timestamp={timestamp!r}, epoch={epoch!r}"
        )

        if pretrained_path:
            candidate = Path(pretrained_path)
            if not candidate.is_absolute():
                candidate = config_path.parent / candidate
            if candidate.exists():
                ok(f"pretrained_path exists: {candidate}")
            else:
                fail_line(f"pretrained_path missing: {candidate}")
                failed = True
        elif not all([task, method, timestamp, epoch is not None]):
            fail_line("deploy config: inference.task/method/timestamp/epoch is incomplete")
            failed = True
        else:
            epoch_text = str(epoch).strip()
            epoch_dir_name = epoch_text if epoch_text.startswith("epoch") else f"epoch{epoch_text}"
            candidate = outputs_train_root / str(task) / str(method) / str(timestamp) / epoch_dir_name

            if candidate.exists():
                ok(f"outputs path exists: {candidate}")
            else:
                fail_line(f"outputs path missing: {candidate}")
                failed = True

sys.exit(1 if failed else 0)
PY
then
  dep_check_failed=1
fi

if ((script_check_failed || dep_check_failed)); then
  exit 1
fi
