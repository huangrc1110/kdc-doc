.. _real::
**********
Real Robot Competition
**********

Real Robot Competition Task Introduction
================

Installing the `kuavo_data_challenge <https://github.com/LejuRobotics/kuavo_data_challenge/tree/main>`_ (Baseline code) Repository
======================================================================================================================================================
This repository is used for data conversion, model training and model deployment. Use git operation to fetch the latest codebase (**icra** branch):  

   .. code-block:: bash
      
      git clone -b main --depth=1 https://github.com/LejuRobotics/kuavo_data_challenge.git 

Additional package
    Lingbot-vla(README.md has detailed installation instructions)：https://github.com/JoyJeeo/lingbot-vla


The robot used in the real robot competition is Leju Kuavo 4 Pro, with end-effectors being dexterous hands/grippers.

Task Overview
--------

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

Task 3: Bottling (100 points)
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

    hydra:  # Hydra config directory, for parameter checking only
    run:
        dir: ./outputs/data_cvt_hydra_save/singlerun/${now:%Y%m%d_%H%M%S}  # Single run root dir
    sweep:
        dir: ./outputs/data_cvt_hydra_save/multirun/${now:%Y%m%d_%H%M%S}  # sweep root dir
        subdir: ${hydra:job.override_dirname}


    #Convert kuavo rosbag data into lerobot-parquet format configuration file
    #Please pay attention! ! !
    #The data conversion code of this branch is updated simultaneously with the lerobot version, and currently supports lerobot version 0.4.2
    #Due to version changes, the data conversion code, training, and inference codes have undergone major changes. Please be sure to install and use the lerobot0.4.2 version of the code for data conversion.
    #lerobot address: https://github.com/huggingface/lerobot

    rosbag:
    rosbag_dir: /path/to/your/rosbag #Directory where rosbag files are stored
    num_used: null #The number of rosbags used (if set to any number, random sampling will be selected), null means using all rosbags
    lerobot_dir: /your/path/to/your/lerobotdata/  #The directory where the converted lerobot files are saved will generate a lerobot subdirectory in this directory and store the corresponding data.
    chunk_size: 100  #This is the size setting that currently uses streaming to read the bag and process it in blocks. It has nothing to do with the one that imitates learning action blocks.

    dataset:
    #!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    only_arm: true  # Default is true, whether to use only arm data. Setting this to true automatically ignores all lower limb data.
    #!!!!!!!!!!!!Should be true for all tasks in this competition!!!!!!!!!!!!!!!
    #!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    eef_type: leju_claw #End effector type, simulation selection: rq2f85, real machine optional: leju_claw, (gripper) qiangnao, (dexterous hand)
    which_arm: right  #Which arm's joint + image data is needed, optional: left, right, both. Note that the image data will also include the head camera image.
    use_depth: False  #Do you need depth image data? Depth image data corresponding to the upper arm. Both act and dp of this branch support depth images.
    depth_range: [0, 1500]  #The clipping range of the depth map, in millimeters, will be used for normalization
    
    task_description: "Pick and Place" # Task description, change if desired

    train_hz: 10  # Training data sampling rate
    main_timeline: head_cam_h # Which cam is your main cam. Default is head_cam_h. Could be changed to wrist_cam_l, wrist_cam_r wrist cam if desired.
    main_timeline_fps: 30 # Main cam frame rate, must be stable. Default is 30fps.
    sample_drop: 10 # Drop 10 frames in the beginning and end of each episode.

    # dex_dof_needed is the dof needed for dex hand. The qiangnao dexhand has 6 dof, with fully closed being [100] * 6, fully open being [0] * 6.
    # 1: When precise operation or multi-finger coordinated operation is not required, it is usually set to 1, which means that only the first joint is needed as the basis for opening and closing.
    #    In this case, [0, 100, 0, 0, 0, 0] is used to represent the open state, and [100] * 6 represents the clenched fist state.
    # 2(Untested): 0,2,3,4,5 dof becomes a single dof.
    # 6(Untested): All 6 dof are available.
    dex_dof_needed: 1   # default=1

    is_binary: false  # Is open and close binary? default=false
    delta_action: false # Whether to use delta for action. default=false. Still under development
    relative_start: false # Whether to use relative start position. default=false


    resize:
        width: 848  #Image scaling width, please check first (recommended browser foxglove tool) the original size of the image in rosbag to avoid problems such as blurring or stretching deformation caused by enlarging or reducing.
        height: 480  #Image zoom height. Please check first (recommended browser foxglove tool) the original size of the image in rosbag to avoid problems such as blurring or stretching deformation caused by enlarging or reducing.


