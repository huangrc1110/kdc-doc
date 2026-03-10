.. _real::
**********
Real Robot Competition
**********

Real Robot Competition Task Introduction
================

Task Overview
--------

The robot used in the real robot competition is Leju Kuavo 4 Pro, with end-effectors being dexterous hands/grippers.

Task 1
^^^^^^^^^

Small Part Flipping: The robot stands still while the conveyor belt runs at medium speed to transport parts, and the robot performs flipping operations on the parts that need to be flipped.

.. video:: ../_static/videos/task1_real.mp4
   :width: 100%

Task 2
^^^^^^^^^

Express Fackage Weighing: The robot stands still, grabs the express package on the table and places it on the weighing platform, checks whether the express label is facing up to determine if it needs to be flipped, and then places the package on the conveyor belt on the left-hand side.

.. video:: ../_static/videos/task2_real.mp4
   :width: 100%

Task 3
^^^^^^^^^

Unilever: Pick up the bottle from the table and place it on the conveyor belt.

.. video:: ../_static/videos/task3_real.mp4
   :width: 100%


Task Scoring
--------

Each task will be evaluated for ten rounds, with the final score being the average of the ten rounds.

Task 1: Small Part Flipping (100 points)
^^^^^^^^^^^^^^^^^^^^^^^^^^^^

During evaluation, three small parts will be randomly placed on the conveyor belt, and each small part needs to be flipped in sequence. Scoring criteria are as follows:

*   Successful grasping and flipping: 30 points per object, total 90 points

*   Completion bonus: 10 points

Task 2: Express Package Weighing (100 points)
^^^^^^^^^^^^^^^^^^^^^^^^^^^^

During evaluation, one express package with label facing down and one with label facing up will be placed on the right side of the robot. The express packages need to be placed on the weighing platform, determine the label position, flip the package with label facing down, and then grasp and place the packages onto the conveyor belt on the left-hand side. Scoring criteria are as follows:

*   Accurate grasping of express package: 10 points per package, total 20 points

*   Successful identification and flipping of packages that need flipping: 30 points per package, total 60 points

*   Stable placement to designated position: 10 points per package, total 20 points

Task 3: Unilever (100 points)
^^^^^^^^^^^^^^^^^^^^^^^^^^^^

During evaluation, two bottles will be placed in front of the robot. First pick up the bottle with the right hand, then pass the bottle in the air to the left hand, and finally place the bottle on the conveyor belt with the left hand. Scoring criteria are as follows:

*   Successful object handover: 30 points per bottle, total 60 points

*   Accurate placement to designated position: 10 points per bottle, total 20 points

*   Completion bonus: 20 points

Real Robot Competition Data Introduction
================
.. note::
    Real robot video size is 848*480, different from simulation data's 640*480.

Similar to the simulation competition, the real robot data we provide is native rosbag. Participants can process it according to their needs. The topic names, content, data formats, etc. of real robot data are the same as simulation data (except for video image dimensions). If still using the kuavo_data_challenge baseline code framework, you can completely follow the previous simulation data conversion, training, and inference processes. The parts that need modification are some configurations in the config file.

Considering computational power issues during the simulation competition phase, the first batch of real robot data is 1000 entries per task. If subsequent testing diagnoses insufficient data volume leading to poor model performance, participants can contact the organizers to supplement data.


Real Robot Data Download Address (modelscope)
-------------------------
https://www.modelscope.cn/datasets/lejurobot/LET-ICRA2026Competition-Data


