.. _real::
**********
真机赛
**********

安装 `kuavo_data_challenge <https://github.com/LejuRobotics/kuavo_data_challenge>`_ （基准代码）仓库
======================================================================================================================================================
此仓库用于数据转换、模型训练、模型部署，使用 git 获取最新的代码仓库（tianchi 分支）：  

   .. code-block:: bash
      
      git clone -b tianchi --depth=1 https://github.com/LejuRobotics/kuavo_data_challenge.git  

   .. note::
      详细安装及使用步骤请参阅其在 GitHub 上的对应 `README <https://github.com/LejuRobotics/kuavo_data_challenge/blob/tianchi/README.md>`_ 文档。

真机赛任务介绍
================

任务简介
--------

真机赛中使用的机器人为乐聚夸父4pro（kauvo 4 pro），末端执行器为灵巧手/夹爪

任务一
^^^^^^^^^

桌面物料分拣：夹取安全带、线缆、pin口（三种零件）放到对应的空盒子中

.. video:: ../_static/videos/task1_real.mov
   :width: 100%

任务二
^^^^^^^^^

工业零件称重：将机械套管称重，并放在收纳筐中

.. video:: ../_static/videos/task2_real.mov
   :width: 100%

任务三
^^^^^^^^^

汽车大件上料：稳定抓取汽车钣金料，并准确放置到指定区域上

.. video:: ../_static/videos/task3_real.mov
   :width: 100%


任务评分
--------

通用规则
^^^^^^^^^^^^^^^^^^^^^^^^^^^^

1. 真机赛包含 3 个独立任务。每个任务最高 100 分，并设有 10 分动作趋势评分项（只要存在动作趋势即可获得）。总最高得分为 300 分。

2. 每个任务固定进行 3 轮测评（每轮限时 3 分钟；超时后完成的动作不计分）。每轮单独评分，取 3 轮成绩的平均分作为该任务最终得分。

3. 同分排名规则：若队伍总分相同，则按所有任务全部轮次的平均完成时间从短到长排序。


任务1：桌面物料分拣（100分）
^^^^^^^^^^^^^^^^^^^^^^^^^^^^

测评时，会随机位置放置三种物料（安全带、线缆、pin口），每种物料各一个，共三个。夹取物品后，需要将物品放在盒子的指定空位处，顺序从左到右依次是：pin口、安全带、线缆。评分标准如下：

*   抓取成功且稳定：10分/每个物体，共30分
    
*   准确放至指定位置：15分/每个物体，共45分
    
*   全部完成奖励：25分

任务2：工业零件称重（100分）
^^^^^^^^^^^^^^^^^^^^^^^^^^^^

测评时，会在指定一排放置三个套管。机器人需要依次抓取套管，将套管放置到称重台上完成称重，再从称重台拾起并稳定放入指定收纳筐中，评分标准如下：

*   抓取成功且稳定：10分/每个套管，共30分

*   准确放至称重台并完成称重：10分/每个套管，共30分

*   从称重台再次拾取成功：5分/每个套管，共15分

*   稳定放入指定收纳筐：前两个套管各5分，最后一个套管15分，共25分
    
    
任务3：汽车大件上料（100分）
^^^^^^^^^^^^^^^^^^^^^^^^^^^^

*   抓取成功且稳定：40分
    
*   准确放至指定位置：60分

真机赛数据介绍
================
.. note::
    真机视频的size是848*480，区别于仿真数据的640*480

与仿真赛类似，我们提供的真机数据是原生的rosbag，各位选手可根据需要自行处理。真机数据的话题名称、话题内容、数据格式等均与仿真数据相同（除视频图像尺寸）。若仍然使用kuavo_data_challenge的baseline代码框架，则可完全按照之前仿真数据的数据转换、训练、推理流程。需要修改的部分是config文件中的部分配置。

考虑到在仿真赛环节大家的算力等问题，首批真机数据为每个任务1000条。若后续测试过程中诊断为数据量不够导致模型性能表现不佳，可以联系主办方补充数据。