Model Inference Configuration File
--------------------------
main branch (config to modify is kuavo_real_env.yaml, parts that may need modification are commented)
^^^^^^^^^^^^^^^^^^^^^^^^
.. code-block:: bash

    hydra:  # Hydra config directory, for parameter checking only
    run:
        dir: ./outputs/kuavo_deploy_hydra_save/singlerun/${now:%Y%m%d_%H%M%S}  # Single run root dir
    sweep:
        dir: ./outputs/kuavo_deploy_hydra_save/multirun/${now:%Y%m%d_%H%M%S}  # sweep root dir
        subdir: ${hydra:job.override_dirname}


    # =====================================================
    # env config: Simulator-based Environment Configuration
    # =====================================================
    env:
    env_name: Kuavo-Real  # kuavo environment name. Default for simulator is Kuavo-Sim, real-device is Kuavo-Real
    control_mode: joint # joint or eef （eef still under development）
    eef_type: leju_claw  # End-effector type. rq2f85 for simulation. Real-device options being leju_claw (claw, used in this competition) or qiangnao (dexhand)
    which_arm: both  # Which arm joint + image data to use. Available options:left, right, both. Head cam data will be included regardless
    head_init: null  # Robot head initial position. Use this value for simulation so that the observation is consistent. Can be adjusted for real-device inferencing, typically being null!!
    ros_rate: 10  # Inference speed in Hz

    #!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    only_arm: true  # Default is true, whether to use only arm data. Setting this to true automatically ignores all lower limb data.
    #!!!!!!!!!!!!Should be true for all tasks in this competition!!!!!!!!!!!!!!!

    image_size: &IMGSIZE [848, 480]  # Img size: width, height
    depth_range: &DEPTHRANGE [0, 1500]  # Depth imaging range in mm, default=[0,1500]
    obs_key_map:  # Topic, msg type, freq, img size, depth crop. Must be consistent with training config!
        head_cam_h: ["/cam_h/color/image_raw/compressed", "CompressedImage", 30, *IMGSIZE]  # Head RGB img topic, COMPULSORY
        wrist_cam_l: ["/cam_l/color/image_raw/compressed", "CompressedImage", 30, *IMGSIZE]  # Left wrist RGB img topic, choose one between this and below
        wrist_cam_r: ["/cam_r/color/image_raw/compressed", "CompressedImage", 30, *IMGSIZE]  # Left wrist RGB img topic, choose one between this and above
        depth_h: ["/cam_h/depth/image_raw/compressedDepth", "CompressedImage", 30, *IMGSIZE, *DEPTHRANGE]  # Head depth topic, select if depth is needed
        depth_l: ["/cam_l/depth/image_rect_raw/compressedDepth", "CompressedImage", 30, *IMGSIZE, *DEPTHRANGE]  # Left wrist depth topic, select if depth is needed
        depth_r: ["/cam_r/depth/image_rect_raw/compressedDepth", "CompressedImage", 30, *IMGSIZE, *DEPTHRANGE]  # Right wrist depth topic, select if depth is needed
        joint_q: ["/sensors_data_raw", "sensorsData", 500]  # Joint angle topic, COMPULSORY
        # qiangnao: ["/dexhand/state", "JointState", 500]  # End-effector topic for dexterous hand
        leju_claw: ["/leju_claw_state", "lejuClawState", 500]  # End-effector topic for gripper-claw
        # rq2f85: ["/gripper/state", "JointState", 500]  # End-effector topic for simulator claw
    
    arm_state_keys: ["joint_q","gripper"]  # Do not change. Model observation arm state, with joint angles and gripper state.
    frame_alignment: false  # Frame alignment. default=false
    ratio: 1.0 # With frame alignment, this is the ratio of the latest observation vs all older observations. default=1.0
    
    # Limits joint values. I.e. upper and lower limit definitions. Do not change these.
    limits:
        # joint angle limits (7 joints per arm)
        joint_q:
            min: [-3.14, -3.14, -3.14, -3.14, -3.14, -3.14, -3.14, -3.14, -3.14, -3.14, -3.14, -3.14, -3.14, -3.14]
            max: [3.14, 3.14, 3.14, 3.14, 3.14, 3.14, 3.14, 3.14, 3.14, 3.14, 3.14, 3.14, 3.14, 3.14]
        
        # Gripper limits
        gripper:
            min: [0, 0]
            max: [1, 1]
        
        # End-effector limits
        eef:
            min: [-1, -1, -1, -3.14, -3.14, -3.14, -1, -1, -1, -3.14, -3.14, -3.14]
            max: [1, 1, 1, 3.14, 3.14, 3.14, 1, 1, 1, 3.14, 3.14, 3.14]
        
        # End-effector relative limits (for delta, currently in development)
        eef_relative:
            min: [-0.005, -0.0075, -0.004, -0.03, -0.03, -0.05, -0.005, -0.0075, -0.004, -0.03, -0.03, -0.05]
            max: [0.005, 0.0075, 0.004, 0.03, 0.03, 0.05, 0.005, 0.0075, 0.004, 0.03, 0.03, 0.05]
        
        # Robot movement limits (x, y, yaw, move_flag)
        base:
            min: [-2.0, -2.0, -3.14, 0]
            max: [2.0, 2.0, 3.14, 1]

    # It is NOT recommended to change these following configs

    # dex_dof_needed is the dof needed for dex hand. The qiangnao dexhand has 6 dof, with fully closed being [100] * 6, fully open being [0] * 6.
    # 1: When precise operation or multi-finger coordinated operation is not required, it is usually set to 1, which means that only the first joint is needed as the basis for opening and closing.
    #    In this case, [0, 100, 0, 0, 0, 0] is used to represent the open state, and [100] * 6 represents the clenched fist state.
    # 2(Untested): 0,2,3,4,5 dof becomes a single dof.
    # 6(Untested): All 6 dof are available.
    qiangnao_dof_needed: 1   # default=1

    is_binary: false  # Is open and close binary? default=false


    # =====================================================
    # inference config: Change here for inferencing configuration, both in sim and real-device
    # =====================================================
    inference:
        go_bag_path: /path/to/your/go.bag  #! ! ! Temporarily not used in the competition emulator! ! ! , the complete path of the bag needs to be provided during real-machine inference, such as reaching the pre-grab posture, etc. You can directly copy a trained rosbag control.
        policy_type: "act"  #Strategy name, supports diffusion, act, etc.
        pretrained_path: ""  #Optional: Directly specify the checkpoint / hf_ckpt path. If left blank, it will still be parsed according to outputs/train/<task>/<method>/<timestamp>/epoch<epoch>
        eval_episodes: 10  #The number of test rounds, the default value of the game simulator is 100, used for scoring
        seed: 42  #Random seeds can be used to fix the initial state of each object in simulation to facilitate reproduction.
        start_seed: 42  #The random seed at the beginning of the round can be used to fix the initial state of each object in the simulation to facilitate reproduction.
        device: "cuda"  # or "cpu"
        task: "your_task"
        method: "your_method"
        timestamp: "your_timestamp" #Similar runtime timestamp
        epoch: best  #Which epoch to use for training saving, you can fill in 50, 100, best, etc. Note: the code will load the model parameters of the policy in outputs/train/<task>/<method>/<timestamp>/epoch<epoch>
        max_episode_steps: 2000  #The maximum number of steps in a round will automatically end if exceeded and can be adjusted according to the required duration of the task.

        #Effective when policy_type=lingbot
        lingbot_root: ""  #Automatically find or read the environment variable LINGBOT_ROOT when left blank
        task_prompt: ""  #If left blank, return to inference.task
        lingbot_use_length: 1
        lingbot_chunk_ret: true
        lingbot_norm_stats_file: ""  #Optional: Custom norm_stats json
        lingbot_data_type: "robotwin"
        lingbot_execute_raw_action: false


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