Real Robot Competition Configuration File Instructions (modify by reference, do not copy-paste directly)
========================
Data Conversion (parts that may need modification are commented)
--------------------------
.. code-block:: bash

    ########No modification needed#######
    hydra:
        run:
            dir: ./outputs/data_cvt_hydra_save/singlerun/${now:%Y%m%d_%H%M%S}
        sweep:
            dir: ./outputs/data_cvt_hydra_save/multirun/${now:%Y%m%d_%H%M%S}
            subdir: ${hydra:job.override_dirname}

    ########Modify according to actual directory#######
    rosbag:
        rosbag_dir: /path/to/your/rosbag
        num_used: null
        lerobot_dir: /path/to/your/lerobot/save/file

    dataset:
        only_arm: true  # Default true, whether to use only arm data
        eef_type: rq2f85 # Real robot options: leju_claw, qiangnao; tasks 1 and 2 use gripper leju_claw, task 3 uses dexterous hand qiangnao
        which_arm: both  # Which arm data is needed, options: left, right, both; note this will simultaneously select cameras for corresponding arms, head camera is included by default; tasks 1 and 3 are single-arm operations, can choose right (but not necessarily), task 2 must choose both
        use_depth: true  # Whether depth image data is needed, depth data consistent with arms above; currently only diffusion policy supports depth in this branch, ACT policy does not support depth images yet but is supported in dev branch
        depth_range: [0, 1000]  # Depth map cropping range, unit: millimeters

        task_description: “Pick and Place”

        train_hz: 10
        main_timeline: head_cam_h
        main_timeline_fps: 30
        sample_drop: 10


        dex_dof_needed: 1

        is_binary: false
        delta_action: false
        relative_start: false

        resize:
            width: 848
            height: 480


Model Inference Configuration File
--------------------------
main branch (config to modify is kuavo_real_env.yaml, parts that may need modification are commented)
^^^^^^^^^^^^^^^^^^^^^^^^
.. code-block:: bash

    hydra:
        run:
            dir: ./outputs/kuavo_sim_deploy_hydra_save/singlerun/${now:%Y%m%d_%H%M%S}
        sweep:
            dir: ./outputs/kuavo_sim_deploy_hydra_save/multirun/${now:%Y%m%d_%H%M%S}
            subdir: ${hydra:job.override_dirname}


    real: true # Set to true, indicating real robot competition configuration

    only_arm: true  # Set to true, indicating only arm control is used
    eef_type: leju_claw  # End-effector type, real robot options leju_claw or qiangnao: choose according to task's eef, tasks 1 and 2 use gripper leju_claw, task 3 uses dexterous hand qiangnao
    control_mode: joint
    which_arm: both  # Which arm data is needed, options: left, right, both; note this will simultaneously select cameras for corresponding arms, head camera is included by default; tasks 1 and 3 are single-arm operations, can choose right (but not necessarily), task 2 must choose both
    head_init: null

    # input_images: input images, options “head_cam_h”,'depth_h','wrist_cam_l','depth_l','wrist_cam_r','depth_r'
    # (each is optional, needs to be consistent with your robot configuration and trained model)
    # Typically: cameras = [{“left”:['head_cam_h','wrist_cam_l'],
    #                 “right”:['head_cam_h','wrist_cam_r'],
    #                 “both”:['head_cam_h','wrist_cam_l','wrist_cam_r']
    #                 },
    #                 {“left”:['head_cam_h','depth_h','wrist_cam_l','depth_l'],
    #                 “right”:['head_cam_h','depth_h','wrist_cam_r','depth_r'],
    #                 “both”:['head_cam_h','depth_h','wrist_cam_l','depth_l','wrist_cam_r','depth_r']
    #                 }][int(self.use_depth)][self.which_arm]
    input_images: [“head_cam_h”,'depth_h','wrist_cam_l','depth_l','wrist_cam_r','depth_r'] # Currently only diffusion policy supports depth in this branch, ACT policy does not support depth images yet but is supported in dev branch
    depth_range: [0, 1000]  # Depth map cropping range, unit: millimeters, has no effect without depth images
    image_size: [480, 848] # Image size (height, width)
    ros_rate: 10  # Inference frequency, unit Hz

    ################### The following environment configurations are not recommended to modify ################33
    qiangnao_dof_needed: 1

    leju_claw_dof_needed: 1

    rq2f85_dof_needed: 1

    arm_init: [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]

    arm_min: [-180,-180,-180,-180,-180,-180,-180,-180,-180,-180,-180,-180,-180,-180]
    arm_max: [180,180,180,180,180,180,180,180,180,180,180,180,180,180]

    eef_min: [0]
    eef_max: [1]

    base_min: [-2.0, -2.0, -3.14, 0]
    base_max: [2.0, 2.0, 3.14, 1]

    is_binary: false

    ######### The following configurations need to be modified according to real robot competition tasks ###########
    go_bag_path: /your_bag_path  # For real robot inference, the complete path of the bag file is required. Please store any original bag file of this task anywhere in the kuavo_data_challenge repository and provide the correct path.

    policy_type: “diffusion”  # Policy name, supports diffusion, act, etc.
    use_delta: false # Whether to use delta actions, default=false (not yet supported)
    eval_episodes: 10  # Number of test episodes, real robot inference can run continuously, set to 10 or greater than 10
    seed: 42
    start_seed: 42
    device: “cuda”
    task: “your_task”
    method: “your_method”
    timestamp: “your_timestamp”
    epoch: 1  # Which epoch of trained model to use. Note: code will load policy model parameters from outputs/<task>/<method>/run_<timestamp>/epoch10
    max_episode_steps: 500  # Maximum episode steps, automatically ends when exceeded, adjust according to task duration, set to 500 is fine
    env_name: Kuavo-Real  # Kuavo simulator environment name

