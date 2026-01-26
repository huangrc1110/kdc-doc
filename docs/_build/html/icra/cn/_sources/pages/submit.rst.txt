.. _submit:
 
**********
Submission
**********


Code Submission and Evaluation
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Refer to the `kuavo_data_challenge repository icra branch docker/readme <https://github.com/LejuRobotics/kuavo_data_challenge/tree/main/docker/readme.md>`_ to package your environment and code into a Docker image and submit it to the `competition website <https://www.kdc.icra.lejurobot.com/home>`_.

Evaluation results and the leaderboard will be published on the competition website.

Important Notes
=============================================

1. The final submission must be a ZIP archive containing two files: a Docker image TAR file and `run_with_gpu.sh`
.

2. Please name both the TAR file and the ZIP archive as `team_or_individual_name_task{i}`. If your team name is in Chinese, you may use initials or your personal name instead. For example, if your team name is “Leju Zhandui” and your name is “kuavo”, and you are submitting for Task 2, your TAR file should be named either `lejuzhandui_task2.tar` or `kuavo_task2.tar`. The final ZIP file should have the same name. Also, ensure that `IMAGE_NAME` and `CONTAINER_NAME` inside `run_with_gpu.sh` are updated accordingly to match this naming convention; otherwise, the container may fail to run
.

3. Before packaging the image, make sure to properly configure `kuavo_sim_env.yaml`: set the number of evaluation episodes (`eval_episodes`) to 100, and ensure the maximum episode steps (`max_episode_steps`) do not exceed 300 (Tasks 1 & 2) or 600 (Task 3)
.

4. Normally, you can use the standard submission entry to upload your file. If the file is too large and fails to upload, please try re-uploading
.

5. Before submitting, confirm that you have successfully joined a team (individual participants may skip this step). If you change teams or join a team after submitting and receiving a score, your previous score will be invalidated. Only one team member needs to submit—please avoid duplicate submissions
.

6. The official evaluation system closely resembles the local evaluation setup in the repository. We strongly recommend testing your model locally before submission to debug and optimize performance, thereby conserving shared evaluation resources
.

7. After submission, if evaluation succeeds, your score will appear on the Tianchi competition submission page. If evaluation fails, an error message will be displayed—please verify that your submitted files are correct
.

Video Tutorial (You may fast-forward through the packaging process)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   .. video:: ../_static/videos/submit_instruction.mp4
      :width: 100%

