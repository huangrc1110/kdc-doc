.. _faq:

****************
FAQs
****************

General Questions
=================================

**Q: Why there are two stages in the competition (simulator stage and real-machine stage)?**
    A: The simulator stage allows participants to rapidly iterate and test their algorithms in a safe and controlled environment, while the real-machine stage provides an opportunity to validate the performance of their models on actual hardware, ensuring robustness and practical applicability.

**Q: How do I participate in the real-machine competition? Is this an in-person only event?**
    A: All participants/teams passing the first qualification round (simulator round) may participate in the real-machine competition. All qualified teams have the option to either send their code for remote evaluation on our real-robot platform, or attend the in-person event, which will locate in Beijing, China.

**Q: Am I allowed to use external datasets for training my models?**
	A: No, only the datasets provided by the competition organisers are allowed to be used for model training. Use of any external datasets will lead to immediate disqualification.

**Q: Are there any restrictions on the model architectures or algorithms that can be used?**
	A: You can use any models or learning based algorithms you wish, as long as they can be run within the provided environment. The baseline code shows an example of what kind of models that works in our workflow. You are free to modify or replace any part of the baseline code. 

**Q: How will the submissions be evaluated and how do I submit my code?**
	A: For submission, we would require you to package your code and environment into a docker image, which will be run on our evaluation server. In other word, we only provide simulation environment part. It will be pretty much like how you test your model locally but surely there will be some differences like seed setting, time limit, etc. 
	Instructions on how to submit your code (for two stages) will be updated soon in the 'Submission' page.

**Q: Do I have to complete all three tasks?**
	A: Strictly speaking, no. But it is highly recommended to do so. The final ranking will be based on the total score of all three tasks, so completing all three tasks will give you a better chance to win the competition.

**Q: Why hasn't my submission been evaluated yet?**
	A: If your submission result has not appeared in the evaluation, it means your work has not been pulled by the evaluators yet. Please be patient and wait, as it usually takes 1-3 business days for evaluation, or you can contact the administrator.

**Q: Why do simulation evaluations often fail? How to resolve this?**
	A: There can be many reasons for evaluation failures, including but not limited to: incorrect model file paths, model file permission issues, environment configuration problems, additional downloads or configurations required. It is recommended that you first check whether the image can be loaded locally and perform inference normally. If everything works fine locally, please contact the administrator in the group, and we will help you resolve the issue as soon as possible.

**Q: Why can't I submit again after submitting once?**
	A: Instructions on the number of times participants can upload submissions: Each task can only be submitted once per day. Participants should thoroughly verify your work locally before uploading. If you have no submission opportunities left for the day, please wait patiently for the next day's submission opportunity, or contact the administrator if you have other questions.

**Q: Is there any difference between team members?**
	A: It has been repaired. There is basically no difference between the captain and the team members. Please don't set up two teams for one player, which may cause abnormal scoring.

**Q: Why does the image report SDK or API errors during real-robot deployment?**

Common causes are using an old KDC codebase from the simulation stage, or not building the image from the latest official real-robot competition code.

Please rebuild using the latest repository and deployment instructions in the real-robot competition documentation:

	.. code-block:: Plain Text

		https://kdc-doc.netlify.app/icra/en/pages/real

It is recommended to verify that the `kuavo-humanoid-sdk` version inside the image meets the required version.

**Q: Why does the container report missing Python packages when running the model?**

This is usually because additional dependencies were installed in the local environment but were not included when packaging the Docker image.

It is recommended to first package your own conda environment, then build the image with the official Dockerfile:

	.. code-block:: Bash

		conda install -c conda-forge conda-pack
		conda activate kdc
		conda pack -n kdc -o myenv.tar.gz

Before building the image, ensure all inference dependencies are installed in that environment.

**Q: Why can't ROS be connected after starting `run_with_gpu.sh`?**

A common reason is that the startup script was not updated according to the real-robot deployment notice, especially incorrect ROS network settings.