dev branch (parts that may need modification are commented)
^^^^^^^^^^^^^^^^^^^^^^^^
.. code-block:: bash

    hydra:
        run:
            dir: ./outputs/kuavo_deploy_hydra_save/singlerun/${now:%Y%m%d_%H%M%S}
        sweep:
            dir: ./outputs/kuavo_deploy_hydra_save/multirun/${now:%Y%m%d_%H%M%S}
            subdir: ${hydra:job.override_dirname}

    env:
        env_name: Kuavo-Real  # Kuavo environment name, simulation Kuavo-Sim, real robot Kuavo-Real
        control_mode: joint # joint or eef (under development)
        eef_type: leju_claw  # End-effector type, real robot options leju_claw or qiangnao: choose according to task's eef, tasks 1 and 2 use gripper leju_claw, task 3 uses dexterous hand qiangnao
        which_arm: both  # Which arm data is needed, options: left, right, both; note this will simultaneously select cameras for corresponding arms, head camera is included by default; tasks 1 and 3 are single-arm operations, can choose right (but not necessarily), task 2 must choose both
        head_init: null  # Robot head initial position, for simulation please use this value by default to maintain observation consistency, real robot can be adjusted as needed, generally null!!!
        ros_rate: 10  # Inference control frequency, unit Hz

        only_arm: true  # Default true, whether to use only arm data

        image_size: &IMGSIZE [848, 480]  # Image size: width, height
        depth_range: &DEPTHRANGE [0, 1500]  # Depth map range setting, unit mm, default=[0,1500]
        obs_key_map:  # Topic, message type, frequency, image size, depth cropping and other configurations, depth map range setting, unit mm, default=[0,1500], please note needs to be consistent with training!
            head_cam_h: [“/cam_h/color/image_raw/compressed”, “CompressedImage”, 30, *IMGSIZE]  # Head RGB camera topic, required
            wrist_cam_l: [“/cam_l/color/image_raw/compressed”, “CompressedImage”, 30, *IMGSIZE]  # Left wrist RGB camera topic, please select correspondingly, at least select one with below
            wrist_cam_r: [“/cam_r/color/image_raw/compressed”, “CompressedImage”, 30, *IMGSIZE]  # Right wrist RGB camera topic, please select correspondingly, at least select one with above
            depth_h: [“/cam_h/depth/image_raw/compressedDepth”, “CompressedImage”, 30, *IMGSIZE, *DEPTHRANGE]  # Head camera depth map topic, can be selected correspondingly with above
            depth_l: [“/cam_l/depth/image_rect_raw/compressedDepth”, “CompressedImage”, 30, *IMGSIZE, *DEPTHRANGE]  # Left wrist camera depth map topic, can be selected correspondingly with above
            depth_r: [“/cam_r/depth/image_rect_raw/compressedDepth”, “CompressedImage”, 30, *IMGSIZE, *DEPTHRANGE]  # Right wrist camera depth map topic, can be selected correspondingly with above
            joint_q: [“/sensors_data_raw”, “sensorsData”, 500]  # Joint angle topic, required
            qiangnao: [“/dexhand/state”, “JointState”, 500]  # End-effector topic, dexterous hand
            leju_claw: [“/leju_claw_state”, “lejuClawState”, 500]  # End-effector topic, gripper
            rq2f85: [“/gripper/state”, “JointState”, 500]  # End-effector topic, gripper in simulation

        arm_state_keys: [“joint_q”,”gripper”]  # Default unchanged, model observation input arm state includes joint angles and gripper open/close state
        frame_alignment: false  # Whether to enable frame alignment, default=false
        ratio: 1.0 # When using frame alignment, the proportion of most recent observations among all historical observations, default=1.0

        limits:
            joint_q:
            min: [-3.14, -3.14, -3.14, -3.14, -3.14, -3.14, -3.14, -3.14, -3.14, -3.14, -3.14, -3.14, -3.14, -3.14]
            max: [3.14, 3.14, 3.14, 3.14, 3.14, 3.14, 3.14, 3.14, 3.14, 3.14, 3.14, 3.14, 3.14, 3.14]

            gripper:
            min: [0, 0]
            max: [1, 1]

            eef:
            min: [-1, -1, -1, -3.14, -3.14, -3.14, -1, -1, -1, -3.14, -3.14, -3.14]
            max: [1, 1, 1, 3.14, 3.14, 3.14, 1, 1, 1, 3.14, 3.14, 3.14]

            eef_relative:
            min: [-0.005, -0.0075, -0.004, -0.03, -0.03, -0.05, -0.005, -0.0075, -0.004, -0.03, -0.03, -0.05]
            max: [0.005, 0.0075, 0.004, 0.03, 0.03, 0.05, 0.005, 0.0075, 0.004, 0.03, 0.03, 0.05]

            base:
            min: [-2.0, -2.0, -3.14, 0]
            max: [2.0, 2.0, 3.14, 1]

        # The following environment configurations are not recommended to modify

        qiangnao_dof_needed: 1

        is_binary: false

    inference:
        go_bag_path: /path/to/your/go.bag # For real robot inference, the complete path of the bag file is required. Please store any original bag file of this task anywhere in the kuavo_data_challenge repository and provide the correct path.
        policy_type: “act”  # Policy name, supports diffusion, act, etc.
        eval_episodes: 10  # Number of test episodes, real robot inference can run continuously, set to 10 or greater than 10
        seed: 42
        start_seed: 42
        device: “cuda”
        task: “your_task”
        method: “your_method”
        timestamp: “your_timestamp”
        epoch: best  # Which epoch of trained model to use, can fill 50, 100, best, etc. Note: code will load policy model parameters from outputs/train/<task>/<method>/<timestamp>/epoch<epoch>
        max_episode_steps: 500  # Maximum episode steps, set to 500 is fine