Copy the following Dockerfile template (customized for the simulation track), modify necessary parameters such as the Conda environment name, Conda environment package name, and add any additional required system or Python packages. Save it as ``Dockerfile`` in your project root directory.
   
   .. code-block:: dockerfile
      
      # =========================
      # Stage 1: Builder
      # =========================
      FROM ros:noetic-ros-core-focal AS builder
      
      ARG DEBIAN_FRONTEND=noninteractive
      
      RUN sed -i 's/archive.ubuntu.com/mirrors.tuna.tsinghua.edu.cn/g' /etc/apt/sources.list && \
         sed -i 's/security.ubuntu.com/mirrors.tuna.tsinghua.edu.cn/g' /etc/apt/sources.list
      
      RUN apt-get update && apt-get install -y \
         curl wget gnupg2 lsb-release sudo ca-certificates build-essential bzip2 \
         ros-noetic-cv-bridge \
         ros-noetic-apriltag-ros \
         && rm -rf /var/lib/apt/lists/*
      
      ENV MINIFORGE_URL="https://mirrors.tuna.tsinghua.edu.cn/github-release/conda-forge/miniforge/LatestRelease/Miniforge3-Linux-x86_64.sh"
      RUN curl -L ${MINIFORGE_URL} -o /tmp/miniforge.sh \
         && bash /tmp/miniforge.sh -b -p /opt/conda \
         && rm /tmp/miniforge.sh
      
      ENV PATH="/opt/conda/bin:${PATH}"
      ENV LANG=C.UTF-8
      ENV LC_ALL=C.UTF-8
      
      RUN conda config --add channels https://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud/conda-forge/ \
         && conda config --set show_channel_urls yes \
         && conda install -y mamba -c conda-forge
      
      WORKDIR /root/kuavo_data_challenge
      COPY . .
      
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
      
      WORKDIR /root/kuavo_data_challenge
      
      COPY --from=builder /opt/conda /opt/conda
      COPY --from=builder /root/kuavo_data_challenge /root/kuavo_data_challenge
      
      ENV PATH="/opt/conda/bin:${PATH}"
      ENV LANG=C.UTF-8
      ENV LC_ALL=C.UTF-8
      
      RUN sed -i 's/archive.ubuntu.com/mirrors.tuna.tsinghua.edu.cn/g' /etc/apt/sources.list && \
         sed -i 's/security.ubuntu.com/mirrors.tuna.tsinghua.edu.cn/g' /etc/apt/sources.list
      RUN apt-get update && apt-get install -y \
         ros-noetic-cv-bridge \
         ros-noetic-apriltag-ros \
         && rm -rf /var/lib/apt/lists/*
      
      RUN echo "source /opt/ros/noetic/setup.bash" >> /root/.bashrc && \
         echo "source /root/kuavo_data_challenge/myenv/bin/activate" >> /root/.bashrc && \
         echo "chmod 777 -R /root/kuavo_data_challenge/kuavo_deploy" >> /root/.bashrc && \
         echo "export ROS_IP=127.0.0.1" >> /root/.bashrc && \
         echo "export ROS_MASTER_URI=http://127.0.0.1:11311" >> /root/.bashrc
      
      CMD ["bash"]


Real-Robot Competition Code Submission and Evaluation
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Similar to the simulation track, submissions for the real-robot track also require packaging your environment and code into a Docker image and uploading it to the `competition website <https://www.kdc.icra.lejurobot.com/home>`_. The specific steps are as follows:

1. Configure Docker acceleration and package the environment: refer to Steps 1–2 in the simulation track’s `submission instructions (docker/readme) <https://github.com/LejuRobotics/kuavo_data_challenge/blob/main/docker/readme.md>`_.

2. Copy the following Dockerfile template (customized for the real-robot track), modify necessary parameters such as the Conda environment name, Conda environment package name, and add any additional required system or Python packages. Save it as ``Dockerfile`` in your project root directory.

   .. code-block:: dockerfile
      
      # =========================
      # Stage 1: Builder
      # =========================
      FROM ros:noetic-ros-core-focal AS builder
      ARG DEBIAN_FRONTEND=noninteractive
      # Use domestic APT mirrors
      RUN sed -i 's/archive.ubuntu.com/mirrors.tuna.tsinghua.edu.cn/g' /etc/apt/sources.list && \
      sed -i 's/security.ubuntu.com/mirrors.tuna.tsinghua.edu.cn/g' /etc/apt/sources.list
      # Install essential tools and ROS dependencies
      RUN apt-get update && apt-get install -y \
      curl wget gnupg2 lsb-release sudo ca-certificates build-essential bzip2 \
      ros-noetic-cv-bridge \
      ros-noetic-apriltag-ros \
      && rm -rf /var/lib/apt/lists/*
      # Install Miniforge
      ENV MINIFORGE_URL="https://mirrors.tuna.tsinghua.edu.cn/github-release/conda-forge/miniforge/LatestRelease/Miniforge3-Linux-x86_64.sh"
      RUN curl -L ${MINIFORGE_URL} -o /tmp/miniforge.sh \
      && bash /tmp/miniforge.sh -b -p /opt/conda \
      && rm /tmp/miniforge.sh
      ENV PATH="/opt/conda/bin:${PATH}"
      ENV LANG=C.UTF-8
      ENV LC_ALL=C.UTF-8
      # Configure domestic Conda mirrors and install mamba
      RUN conda config --add channels https://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud/conda-forge/ \
      && conda config --set show_channel_urls yes \
      && conda install -y mamba -c conda-forge
      # Working directory
      WORKDIR /root/kuavo_data_challenge
      COPY . .
      # Extract Conda environment and install the project
      # TODO: Replace "myenv" with your actual Conda environment name and package filename throughout
      RUN if [ -f "myenv.tar.gz" ]; then \
          mkdir -p ./myenv && tar -xzf myenv.tar.gz -C ./myenv && rm myenv.tar.gz; \
      fi && \
      /bin/bash -c "\
          source ./myenv/bin/activate && \
          conda-unpack && \
          pip install -e . && \
          cd ./third_party/lerobot && pip install -e . -i https://mirrors.aliyun.com/pypi/simple/ && \
          pip install deprecated kuavo_humanoid_sdk==1.2.2 opencv-python==4.11.0.86 opencv-python-headless==4.11.0.86 numpy==1.26.4 -i https:mirrors.aliyun.com/pypi/simple/ && \
          conda clean -afy && \
          rm -rf ./myenv/lib/python*/site-packages/*/tests ./myenv/lib/python*/site-packages/*/test ./myenv/pkgs/* \
      "
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
      # TODO: Add any additional system packages here if needed
      RUN apt-get update && apt-get install -y \
      ros-noetic-cv-bridge \
      ros-noetic-apriltag-ros \
      && rm -rf /var/lib/apt/lists/*
      # Preserve ROS environment variables
      # Activate Conda environment
      RUN echo "source /opt/ros/noetic/setup.bash" >> /root/.bashrc && \
      echo "source /root/kuavo_data_challenge/myenv/bin/activate" >> /root/.bashrc && \
      echo "chmod 777 -R /root/kuavo_data_challenge/kuavo_deploy" >> /root/.bashrc && \
      echo "export ROS_IP=192.168.26.10" >> /root/.bashrc && \
      echo "export ROS_MASTER_URI=http://kuavo_master:11311" >> /root/.bashrc
      # Default command
      CMD ["bash"]

3. Build the Docker image and export it as a TAR file: as in the simulation track, place the `Dockerfile` in your project root and run:
   ```
   sudo docker build -t kdc_v0 .
   ```
   Then export using:
   ```
   sudo docker save -o your_docker_image.tar kdc_v0:latest
   ```

4. Rename the exported image according to the competition’s naming requirements. Package it together with the correct `run_with_gpu.sh` into a highly compressed ZIP archive, rename the ZIP file accordingly, and submit it to the `competition website <https://www.kdc.icra.lejurobot.com/home>`_.

Evaluation results and the leaderboard will be published on the competition website.