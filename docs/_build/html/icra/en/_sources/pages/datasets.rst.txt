.. _kuavo-dataset:

**********
Datasets
**********

For maximum preservation of the valuable information contained in the original data, all of this competition's datasets are in rosbag format. Competitors can freely use the abundant sources of sensor data inside the rosbag files for their model training.

Downloading Datasets
=========================================
   Dataset downloads are all done through the Alibaba Cloud's Object Storage Service (OSS). A guide is as follows:

   a. Downloading & Installing ossutil

      - Linux/macOS One-click Installation (Recommended)

        .. code-block:: bash

           sudo -v ; curl https://gosspublic.alicdn.com/ossutil/install.sh | sudo bash

        .. note::

           The installation process require a decompression tool (such as unzip or 7zip), please install as needed. ``ossutil`` will be installed under ``/usr/bin/`` by default.

      - Download Link

         .. list-table::
            :header-rows: 1
            :widths: 18 82

            * - Platform
              - Address 
            * - Linux x86_64
              - `ossutil-v1.7.19-linux-amd64.zip <https://gosspublic.alicdn.com/ossutil/1.7.19/ossutil-v1.7.19-linux-amd64.zip>`__
            * - Linux x86_32
              - `ossutil-v1.7.19-linux-386.zip <https://gosspublic.alicdn.com/ossutil/1.7.19/ossutil-v1.7.19-linux-386.zip>`__
            * - Linux arm_64
              - `ossutil-v1.7.19-linux-arm64.zip <https://gosspublic.alicdn.com/ossutil/1.7.19/ossutil-v1.7.19-linux-arm64.zip>`__
            * - Windows x64
              - `ossutil-v1.7.19-windows-amd64.zip <https://gosspublic.alicdn.com/ossutil/1.7.19/ossutil-v1.7.19-windows-amd64.zip>`__
            * - Windows x32
              - `ossutil-v1.7.19-windows-386.zip <https://gosspublic.alicdn.com/ossutil/1.7.19/ossutil-v1.7.19-windows-386.zip>`__
            * - macOS 64
              - `ossutil-v1.7.19-mac-amd64.zip <https://gosspublic.alicdn.com/ossutil/1.7.19/ossutil-v1.7.19-mac-amd64.zip>`__
            * - macOS arm_64
              - `ossutil-v1.7.19-mac-arm64.zip <https://gosspublic.alicdn.com/ossutil/1.7.19/ossutil-v1.7.19-mac-arm64.zip>`__


      - Manual Installation Method

        .. code-block:: bash

           # 1. 下载压缩包（以 Linux x64 为例）
           wget https://gosspublic.alicdn.com/ossutil/1.7.19/ossutil-v1.7.19-linux-amd64.zip
           # 2. 解压
           unzip ossutil-v1.7.19-linux-amd64.zip
           # 3. 添加执行权限
           chmod +x ossutil
           # 4. 移动到系统 PATH 目录（可选）
           sudo mv ossutil /usr/local/bin/

   b. Install Verification

      .. code-block:: bash

         ossutil

      When it shows the usage help page, it means the installation is successful. If it asks you for an update, perform as needed:

      .. code-block:: bash

         ossutil update

   c. ossutil Configuration

      Interactive Configuration (Recommended)

      .. code-block:: bash

         ossutil config

      Enter as prompted: 

      - Default configuration file path: ``~/.ossutilconfig``, simply press Enter to use the default path
      - Language settings: Enter ``CH`` for Simplified Chinese, or ``EN`` for English
      - Endpoint：``https://oss-cn-hangzhou.aliyuncs.com``
      - AccessKey ID：``LTAI5tJCN2XX2sYt6wWhdvqk``
      - AccessKey Secret：``xbROt0HCaQexY2JrLl2UDScvS3qHpj``

      When it prompts you for ``stsToken``, don't enter anything and simply press Enter. The order of this appearance may vary on your end.

   d. Testing the Configuration & its Usage

      - Testing this configuration

        .. code-block:: bash

           # 输出指定桶名下的文件夹（不包含子文件）
           ossutil ls oss://kuavo-data-challenge-simdata/ -d

        If it shows the directory list, it means the configuration is valid.

      - Listing the directory information

        .. code-block:: bash

           # 列出指定存储空间的对象（不包括子目录）
           ossutil ls oss://kuavo-data-challenge-simdata/ -d
           # 递归列出所有对象（包括子目录）
           ossutil ls oss://kuavo-data-challenge-simdata/
           # 递归列出指定前缀的对象（包括子目录）
           ossutil ls oss://kuavo-data-challenge-simdata/folder-name/

      - Viewing target details

        .. code-block:: bash

           # 查看单个对象的详细信息
           ossutil stat oss://kuavo-data-challenge-simdata/file-name
           # 查看特定路径对象个数与空间占用
           ossutil du oss://kuavo-data-challenge-simdata/file-name

      - File(s) searching

        .. code-block:: bash

           # 按文件名模式搜索 --include
           ossutil ls oss://kuavo-data-challenge-simdata/ --include "*.jpg"
           # 排除特定文件 --exclude
           ossutil ls oss://kuavo-data-challenge-simdata/ --exclude "*.tmp"
           # 组合使用包含与排除
           ossutil ls oss://kuavo-data-challenge-simdata/ --include "*.log" --exclude "*debug*"

   e. How to Download Our Data

      - Downloading an individual file

        .. code-block:: bash

           # 下载文件到当前目录
           ossutil cp oss://kuavo-data-challenge-simdata/<file-path>/<file-name> ./

           # 下载文件并重命名
           ossutil cp oss://kuavo-data-challenge-simdata/<file-path>/<file-name> <local-path>/<local-name>

           # 下载文件到指定目录
           ossutil cp oss://kuavo-data-challenge-simdata/<file-path>/<file-name> <local-path>

      - Downloading a batch of files

        .. code-block:: bash

           # 下载整个目录 -r
           ossutil cp -r oss://kuavo-data-challenge-simdata/<file-path>/ <local-path>

      - Enabling auto-resume after interruption

        .. code-block:: bash

           # 启用断点续传（大文件自动启用） -u
           ossutil cp -u oss://kuavo-data-challenge-simdata/large-file.zip ./local-folder/
           ossutil cp -u -r oss://kuavo-data-challenge-simdata/remote-folder/ ./local-folder/
           # 设置分块个数 -j
           ossutil cp oss://kuavo-data-challenge-simdata/large-file.zip ./local-folder/ -j 5

   f. Tips

      - Use the ``-j 10`` option to increase # of parallel tasks to increase the downloading speed
      - Use the ``-u`` option to enable auto-resume when the download is interrupted.

   g. Video Tutorial

      .. video:: ../_static/videos/instruction.mp4
         :width: 100%


