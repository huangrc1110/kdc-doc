.. _real::
**********
真机赛
**********

安装 `kuavo_data_challenge <https://github.com/LejuRobotics/kuavo_data_challenge>`_ （基准代码）仓库
======================================================================================================================================================
此仓库用于数据转换、模型训练、模型部署，使用 git 获取最新的代码仓库（tianchi 分支）：  

   .. code-block:: bash
      
      git clone --depth=1 https://github.com/LejuRobotics/kuavo_data_challenge.git  

   .. note::
      详细安装及使用步骤请参阅其在 GitHub 上的对应 `README <https://github.com/LejuRobotics/kuavo_data_challenge/blob/tianchi/README.md>`_ 文档。

真机赛任务介绍
================

任务简介
--------

真机赛中使用的机器人为乐聚夸父4pro（kauvo 4 pro），末端执行器为灵巧手/夹爪

任务一
^^^^^^^^^

桌面物料分拣：机器人站立不动，完成pick and place操作。 夹取安全带、线缆、pin口（三种零件）放到对应的空盒子中

.. video:: ../_static/videos/task1_real.mp4
   :width: 100%

任务二
^^^^^^^^^

工业零件质检：将机械套管承重，根据亮灯情况判断合格与不合格，并产品分别放在指定区域

.. video:: ../_static/videos/task2_real.mp4
   :width: 100%

任务三
^^^^^^^^^

汽车大件上料：将汽车钣金料抓取，放置到指定区域

.. video:: ../_static/videos/task3_real.mp4
   :width: 100%


任务评分
--------

每个任务将会测评十轮，最终得分为十轮得分的平均值

任务1：桌面物料分拣（100分）
^^^^^^^^^^^^^^^^^^^^^^^^^^^^

测评时，会随机放置三种物料（安全带、线缆、pin口），每种物料各一个，共三个，评分标准如下：

*   抓取成功且稳定：10分/每个物体，共30分
    
*   准确放至指定位置：20分/每个物体，共60分
    
*   全部完成奖励：10分

任务2：工业零件质检（100分）
^^^^^^^^^^^^^^^^^^^^^^^^^^^^

测评时，会在任意一排放置五个套管，需要将一排五个套管全部抓取完成，并根据“绿灯合格，红灯不合格”的规则放置，评分标准如下：

*   准确放至电子称：10分/每个套管，共50分

*   正确放至目标区域：10分/每个套管，共50分
    
    
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

    ########不需要修改#######
    hydra:
        run:
            dir: ./outputs/data_cvt_hydra_save/singlerun/${now:%Y%m%d_%H%M%S}
        sweep:
            dir: ./outputs/data_cvt_hydra_save/multirun/${now:%Y%m%d_%H%M%S}
            subdir: ${hydra:job.override_dirname}

    ########根据实际目录修改#######
    rosbag:
        rosbag_dir: /path/to/your/rosbag
        num_used: null 
        lerobot_dir: /path/to/your/lerobot/save/file
        chunk_size: 100

    dataset:
        only_arm: true  # 默认true, 是否只使用手臂数据
        eef_type: qiangnao # 真机可选：leju_claw, qiangnao，任务一二是夹爪 leju_claw，任务三是灵巧手 qiangnao
        which_arm: both  # 需要哪一只手臂的数据，可选: left, right, both，注意这会同时选择对应手臂的相机，已默认包含头部相机，任务一和三是单手操作，可以选right（但不是一定选），任务二必须选both
        use_depth: true  # 是否需要深度图像数据，与上面手臂保持一致的深度数据，目前本分支只有diffusion policy支持了深度，ACT policy暂不支持深度图像，但在dev分支中已经支持
        depth_range: [0, 1500]  # 深度图的裁剪范围，单位：毫米

        task_description: "Pick and Place"

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