Real Robot Competition Submission Instructions
================
Similar to the simulation competition, real robot competition code submission also packages the environment and code into a docker image. Specific steps are as follows:

1. Configure docker acceleration and package environment: refer to simulation competition `submission instructions docker/readme <https://github.com/LejuRobotics/kuavo_data_challenge/blob/main/docker/readme.md>`_ steps 1-2

2. Copy the following Dockerfile template (customized version specifically for real robot competition), modify necessary parameters such as Conda environment name, Conda environment package name, add additional necessary system and python packages, save as ``Dockerfile`` in the project root directory.

   .. code-block:: dockerfile

      # =========================
      # Stage 1: Builder
      # =========================
      FROM ros:noetic-ros-core-focal AS builder

      ARG DEBIAN_FRONTEND=noninteractive

      # Domestic APT sources
      RUN sed -i 's/archive.ubuntu.com/mirrors.tuna.tsinghua.edu.cn/g' /etc/apt/sources.list && \
         sed -i 's/security.ubuntu.com/mirrors.tuna.tsinghua.edu.cn/g' /etc/apt/sources.list

      # Install necessary tools and ROS dependencies
      RUN apt-get update && apt-get install -y \
         curl wget gnupg2 lsb-release sudo ca-certificates build-essential bzip2 \
         ros-noetic-cv-bridge \
         ros-noetic-apriltag-ros \
         && rm -rf /var/lib/apt/lists/*

      # Install Miniforge
      ENV MINIFORGE_URL=”https://mirrors.tuna.tsinghua.edu.cn/github-release/conda-forge/miniforge/LatestRelease/Miniforge3-Linux-x86_64.sh”
      RUN curl -L ${MINIFORGE_URL} -o /tmp/miniforge.sh \
         && bash /tmp/miniforge.sh -b -p /opt/conda \
         && rm /tmp/miniforge.sh

      ENV PATH="/opt/conda/bin:${PATH}"
      ENV LANG=C.UTF-8
      ENV LC_ALL=C.UTF-8

      # Configure domestic mirrors and install mamba
      RUN conda config --add channels https://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud/conda-forge/ \
         && conda config --set show_channel_urls yes \
         && conda install -y mamba -c conda-forge

      # Working directory
      WORKDIR /root/kuavo_data_challenge
      COPY . .

      # Extract Conda environment and install project
      # TODO: Modify Conda environment name and package name, please ensure every myenv is fully modified
      RUN if [ -f “myenv.tar.gz” ]; then \
            mkdir -p ./myenv && tar -xzf myenv.tar.gz -C ./myenv && rm myenv.tar.gz; \
         fi && \
         /bin/bash -c “\
            source ./myenv/bin/activate && \
            conda-unpack && \
            pip install -e . && \
            cd ./third_party/lerobot && pip install -e . -i https://mirrors.aliyun.com/pypi/simple/ && \
            pip install deprecated kuavo_humanoid_sdk==1.2.2 opencv-python==4.11.0.86 opencv-python-headless==4.11.0.86 numpy==1.26.4 -i https://mirrors.aliyun.com/pypi/simple/ && \
            conda clean -afy && \
            rm -rf ./myenv/lib/python*/site-packages/*/tests ./myenv/lib/python*/site-packages/*/test ./myenv/pkgs/* \
         “

      # =========================
      # Stage 2: Final
      # =========================
      FROM ros:noetic-ros-core-focal

      # Set working directory
      WORKDIR /root/kuavo_data_challenge

      # Copy Conda environment and project code
      COPY --from=builder /opt/conda /opt/conda
      COPY --from=builder /root/kuavo_data_challenge /root/kuavo_data_challenge

      # Environment variables
      ENV PATH="/opt/conda/bin:${PATH}"
      ENV LANG=C.UTF-8
      ENV LC_ALL=C.UTF-8

      RUN sed -i 's/archive.ubuntu.com/mirrors.tuna.tsinghua.edu.cn/g' /etc/apt/sources.list && \
         sed -i 's/security.ubuntu.com/mirrors.tuna.tsinghua.edu.cn/g' /etc/apt/sources.list
      # TODO: If other system packages need to be installed, insert here
      RUN apt-get update && apt-get install -y \
         ros-noetic-cv-bridge \
         ros-noetic-apriltag-ros \
         && rm -rf /var/lib/apt/lists/*

      # Preserve ROS environment variables
      # Activate Conda environment
      RUN echo “source /opt/ros/noetic/setup.bash” >> /root/.bashrc && \
         echo “source /root/kuavo_data_challenge/myenv/bin/activate” >> /root/.bashrc && \
         echo “chmod 777 -R /root/kuavo_data_challenge/kuavo_deploy” >> /root/.bashrc && \
         echo “export ROS_IP=192.168.26.10” >> /root/.bashrc && \
         echo “export ROS_MASTER_URI=http://kuavo_master:11311” >> /root/.bashrc

      # Default command
      CMD ["bash"]

3. Subsequent steps are the same as simulation competition submission instructions 4-5, note to modify the docker image name in run_with_gpu.sh to the real robot competition image name you just packaged.

Real Robot Competition Score Explanation
================
The real robot competition return results will include the following content:

1. Task average score: average total score and sub-scores of ten rounds of testing
2. Each round evaluation score: total score and sub-scores of each round of testing
3. Each round evaluation video: robot operation video of each round of testing (third-person view)
4. Log files: detailed log files of each round of testing, source ``log/kuavo_deploy/kauavo_deploy.log``