Rosbag Data
==================

Inspired from the open-sourced `lerobot <https://github.com/huggingface/lerobot>`_ project by HuggingFace, the host has also prepared an easy-to-use tool that systematically converts the rosbag datasets from our Kuavo robots into Lerobot dataset formats, including *depth sensor* and other multimodal data. For more details, you may refer to the data conversion scripts from our `kuavo_data_challenge <https://github.com/LejuRobotics/kuavo_data_challenge>`_ repository. The exact dataset formats are as follows:

rosbag Topics
---------------

/cam_x/color/image_raw/compressed Camera RGB Image Data
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    1. Description
        This ROS topic is used to provide the post-compression original RGB imaging data from the camera sensors. x here being h, l or r, denoting head, left and right wrist cameras
    2. Message type
        Type: sensor_msgs/CompressedImage
    3. 消息字段
        - header (std_msgs/Header): Message head; includes timestamp, serial number, coordinate system identification, etc.
        - format (string): Image encoding format
        - data (uint8[]): Image data

/cam_h/depth/image_raw/compressed Head camera depth sensor information
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    1. Description
        /cam_h/depth/image_raw/compressed is used to provide the post-compression original depth imaging data from the head camera
    2. Message type
        Type: sensor_msgs/CompressedImage
    3. 消息字段
        - header (std_msgs/Header): Message head; includes timestamp, serial number, coordinate system identification, etc.
        - format (string): Image encoding format
        - data (uint8[]): Image data

