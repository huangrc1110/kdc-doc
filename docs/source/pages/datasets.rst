.. _kuavo-dataset:

**********
数据说明
**********

为最大程度保留原始数据中的信息，本次赛事统一采用 **rosbag** 包作为数据格式。参赛者可自由利用 rosbag 中提供的多源传感器数据进行模型训练。参考 HuggingFace 开源的 `lerobot <https://github.com/huggingface/lerobot>`_ 项目，赛事方同时提供了将 Kuavo 机器人 rosbag 数据转换为 Lerobot 数据集格式的工具，其中包含 *深度相机* 等多模态数据。具体实现可参阅赛事主办方发布的 `kuavo_data_challenge <https://github.com/LejuRobotics/kuavo_data_challenge>`_ 仓库中的数据转换脚本。数据格式的具体细节如下：


rosbag 数据
==================

rosbag 话题说明
---------------

/cam_x/color/image_raw/compressed 相机彩色图像数据
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    1. 功能描述
        /cam_x/color/image_raw/compressed 话题用于提供相机的原始彩色图像的压缩图像数据，其中，x 为 h、l 或 r，分别表示头部、左腕或右腕相机。
    2. 消息类型
        类型: sensor_msgs/CompressedImage
    3. 消息字段
        - header (std_msgs/Header): 消息头信息, 包含时间戳、序列号、坐标系 ID 等信息
        - format (string): 图像编码格式
        - data (uint8[]): 图像数据

/cam_h/depth/image_raw/compressed 头部相机深度图像数据
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    1. 功能描述
        /cam_h/depth/image_raw/compressed 话题用于提供头部相机的原始深度图像经过压缩后的图像数据。
    2. 消息类型
        类型: sensor_msgs/CompressedImage
    3. 消息字段
        - header (std_msgs/Header): 消息头信息, 包含时间戳、序列号、坐标系 ID 等信息
        - format (string): 图像编码格式
        - data (uint8[]): 图像数据

/cam_x/depth/image_rect_raw/compressed 左腕、右腕相机深度图像数据
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    1. 功能描述
        /cam_x/depth/image_rect_raw 话题用于提供左腕或右腕相机的原始深度图像经过校正、压缩后的图像数据，其中，x 为 l 或 r，分别表示左腕或右腕相机。
    2. 消息类型
        类型: sensor_msgs/CompressedImage
    3. 消息字段
        - header (std_msgs/Header): 消息头信息, 包含时间戳、序列号、坐标系 ID 等信息
        - format (string): 图像编码格式
        - data (uint8[]): 图像数据

/kuavo_arm_traj 手臂运动控制
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    1. 功能描述
        /kuavo_arm_traj 话题用于控制机器人手臂运动，通过发布手臂目标关节位置来实现手臂的精确控制
    2. 消息类型
        类型: sensor_msgs/JointState
    3. 消息字段
        - header (std_msgs/Header): 消息头信息, 包含时间戳、序列号、坐标系 ID 等信息
        - name (list of string): 关节名称列表，假设有 14 个关节，名称为 "arm_joint_1" 到 "arm_joint_14"。
        - position (list of float): 当前关节位置列表。数据结构跟下面 sensors_data_raw 12-25条相同

/gripper/command 夹抓控制（仅限仿真数据）
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    1. 功能描述
        /gripper/command 话题用于控制仿真中机器人双手(手指)的运动。
    2. 话题类型
        类型: sensor_msgs/JointState
    3. 消息字段
        - header (std_msgs/Header): 消息头信息, 包含时间戳、序列号、坐标系 ID 等信息
        - position (list of float): 数组长度为2, 数据为左夹爪和右夹爪的目标位置, 每个元素的取值范围为[0, 255], 0 为张开，255 为闭合。

/gripper/state 夹抓状态（仅限仿真数据）
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    1. 功能描述
        /gripper/state 话题用于获取仿真中机器人双手(手指)的运动状态。
    2. 话题类型
        类型: sensor_msgs/JointState
    3. 消息字段
        - header (std_msgs/Header): 消息头信息, 包含时间戳、序列号、坐标系 ID 等信息
        - position (list of float): 数组长度为2, 数据为左夹爪和右夹爪的位置, 每个元素的取值范围为[0, 0.8], 0 为张开，0.8 为闭合。