真机数据下载地址(modelscope)
-------------------------
https://www.modelscope.cn/datasets/lejurobot/LET-Tianchi-Dataset


真机赛配置文件说明(可对照修改，最好不要直接复制粘贴)
========================
数据转换（可能需要修改的地方有注释）
--------------------------
.. code-block:: bash

    hydra:
      run:
        dir: ./outputs/data_cvt_hydra_save/singlerun/${now:%Y%m%d_%H%M%S}
      sweep:
        dir: ./outputs/data_cvt_hydra_save/multirun/${now:%Y%m%d_%H%M%S}
        subdir: ${hydra:job.override_dirname}

    # 将 kuavo rosbag 转换为 lerobot-parquet 格式，请使用 lerobot 0.4.2。
    rosbag:
      rosbag_dir: /path/to/your/rosbag  # rosbag目录
      num_used: null  # null表示使用全部rosbag
      lerobot_dir: /your/path/to/your/lerobotdata/  # 转换结果目录
      chunk_size: 100  # 流式读取分块大小

    dataset:
      only_arm: true  # 是否只使用手臂数据
      eef_type: leju_claw  # 真机：leju_claw / qiangnao；仿真：rq2f85
      which_arm: both  # left / right / both
      use_depth: false  # 是否使用深度图像
      depth_range: [0, 1500]  # 深度裁剪范围，单位毫米

      task_description: "Pick and Place"

      train_hz: 10
      main_timeline: head_cam_h  # 主相机
      main_timeline_fps: 30
      sample_drop: 10

      # 强脑灵巧手自由度设置；一般非精细操作保持为1。
      dex_dof_needed: 1

      is_binary: false
      delta_action: false
      relative_start: false

      resize:
        width: 848
        height: 480


模型推理配置文件
--------------------------
tianchi分支(可能需要修改的地方有注释)
^^^^^^^^^^^^^^^^^^^^^^^^
.. code-block:: bash

    # Kuavo 统一推理配置
    hydra:
      run:
        dir: ./outputs/kuavo_deploy_hydra_save/singlerun/${now:%Y%m%d_%H%M%S}
      sweep:
        dir: ./outputs/kuavo_deploy_hydra_save/multirun/${now:%Y%m%d_%H%M%S}
        subdir: ${hydra:job.override_dirname}

    # 环境配置
    env:
      env_name: Kuavo-Real  # 真机 Kuavo-Real，仿真 Kuavo-Sim
      control_mode: joint  # joint / eef
      eef_type: leju_claw  # 真机 leju_claw / qiangnao；仿真 rq2f85
      which_arm: both  # left / right / both
      head_init: null  # 真机一般设为 null
      ros_rate: 10

      only_arm: true

      image_size: &IMGSIZE [848, 480]
      depth_range: &DEPTHRANGE [0, 1500]  # 单位 mm
      obs_key_map:  # 需与训练配置保持一致；末端部分需要与本配置中eef_type类型保持一致，其余末端建议暂时注释
        head_cam_h: ["/cam_h/color/image_raw/compressed", "CompressedImage", 30, *IMGSIZE]
        wrist_cam_l: ["/cam_l/color/image_raw/compressed", "CompressedImage", 30, *IMGSIZE]
        wrist_cam_r: ["/cam_r/color/image_raw/compressed", "CompressedImage", 30, *IMGSIZE]
        depth_h: ["/cam_h/depth/image_raw/compressedDepth", "CompressedImage", 30, *IMGSIZE, *DEPTHRANGE]
        depth_l: ["/cam_l/depth/image_rect_raw/compressedDepth", "CompressedImage", 30, *IMGSIZE, *DEPTHRANGE]
        depth_r: ["/cam_r/depth/image_rect_raw/compressedDepth", "CompressedImage", 30, *IMGSIZE, *DEPTHRANGE]
        joint_q: ["/sensors_data_raw", "sensorsData", 500]
        # qiangnao: ["/dexhand/state", "JointState", 500] 
        leju_claw: ["/leju_claw_state", "lejuClawState", 500]
        # rq2f85: ["/gripper/state", "JointState", 500]

      arm_state_keys: ["joint_q","gripper"]
      frame_alignment: false
      ratio: 1.0

      limits:  # 一般不建议修改
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

      qiangnao_dof_needed: 1  # 强脑手自由度，一般保持默认
      is_binary: false

    # 模型推理配置
    inference:
      go_bag_path: /path/to/your/go.bag  # 初始包由官方统一提供，选手不需要修改或引用
      policy_type: "act"  # 支持 diffusion / act 等
      eval_episodes: 3
      seed: 42
      start_seed: 42
      device: "cuda"
      task: "your_task"
      method: "your_method"
      timestamp: "your_timestamp"
      epoch: best
      max_episode_steps: 2000 # 测试后建议2000轮