/cam_x/depth/image_rect_raw/compressed Left, right wrist camera depth sensor information
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    1. Description
        /cam_x/depth/image_rect_raw is used to provide the post-compression original depth imaging data from camera x, where x is either l (left) or r (right).
    2. Message type
        Type: sensor_msgs/CompressedImage
    3. 消息字段
        - header (std_msgs/Header): Message head; includes timestamp, serial number, coordinate system identification, etc.
        - format (string): Image encoding format
        - data (uint8[]): Image data

/kuavo_arm_traj Arm trajectory control
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    1. Description
        /kuavo_arm_traj is used to control the arm trajectories of the robot. It publishes arm target joint positions to control the arms with high precision.
    2. Message type
        Type: sensor_msgs/JointState
    3. 消息字段
        - header (std_msgs/Header): Message head; includes timestamp, serial number, coordinate system identification, etc.
        - name (list of string): List of the arm joints. When there are 14 joints in total, the names will be from "arm_joint_1" to "arm_joint_14".
        - position (list of float): A list of current arm joint positions. The data structure is similar to items 12-25 of sensor_data_raw below.

/gripper/command Gripper control (Simulator dataset only)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    1. Description
        /gripper/command is used to control the grippers (fingers)' movement in the simulator.
    2. Message type
        Type: sensor_msgs/JointState
    3. 消息字段
        - header (std_msgs/Header): Message head; includes timestamp, serial number, coordinate system identification, etc.
        - position (list of float): Size 2 array, data being the target positions of the left and right grippers, each element is between [0, 255], where 0 is fully open and 255 is fully shut.

/gripper/state Gripper state (Simulator dataset only)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    1. Description
        /gripper/state is used to capture the current movement of the grippers (fingers) in the simulator.
    2. Message type
        Type: sensor_msgs/JointState
    3. 消息字段
        - header (std_msgs/Header): Message head; includes timestamp, serial number, coordinate system identification, etc.
        - position (list of float): Size 2 array, data being the current positions of the left and right grippers, each element is between [0, 0.8], where 0 is fully open and 0.8 is fully shut

/control_robot_hand_position Dexterous hand position (Real-machine dataset only)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    1. Description
        /control_robot_hand_position is used to control the movement of both hands. It publishes target joint positions to control the hands with high precision.
    2. Message type
        Type: kuavo_msgs/robotHandPosition
    3. 消息字段
        - left_hand_position (list of float): Left hand position in a size 6 array, each element is between [0, 100], where 0 is fully open, 100 is fully closed
        - right_hand_position (list of float): Right hand position in a size 6 array, each element is between [0, 100], where 0 is fully open, 100 is fully closed

/dexhand/state Dexterous hand state (Real-machine dataset only)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    1. Description
        Publishes dexterous hands' status
    2. Message type
        Type: sensor_msgs/JointState
    3. 消息字段
        - name (list of string): list of joint names, 12 joints in total:
        - position (list of float): List of joint positions, 12 in total, first 6 being left joint positions, later 6 being right joint positions
        - velocity (list of float): List of joint velocities, 12 in total, first 6 being left joint velocities, later 6 being right joint velocities
        - effort (list of float): List of joint (electrical) current, 12 in total, first 6 being left joint current data, later 6 being right joint current data

/control_robot_leju_claw Claw control data (Real-machine dataset only)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    1. Description
        /control_robot_leju_claw Topic used to control the robot hands (i.e. two-finger claws)
    2. Message type
        Type: kuavo_msgs/controlLejuClaw
    3. 消息字段
        - name (list of string): Length 2 list, consisting of "left_claw", "right_claw"
        - position (list of float): Length 2 list, consisting of left and right claw target positions, each element is between [0, 100], where 0 denotes fully open, 100 denotes fully closed
        - velocity (list of float): Length 2 list, target velocities for the claws, again between [0, 100]. Defaults to 50.
        - effort (list of float): Length 2 list, target current for claws, in Amps. Defaults to 1 Amp

/leju_claw_state Claw states (Real-machine dataset only)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    1. Description
        /leju_claw_state topic is used to publish the state, position, velocity and efforts of each of the claws.
    2. Type
        kuavo_msgs/lejuClawState
    3. 消息字段
        - state: Data type int8[]; Length 2 list denoting Claw states. First element denotes left claw, the other being right claw.
        - data: Data type kuavo_msgs/endEffectorData; Claw position, velocity and effort
        - state values' meanings:

            - -1: Error, indicating execution error
            - 0: Unknown, default status upon initialisation
            - 1: Moving, indicating movement of the claws in progress
            - 2: Reached, indicating the target positions have been successfully reached
            - 3: Grabbed, indicating successful grasp of an item

        Please refer to the descriptions in /control_robot_leju_claw for all the kuavo_msgs/endEffectorData messages inside data.

