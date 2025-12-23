.. _submit:
 
**********
提交说明
**********


仿真赛代码提交与评测
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

参考 `kuavo_data_challenge仓库 main 分支的 docker/readme <https://github.com/LejuRobotics/kuavo_data_challenge/blob/main/docker/readme.md>`_ ,将环境和代码打包为 docker 镜像提交至 `比赛官网 <https://tianchi.aliyun.com/competition/entrance/532415>`_ 。

评测结果和排行榜将在比赛官网公布。

注意事项
=============================================

1. 最终提交的文件为zip压缩包, 里面包含两个文件, docker镜像tar文件, run_with_gpu.sh
。

2. 请各位选手将tar文件和zip压缩包的名字定义为  队伍/个人姓名_task{i}, 若队伍为中文可以用首字母或用个人姓名。例如我的队伍名是乐聚战队,我的姓名是kuavo,此次提交的是任务2,我的tar文件就叫lejuzhandui_task2.tar或者kuavo_task2.tar,最后提交的zip也是一样的名字。需要注意的是,run_with_gpu.sh中需要将IMAGE_NAME和CONTAINER_NAME也改成对应的名字,以免无法运行
。

3. 打包镜像前, 一定要注意把kuavo_sim_env.yaml里的配置改好, 测试回合数(eval_episodes)为100回合,最大回合步数(max_episode_steps)不超过300(任务一和二)、600(任务三)、1000(任务四), 一般200(任务一和二)、500(任务三)、800(任务四)是足够的
。

4. 提交时, 一般情况使用提交结果入口即可正常提交。若文件过大导致上传失败(一般超过5G会出现这种情况), 可使用上传超大文件入口。注意上传超大文件里的命令每隔一小时会刷新
。

5. 提交前，请先确认好已经成功加入队伍(个人选手可以不用)，若提交并获得到成绩后更改队伍或加入队伍，之前的成绩会作废。每队仅需一名选手提交, 请勿重复提交
。

6. 官方评测系统和本地仓库评测系统类似，各位选手提交前可以先在本地测试自己的模型性能，以便随时修改自己的代码，性能调试后再提交，以免过多浪费其他选手的评测资源
。

7. 提交后，若评测成功，可以在天池竞赛提交页看到自己的分数，若评测失败，会显示评测失败并显示原因，此时请检查提交的文件是否正确
。

视频教程(下载打包过程可快进)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   .. video:: ../_static/videos/submit_instruction.mp4
      :width: 100%


真机赛代码提交与评测
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

跟仿真赛同理，真机赛代码提交也是环境和代码打包为 docker 镜像，之后提交至 `比赛官网 <https://tianchi.aliyun.com/competition/entrance/532415>`_ 。具体步骤如下：

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
            pip install deprecated kuavo_humanoid_sdk==1.2.2 opencv-python==4.11.0.86 opencv-python-headless==4.11.0.86 numpy==1.26.4 -i https://mirrors.aliyun.com/pypi/simple/ && \
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

3. 构建 Docker 镜像并导出为tar文件：跟仿真赛提交同理，将Dockerfile放置于项目根目录下，运行指令 ``sudo docker build -t kdc_v0 .``，然后用 ``sudo docker save -o your_docker_image.tar kdc_v0:latest`` 导出

4. 按照赛事提交文件名要求重命名导出的镜像。跟正确的 ``run_with_gpu.sh`` 打包成一个高压缩率的压缩包，按照赛事要求，重命名压缩包后方可提交至 `比赛官网 <https://tianchi.aliyun.com/competition/entrance/532415>`_

评测结果和排行榜将在比赛官网公布。

注意事项
=============================================

1. 最终提交的文件为zip压缩包, 里面包含两个文件, docker镜像tar文件, run_with_gpu.sh
。

2. 请各位选手将tar文件和zip压缩包的名字定义为  队伍/个人姓名_task{i}, 若队伍为中文可以用首字母或用个人姓名。例如我的队伍名是乐聚战队,我的姓名是kuavo,此次提交的是任务2,我的tar文件就叫lejuzhandui_task2.tar或者kuavo_task2.tar,最后提交的zip也是一样的名字。需要注意的是,run_with_gpu.sh中需要将IMAGE_NAME和CONTAINER_NAME也改成对应的名字,以免无法运行
。

3. 打包镜像前, 一定要注意把kuavo_real_env.yaml里的配置改好, 按照之前仿真赛kuavo_sim_env.yaml改了的几处就行。测试回合数(eval_episodes)为100回合,最大回合步数(max_episode_steps)不超过300(任务一和二)、600(任务三), 一般200(任务一和二)、500(任务三)是足够的
。

4. 提交时, 一般情况使用提交结果入口即可正常提交。若文件过大导致上传失败(一般超过5G会出现这种情况), 可使用上传超大文件入口。注意上传超大文件里的命令每隔一小时会刷新
。

5. 提交前，请先确认好已经成功加入队伍(个人选手可以不用)，若提交并获得到成绩后更改队伍或加入队伍，之前的成绩会作废。每队仅需一名选手提交, 请勿重复提交
。

6. 官方评测系统和本地仓库评测系统类似，各位选手提交前可以先在本地测试自己的模型性能，以便随时修改自己的代码，性能调试后再提交，以免过多浪费其他选手的评测资源
。

7. 提交后，若评测成功，可以在天池竞赛提交页看到自己的分数，若评测失败，会显示评测失败并显示原因，此时请检查提交的文件是否正确
。