/control_robot_hand_position 灵巧手控制（仅限真机数据）
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    1. 功能描述
        /control_robot_hand_position 话题用于控制机器人双手(手指)的运动，通过发布手指目标关节位置来实现手部的精确控制。
    2. 话题类型
        类型: kuavo_msgs/robotHandPosition
    3. 消息字段
        - left_hand_position (list of float): 左手位置，包含6个元素，每个元素的取值范围为[0, 100], 0 为张开，100 为闭合。
        - right_hand_position (list of float): 右手位置，包含6个元素，每个元素的取值范围为[0, 100], 0 为张开，100 为闭合。

/dexhand/state 灵巧手的状态（仅限真机数据）
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    1. 话题描述
        发布灵巧手的状态数据.
    2. 消息类型
        类型: sensor_msgs/JointState
    3. 消息字段
        - name (list of string): 关节名称数组, 包含12个关节名称:
        - position (list of float): 关节位置数组, 长度为12, 前6个为左手关节位置, 后6个为右手关节位置
        - velocity (list of float): 关节速度数组, 长度为12, 前6个为左手关节速度, 后6个为右手关节速度
        - effort (list of float): 关节电流数组, 长度为12, 前6个为左手关节电流, 后6个为右手关节电流

/control_robot_leju_claw 夹抓控制（仅限真机数据）
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    1. 功能描述
        /control_robot_leju_claw 话题用于机器人夹爪（二指爪）的控制。
    2. 话题类型
        类型: kuavo_msgs/controlLejuClaw
    3. 消息字段
        - name (list of string): 数组长度为2, 数据为"left_claw", "right_claw"
        - position (list of float): 数组长度为2, 数据为左夹爪和右夹爪的目标位置, 每个元素的取值范围为[0, 100], 0 为张开，100 为闭合。
        - velocity (list of float): 数组长度为2, 夹爪目标速度值, 0 ~ 100, 不填写时默认为50
        - effort (list of float): 数组长度为2, 夹爪目标电流, 单位 A, 不填写时默认为 1.0A

/leju_claw_state 获取机器人夹爪（二指爪）状态（仅限真机数据）
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    1. 服务描述
        /leju_claw_state话题用于发布机器人夹爪（二指爪）的状态，位置，速度，力矩等信息。
    2. 服务消息类型
        kuavo_msgs/lejuClawState
    3. 消息字段
        - state： 数据类型 int8[]；二指夹爪的状态, 数组长度为2, 第一个为左夹爪, 第二个为右夹爪
        - data： 数据类型 kuavo_msgs/endEffectorData；二指夹爪的位置, 速度, 力距等信息
        - state 状态值含义:

            - -1 : Error, 表示有执行时有错误
            - 0 : Unknown, 初始化时默认的状态
            - 1 : Moving, 表示夹爪正在执行, 移动中
            - 2 : Reached, 表示夹爪已经执行到达期望的位置
            - 3 : Grabbed, 表示夹爪抓取到物品

        关于 data 字段中 kuavo_msgs/endEffectorData的消息在/control_robot_leju_claw部分有介绍。