/sensors_data_raw Raw sensor data
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    1. Description
        Topic used to publish all real-robot or simulator raw sensor data, from joint data to IMU data to end effector data
    2. Message type
        Type: kuavo_msgs/sensorsData
    3. 消息字段
        - sensor_time (time): Timestamp
        - joint_data (kuavo_msgs/jointData): Joint data: position, velocity, acceleration, current
        - imu_data (kuavo_msgs/imuData): Includes gyroscope, accelerometer, free angular velocity, quarternion
        - end_effector_data (kuavo_msgs/endEffectorData): End effector data, not currently used.
    4. 关节数据说明
        - Order of data

            - First 12 elements are lower body motor data:

                - 0~5 are left limb data (l_leg_roll, l_leg_yaw, l_leg_pitch, l_knee, l_foot_pitch, l_foot_roll)
                - 6~11 are right limb data (r_leg_roll, r_leg_yaw, r_leg_pitch, r_knee, r_foot_pitch, r_foot_roll)

            - The subsequent 14 elements are arm motor data:

                - 12~18 are left arm motor data ("l_arm_pitch", "l_arm_roll", "l_arm_yaw", "l_forearm_pitch", "l_hand_yaw", "l_hand_pitch", "l_hand_roll")
                - 19~25 are right arm motor data ("r_arm_pitch", "r_arm_roll", "r_arm_yaw", "r_forearm_pitch", "r_hand_yaw", "r_hand_pitch", "r_hand_roll")

            - The last 2 elements are head motor data: head_yaw and head_pitch

        - Units:

            - Positions: radians
            - Speed: radians per second (radian/s)
            - Acceleration: radians per square second (radian/s²)
            - Current: Amperes (A)

    5. IMU Data Description
        - gyro: Gyroscope angular velocities, in rad/s
        - acc: Accelerometer acceleration, in m/s²
        - quat" IMU orientation


/joint_cmd All joint control commands
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    1. Description
        Topic used to publish every joint commands throughout the whole body
    2. Message type
        Type: kuavo_msgs/jointCmd
    3. 消息字段
        - header (std_msgs/Header): Message head; includes timestamp, serial number, coordinate system identification, etc.
        - joint_q (list of float): Joint positions, in radians
        - joint_v (list of float): Joint velocities, in radian/s
        - tau (list of float): Joint torques, in N·m
        - tau_max (list of float): Max joint torques, in N·m
        - tau_ratio (list of float): Torque ratios
        - joint_kp (list of float): kp data
        - joint_kd (list of float): kd data
        - control_modes (list of int): control mode corresponding to each joint, 0 being Torque, 1 being Velocity  and 2 being Positional control modes

/cmd_pose_world Robot positional commands (Task 4 only)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    1. Description
        Topic used to publish robot position commands
    2. Message type
        Type: geometry_msgs/Twist
    3. 消息字段
        - linear.x (float): x-directional data in world coordinates, in metres
        - linear.y (float): y-directional data in world coordinates, in metres
        - linear.z (float): z-directional data in world coordinates, in metres
        - angular.x (float): x-directional rotation angle in world coordinates, in radians
        - angular.y (float): y-directional rotation angle in world coordinates, in radians
        - angular.z (float): z-directional rotation angle in world coordinates, in radians

Lerobot Dataset
==================

Rosbag to Lerobot Conversion
------------------------------

Please complete the installation guide first, then refer to the tutorial from the `kuavo_data_challenge <https://github.com/LejuRobotics/kuavo_data_challenge>`_ repository to convert Kuavo-native rosbags into Lerobot parquet format:

.. code-block:: bash
    
    python kuavo_data/CvtRosbag2Lerobot.py \
        --config-path=../configs/data/ \
        --config-name=KuavoRosbag2Lerobot.yaml \
        rosbag.rosbag_dir=/path/to/rosbag \
        rosbag.lerobot_dir=/path/to/lerobot_data