Please confirm that the `docker run` command in `run_with_gpu.sh` includes:

	.. code-block:: Bash

		-e ROS_MASTER_URI=http://kuavo_master:11311
		-e ROS_IP=192.168.26.10

**Q: Why can deployment not find model weights even though the model is configured?**

Usually this means the path fields in `configs/deploy/kuavo_env.yaml` are incorrect.

Please check:

	.. code-block:: YAML

		inference:
			task: "your_task"
			method: "your_method"
			timestamp: "run_xxxxxxxx_xxxxxx"
			epoch: best

These fields should map to the following path inside the image:

	.. code-block:: Plain Text
		
		/root/kuavo_data_challenge/outputs/train/<task>/<method>/<timestamp>/epoch<epoch>

For example:

	.. code-block:: YAML

		task: "small"
		method: "act"
		timestamp: "run_20260429_002926"
		epoch: best

Corresponding path:

	.. code-block:: Plain Text

		/root/kuavo_data_challenge/outputs/train/small/act/run_20260429_002926/epochbest

If using `pretrained_path`, make sure that path actually exists inside the container.


**Q: Why does the model try to download files from the internet on first inference?**

Some models download cache files on first run. For example, ACT may require ResNet18-related caches. If there is no internet at the competition site, inference may fail.

Please prepare all required cache files in the image in advance, or run a model-loading test before building to ensure caches are written into the image.

**Q: How can I quickly run a self-check before submission?**

Place the check script in the same directory as the image tar and `run_with_gpu.sh`:

	.. code-block:: Bash
		
		./check_docker_python_deps.sh your_image.tar

The script checks:

- ROS settings in `run_with_gpu.sh`
- Python dependency versions inside the Docker image
- Whether `kuavo_env.yaml` maps correctly to the `outputs/train/...` model path

	.. code-block:: Bash
      
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

How to use the script: place it in the same directory as the tar file and `run_with_gpu.sh`, then run it directly.

Docker Image Check Script Guide
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Script:

	.. code-block:: bash

		./check_docker_python_deps.sh

What it checks:

- `ROS_MASTER_URI` / `ROS_IP` in `run_with_gpu.sh`
- Python dependency versions inside the Docker image, e.g. `kuavo-humanoid-sdk==1.3.3`
- Whether `configs/deploy/kuavo_env.yaml` in the image maps to the `outputs/train/...` path

Common commands:

Auto-check when there is only one `.tar` file in the current directory:

	.. code-block:: bash

		./check_docker_python_deps.sh

Specify an image tar:

	.. code-block:: bash

		./check_docker_python_deps.sh dywp_v21.tar

Specify Python packages to check:

	.. code-block:: bash

		./check_docker_python_deps.sh dywp_v21.tar kuavo-humanoid-sdk==1.3.3 torch numpy

Check an already loaded image:

	.. code-block:: bash

		IMAGE_NAME=dywp_v21:latest ./check_docker_python_deps.sh

Common Technical Issues & Resolution
=====================================================
**Q: How much harddisk space do I need to set aside for the datasets and baseline code?**
	A: The total size of the datasets is around 1.4TB (300GB for TASK1, 300GB for TASK2, and 800GB for TASK3). The baseline code and simulator are relatively small in size (less than 1GB). But notice that you don't have to download all datasets at once. And if you choose to use lerobot format, the size will be much smaller.

**Q: How to use two repositories (baseline code and simulator) together?**
	A: The baseline code repository provides an example of how to convert the dateset, model training and model inference. The simulator repository serve as the simulation environment as well as scorement system. Two repositories are independent.

**Q: I am implementing model inference, but the simulator keeps reset. What should I do?**
	A: Normally this is due to incorrect config settings. Please make sure all paths, names are correctly set.

**Q: I am using dockers for both simulator and baseline code, but when I start model inference, nothing happens. What should I do?**
	A: If you make sure all configs are correct, you might have to set up container to container communication.