真机赛提交说明
================
跟仿真赛同理，真机赛代码提交也是环境和代码打包为 docker 镜像。具体步骤如下：
1. 配置docker加速，打包环境：可参考仿真赛 `提交说明 docker/readme <https://github.com/LejuRobotics/kuavo_data_challenge/blob/main/docker/readme.md>`_ 步骤1-2

2. 复制以下Dockerfile模板（专为真机赛的定制版），修改必要参数，例如Conda环境名、Conda环境包名、添加额外必要系统、python包等，保存为项目根目录下的 ``Dockerfile``

   .. code-block:: dockerfile
      
      # =========================
      # Stage 1: Builder
      # =========================
      FROM ros:noetic-ros-core-focal AS builder

      ARG DEBIAN_FRONTEND=noninteractive

      # 国内APT源
      RUN sed -i 's/archive.ubuntu.com/mirrors.tuna.tsinghua.edu.cn/g' /etc/apt/sources.list && \
         sed -i 's/security.ubuntu.com/mirrors.tuna.tsinghua.edu.cn/g' /etc/apt/sources.list

      # 安装必要工具和ROS依赖
      RUN apt-get update && apt-get install -y \
         curl wget gnupg2 lsb-release sudo ca-certificates build-essential bzip2 \
         ros-noetic-cv-bridge \
         ros-noetic-apriltag-ros \
         && rm -rf /var/lib/apt/lists/*

      # 安装 Miniforge
      ENV MINIFORGE_URL="https://mirrors.tuna.tsinghua.edu.cn/github-release/conda-forge/miniforge/LatestRelease/Miniforge3-Linux-x86_64.sh"
      RUN curl -L ${MINIFORGE_URL} -o /tmp/miniforge.sh \
         && bash /tmp/miniforge.sh -b -p /opt/conda \
         && rm /tmp/miniforge.sh

      ENV PATH="/opt/conda/bin:${PATH}"
      ENV LANG=C.UTF-8
      ENV LC_ALL=C.UTF-8

      # 配置国内镜像并安装 mamba
      RUN conda config --add channels https://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud/conda-forge/ \
         && conda config --set show_channel_urls yes \
         && conda install -y mamba -c conda-forge

      # 工作目录
      WORKDIR /root/kuavo_data_challenge
      COPY . .

      # 解压 Conda 环境并安装项目
      # TODO: 修改Conda环境名和包名，请确保每一个myenv都修改全
      RUN if [ -f "myenv.tar.gz" ]; then \
            mkdir -p ./myenv && tar -xzf myenv.tar.gz -C ./myenv && rm myenv.tar.gz; \
         fi && \
         /bin/bash -c "\
            source ./myenv/bin/activate && \
            conda-unpack && \
            pip install -e . && \
            cd ./third_party/lerobot && pip install -e . -i https://mirrors.aliyun.com/pypi/simple/ && \
            pip install deprecated kuavo_humanoid_sdk==1.3.3 opencv-python==4.12.0.88 opencv-python-headless==4.12.0.88 numpy==2.2.6 -i https://mirrors.aliyun.com/pypi/simple/ && \
            conda clean -afy && \
            rm -rf ./myenv/lib/python*/site-packages/*/tests ./myenv/lib/python*/site-packages/*/test ./myenv/pkgs/* \
         "

      # =========================
      # Stage 2: Final
      # =========================
      FROM ros:noetic-ros-core-focal

      # 设置工作目录
      WORKDIR /root/kuavo_data_challenge

      # 复制 Conda 环境和项目代码
      COPY --from=builder /opt/conda /opt/conda
      COPY --from=builder /root/kuavo_data_challenge /root/kuavo_data_challenge

      # 环境变量
      ENV PATH="/opt/conda/bin:${PATH}"
      ENV LANG=C.UTF-8
      ENV LC_ALL=C.UTF-8

      RUN sed -i 's/archive.ubuntu.com/mirrors.tuna.tsinghua.edu.cn/g' /etc/apt/sources.list && \
         sed -i 's/security.ubuntu.com/mirrors.tuna.tsinghua.edu.cn/g' /etc/apt/sources.list
      # TODO: 如果需要安装其它系统包，请在这里插入
      RUN apt-get update && apt-get install -y \
         ros-noetic-cv-bridge \
         ros-noetic-apriltag-ros \
         && rm -rf /var/lib/apt/lists/*

      # 保留 ROS 环境变量
      # 激活 Conda 环境
      RUN echo "source /opt/ros/noetic/setup.bash" >> /root/.bashrc && \
         echo "source /root/kuavo_data_challenge/myenv/bin/activate" >> /root/.bashrc && \
         echo "chmod 777 -R /root/kuavo_data_challenge/kuavo_deploy" >> /root/.bashrc && \
         echo "export ROS_IP=192.168.26.10" >> /root/.bashrc && \
         echo "export ROS_MASTER_URI=http://kuavo_master:11311" >> /root/.bashrc

      # 默认命令
      CMD ["bash"]

3. 后续步骤同仿真赛提交说明4-5，注意修改 ``run_with_gpu.sh`` 中的docker镜像名称为你刚刚打包的真机赛镜像名称即可。
    .. code-block:: bash
        
        #!/bin/bash

        IMAGE_NAME="kdc_v0"
        CONTAINER_NAME="kdc_v0"
        IMAGE_TAR="${IMAGE_NAME}.tar"   # 镜像文件路径

        # 如果容器存在，先删除
        if [ "$(docker ps -aq -f name=${CONTAINER_NAME})" ]; then
            echo "Container exists. Removing..."
            docker rm -f ${CONTAINER_NAME}
        fi

        # 检查镜像是否存在，如果存在则删除
        EXISTING_IMAGE=$(docker images -q $IMAGE_NAME)
        if [ "$EXISTING_IMAGE" ]; then
            echo "Image $IMAGE_NAME already exists. Removing..."
            docker rmi -f $IMAGE_NAME
        fi

        # 直接加载镜像
        if [ -f "$IMAGE_TAR" ]; then
            echo "Loading image from $IMAGE_TAR..."
            docker load -i "$IMAGE_TAR"
        else
            echo "Error: $IMAGE_TAR not found!"
            exit 1
        fi

        # 创建并启动新的容器
        docker run --gpus all -it \
            --net=host \
            -e ROS_MASTER_URI=http://kuavo_master:11311 \
            -e ROS_IP=192.168.26.10 \
            --name ${CONTAINER_NAME} \
            ${IMAGE_NAME} bash

真机赛成绩说明
================
真机赛的返回结果将包含以下内容：

1. 任务平均得分：三轮测试的平均总得分与小分
2. 每轮评测得分：每轮测试的总得分与小分
3. 每轮评测视频：每轮测试的机器人操作视频（第三视角）
4. log文件：每轮测试的详细log文件，来源 ``log/kuavo_deploy/kauavo_deploy.log``