/sensors_data_raw 传感器数据
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    1. 话题描述
        话题用于发布实物机器人或仿真器的传感器原始数据，包括关节数据、IMU数据和末端执行器数据。
    2. 消息类型
        类型: kuavo_msgs/sensorsData
    3. 消息字段
        - sensor_time (time): 时间戳
        - joint_data (kuavo_msgs/jointData): 关节数据: 位置、速度、加速度、电流
        - imu_data (kuavo_msgs/imuData): 包含陀螺仪、加速度计、自由加速度、四元数
        - end_effector_data (kuavo_msgs/endEffectorData): 末端数据，暂未使用.
    4. 关节数据说明
        - 数据顺序

            - 前 12 个数据为下肢电机数据:

                - 0~5 为左下肢数据 (l_leg_roll, l_leg_yaw, l_leg_pitch, l_knee, l_foot_pitch, l_foot_roll)
                - 6~11 为右下肢数据 (r_leg_roll, r_leg_yaw, r_leg_pitch, r_knee, r_foot_pitch, r_foot_roll)

            - 接着 14 个数据为手臂电机数据:

                - 12~18 左臂电机数据 ("l_arm_pitch", "l_arm_roll", "l_arm_yaw", "l_forearm_pitch", "l_hand_yaw", "l_hand_pitch", "l_hand_roll")
                - 19~25 为右臂电机数据 ("r_arm_pitch", "r_arm_roll", "r_arm_yaw", "r_forearm_pitch", "r_hand_yaw", "r_hand_pitch", "r_hand_roll")

            - 最后 2 个为头部电机数据: head_yaw 和 head_pitch

        - 单位:

            - 位置: 弧度 (radian)
            - 速度: 弧度每秒 (radian/s)
            - 加速度: 弧度每平方秒 (radian/s²)
            - 电流: 安培 (A)

    5. IMU 数据说明
        - gyro: 陀螺仪的角速度，单位弧度每秒（rad/s）
        - acc: 加速度计的加速度，单位米每平方秒（m/s²）
        - quat: IMU的姿态（orientation）


/joint_cmd 所有关节的控制指令
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    1. 话题描述
        话题用于发布全身所有关节的控制指令
    2. 消息类型
        类型: kuavo_msgs/jointCmd
    3. 消息字段
        - header (std_msgs/Header): 消息头信息, 包含时间戳、序列号、坐标系 ID 等信息
        - joint_q (list of float): 关节位置, 单位(radian)
        - joint_v (list of float): 关节速度, 单位(radian/s)
        - tau (list of float): 关节扭矩, 单位(N·m)
        - tau_max (list of float): 最大关节扭矩, 单位(N·m)
        - tau_ratio (list of float): 扭矩系数
        - joint_kp (list of float): kp 参数
        - joint_kd (list of float): kd 参数
        - control_modes (list of int): 关节对应的控制模式，0为Torque 控制模式, 1为Velocity 控制模式, 2为Position 控制模式

/cmd_pose_world 机器人位置指令（仅限任务4）
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    1. 话题描述
        话题用于发布机器人位置指令
    2. 消息类型
        类型: geometry_msgs/Twist
    3. 消息字段
        - linear.x (float): 基于世界坐标系的 x 方向值，单位为米 (m)。
        - linear.y (float): 基于世界坐标系的 y 方向值，单位为米 (m)。
        - linear.z (float): 基于世界坐标系的 z 方向值，单位为米 (m)。
        - angular.x (float): 基于世界坐标系的 x 方向旋转角度，单位为弧度 (radian)。
        - angular.y (float): 基于世界坐标系的 y 方向旋转角度，单位为弧度 (radian)。
        - angular.z (float): 基于世界坐标系的 z 方向旋转角度，单位为弧度 (radian)。

lerobot 数据
==================

rosbag 转 Lerobot 格式
------------------------------

参考 `kuavo_data_challenge <https://github.com/LejuRobotics/kuavo_data_challenge>`_ 仓库的教程将 Kuavo 原生 rosbag 数据转换为 Lerobot 框架可用的 parquet 格式：

.. code-block:: bash
    
    python kuavo_data/CvtRosbag2Lerobot.py \
        --config-path=../configs/data/ \
        --config-name=KuavoRosbag2Lerobot.yaml \
        rosbag.rosbag_dir=/path/to/rosbag \
        rosbag.lerobot_dir=/path/to/lerobot_data

说明：

    - rosbag.rosbag_dir：原始 rosbag 数据路径
    - rosbag.lerobot_dir：转换后的lerobot-parquet 数据保存路径，通常会在此目录下创建一个名为lerobot的子文件夹
    - configs/data/KuavoRosbag2Lerobot.yaml：请查看并根据需要选择启用的相机及是否使用深度图像等


lerobot数据目录结构说明
------------------------------

执行脚本后，会生成标准lerobot格式数据集。目录结构如下：

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

info.json 文件中记录了当前所有可用的数据特征的格式。主要可用特征如下：

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