Description:

    - rosbag.rosbag_dir: Original rosbag data path
    - rosbag.lerobot_dir：Target lerobot-parquet path after conversion, usually a new folder named lerobot will be created under this directory
    - configs/data/KuavoRosbag2Lerobot.yaml: Please review this configuration file and choose which camera(s) to enable and whether to use depth data, based on your needs


Lerobot directory structure
------------------------------

After executing the script, a standard Lerobot formatted dataset will be generated. The directory structure is as follows:

.. code-block::

    output_dir/
        ├── data/
        │   └── chunk-000/
        │       ├── episode_000000.parquet  # 转换后的数据，包含所有指定转换的数据特征
        │       ├── episode_000001.parquet
        │       └── ...
        ├── meta/
        │   ├── episodes.jsonl  # 每个 episode 的时长
        │   ├── info.json       # data/ 下各 parquet 的特征信息
        │   └── tasks.jsonl     # 当前任务名称
        └── images/
            ├── observation.images.color.head_cam_h/
            │   ├── episode_000000/
            │   │   ├── frame_000000.png
            │   │   └── frame_000001.png
            │   └── ...
            ├── observation.images.color.wrist_cam_l/
            └── observation.images.color.wrist_cam_r/

info.json records all available data entries, as follows:

.. code-block::

    {
        "features": {
            "observation.state": { # 机器人状态，包括14个手臂关节状态和2个末端执行器状态，顺序如 names 中所示
                "dtype": "float32",
                "shape": [
                    16
                ],
                "names": {
                    "motors": [
                        "zarm_l1_link",
                        "zarm_l2_link",
                        "zarm_l3_link",
                        "zarm_l4_link",
                        "zarm_l5_link",
                        "zarm_l6_link",
                        "zarm_l7_link",
                        "left_claw",
                        "zarm_r1_link",
                        "zarm_r2_link",
                        "zarm_r3_link",
                        "zarm_r4_link",
                        "zarm_r5_link",
                        "zarm_r6_link",
                        "zarm_r7_link",
                        "right_claw"
                    ]
                }
            },
            "action": { # 动作数据，包含14个手臂关节动作和2个末端执行器动作，顺序如 names 中所示
                "dtype": "float32",
                "shape": [
                    16
                ],
                "names": {
                    "motors": [
                        "zarm_l1_link",
                        "zarm_l2_link",
                        "zarm_l3_link",
                        "zarm_l4_link",
                        "zarm_l5_link",
                        "zarm_l6_link",
                        "zarm_l7_link",
                        "left_claw",
                        "zarm_r1_link",
                        "zarm_r2_link",
                        "zarm_r3_link",
                        "zarm_r4_link",
                        "zarm_r5_link",
                        "zarm_r6_link",
                        "zarm_r7_link",
                        "right_claw"
                    ]
                }
            },
            "observation.images.head_cam_h": { # 头部相机RGB图像数据
                "dtype": "image",
                "shape": [
                    3,
                    480,
                    640
                ],
                "names": [
                    "channels",
                    "height",
                    "width"
                ]
            },
            "observation.depth_h": { # 头部相机深度图像数据
                "dtype": "uint16",
                "shape": [
                    1,
                    480,
                    640
                ],
                "names": [
                    "channels",
                    "height",
                    "width"
                ]
            },
            "observation.images.wrist_cam_l": { # 左腕相机RGB图像数据
                "dtype": "image",
                "shape": [
                    3,
                    480,
                    640
                ],
                "names": [
                    "channels",
                    "height",
                    "width"
                ]
            },
            "observation.depth_l": { # 左腕相机深度图像数据
                "dtype": "uint16",
                "shape": [
                    1,
                    480,
                    640
                ],
                "names": [
                    "channels",
                    "height",
                    "width"
                ]
            },
            "observation.images.wrist_cam_r": { # 右腕相机RGB图像数据
                "dtype": "image",
                "shape": [
                    3,
                    480,
                    640
                ],
                "names": [
                    "channels",
                    "height",
                    "width"
                ]
            }
            "observation.depth_r": { # 右腕相机深度图像数据
                "dtype": "uint16",
                "shape": [
                    1,
                    480,
                    640
                ],
                "names": [
                    "channels",
                    "height",
                    "width"
                ]
            }
        }
    }