模型推理配置文件
--------------------------
tianchi分支(可能需要修改的地方有注释)
^^^^^^^^^^^^^^^^^^^^^^^^
.. code-block:: bash

    hydra:
        run:
            dir: ./outputs/kuavo_deploy_hydra_save/singlerun/${now:%Y%m%d_%H%M%S} 
        sweep:
            dir: ./outputs/kuavo_deploy_hydra_save/multirun/${now:%Y%m%d_%H%M%S}
            subdir: ${hydra:job.override_dirname}

    env:
        env_name: Kuavo-Real  # kuavo环境名称，仿真Kuavo-Sim，真机Kuavo-Real
        control_mode: joint # joint 或 eef （正在开发中）
        eef_type: qiangnao  # 末端执行器类型，真机可选leju_claw或qiangnao: 根据任务使用的eef选择，任务一和二都是夹爪 leju_claw，任务三是灵巧手 qiangnao
        which_arm: both  # 需要哪一只手臂的数据，可选: left, right, both，注意这会同时选择对应手臂的相机，已默认包含头部相机；任务一和三是单手操作，可以选right（但不是一定选），任务二必须选both
        head_init: null  # 机器人头部初始位置，仿真请默认使用这个值，保持观测统一, 真机可根据需要调整，一般为null！！！
        ros_rate: 10  # 推理控制频率，单位Hz

        only_arm: true  # 默认true, 是否只使用手臂数据

        image_size: &IMGSIZE [848, 480]  # 图像大小：宽，高
        depth_range: &DEPTHRANGE [0, 1500]  # 深度图范围设置，单位mm，default=[0,1500]
        obs_key_map:  # 话题、消息类型、频率、图像尺寸、深度裁剪等配置，深度图范围设置，单位mm，default=[0,1500]，请注意需要与训练保持一致！
            head_cam_h: ["/cam_h/color/image_raw/compressed", "CompressedImage", 30, *IMGSIZE]  # 头部RGB相机话题，必选
            wrist_cam_l: ["/cam_l/color/image_raw/compressed", "CompressedImage", 30, *IMGSIZE]  # 左手腕RGB相机话题，请对应选择，与下至少选择一个
            wrist_cam_r: ["/cam_r/color/image_raw/compressed", "CompressedImage", 30, *IMGSIZE]  # 右手腕RGB相机话题，请对应选择，与上至少选择一个
            depth_h: ["/cam_h/depth/image_raw/compressedDepth", "CompressedImage", 30, *IMGSIZE, *DEPTHRANGE]  # 头部相机深度图话题，可与上述对应选
            depth_l: ["/cam_l/depth/image_rect_raw/compressedDepth", "CompressedImage", 30, *IMGSIZE, *DEPTHRANGE]  # 左手腕相机深度图话题，可与上述对应选
            depth_r: ["/cam_r/depth/image_rect_raw/compressedDepth", "CompressedImage", 30, *IMGSIZE, *DEPTHRANGE]  # 右手腕相机深度图话题，可与上述对应选
            joint_q: ["/sensors_data_raw", "sensorsData", 500]  # 关节角度话题，必选
            qiangnao: ["/dexhand/state", "JointState", 500]  # 末端执行器的话题，灵巧手
            #leju_claw: ["/leju_claw_state", "lejuClawState", 500]  # 末端执行器的话题，夹爪
            #rq2f85: ["/gripper/state", "JointState", 500]  # 末端执行器的话题，仿真中夹爪 # 根据选择的末端执行器类型，选择对应的话题，并确保与训练时一致
        
        arm_state_keys: ["joint_q","gripper"]  # 默认不动，模型观测输入的手臂状态包含关节角度和夹爪开合状态
        frame_alignment: false  # 是否启用帧对齐，default=false
        ratio: 1.0 # 使用帧对齐时，获取最近观测占所有历史观测的比例，default=1.0
        
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

        # 以下环境配置为不建议改动配置

        qiangnao_dof_needed: 1 

        is_binary: false 

    inference:
        go_bag_path: /path/to/your/go.bag # go_bag文件由主办方提供，选手不需要修改该参数
        policy_type: "act"  # 策略名字，支持diffusion，act等
        eval_episodes: 10  # 测试回合数，真机推理可以连续推理，设置为10或者大于10数值均可
        seed: 42 
        start_seed: 42  
        device: "cuda"
        task: "your_task"
        method: "your_method"
        timestamp: "your_timestamp"
        epoch: best  # 使用训练保存的哪一个epoch，可填50，100，best等，注意：代码将在outputs/train/<task>/<method>/<timestamp>/epoch<epoch>中load policy的模型参数
        max_episode_steps: 500  # 最大回合步数，真机建议设置为500即可

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

3. 后续步骤同仿真赛提交说明4-5，注意修改run_with_gpu.sh中的docker镜像名称为你刚刚打包的真机赛镜像名称即可。

真机赛成绩说明
================
真机赛的返回结果将包含以下内容：

1. 任务平均得分：十轮测试的平均总得分与小分
2. 每轮评测得分：每轮测试的总得分与小分
3. 每轮评测视频：每轮测试的机器人操作视频（第三视角）
4. log文件：每轮测试的详细log文件，来源 ``log/kuavo_deploy/kauavo_deploy.log``
