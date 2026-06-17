.. _faq:

****************
常见问题&回答
****************

赛事流程
=================================

Q：我想报名参赛，该如何报名呢？有报名费吗？
    A：报名不需要报名费。进入 阿里云天池-天池大赛-工程开发赛-乐聚机器人第一届具身智能操作任务挑战赛&创业启航营，点击报名参赛，填写个人信息即可报名参赛（Note：若个人参赛，学校/公司可填写无， 报名信息里的团队并不计入统计，创建/加入团队请在报名后操作）

Q：如何创建/加入队伍呢？
    A：完成报名后，在比赛页面左侧点击我的团队选项，可以创建队伍/加入队伍，每个队推荐1-4人。

Q：真机赛如何参与呢？一定需要去现场调试真机吗？
    A：顺利通过初赛（模拟器赛）的筛选的选手和队伍可以进入真机赛，若无法到场调试，我们会安排技术人员在现场调试。

Q：如何申请GPU算力
	A：相关算力还在申请和协调，一旦有新的算力会给大家同步，建议大家先自己匹配算力

Q：数据集现在有哪些格式的？
	A：目前上传的数据集全部是原生rosbag文件，选手可以自行使用 ``python kuavo_data/CvtRosbag2Lerobot.py`` 来批量全自动转换成Lerobot Parquet格式，详细请查看 ``kuavo_data_challenge`` 说明文档

Q：数据集需要提前下载好吗？
	A：最好一次只下载需要训练到的数据集，无需一次把所有的任务的数据集一起下载，下载量会十分庞大

Q：如何提交呢？提交后多久会有成绩？
	A：提交需要将模型与参数等打包成docker镜像，具体请查看“提交说明”栏目，最后提交的是zip压缩包。提交后后台即会开始评测，评测完成后，若评测成功会上传分数，若评测失败会上传失败原因，此时请检查自己本地是否可以加载镜像并正常推理，若本地一切正常，请在群里联系管理员。

Q：提交的作品为什么一直没有被评测呢？
	A：如果您的提交结果一直没有显示在评测中，说明您的作品还没有被评测人员拉取，请您耐心等待，通常1-3个工作日内会被评测，或可以联系管理员。

基准代码/环境常见问题
=========================================

Q：打开仿真器（例如 ``deploy.py`` 脚本）的时候，仿真器打开然后闪退
	A：确认 ``ROBOT_VERSION`` 是45；确认 ``echo $ROBOT_VERSION`` 是否打印45

	    - 每次重启docker镜像都需要重新 ``export ROBOT_VERSION=45`` ，或者可选加入zshrc里面

Q：同时运行 ``deploy.py`` 和 ``eval_kuavo.sh`` 正常进行仿真器测试时，仿真器正常打开，但测试环节不开始、第一次reset轮后不开始、或者开始后循环reset轮自动闪退
	A：在运行的 ``eval_kuavo.sh`` ，按照下面顺序注意以下事项：

		- 确认选的是选项8
		- 按下L键查看log，检查log里面有没有崩溃、缺Python包这种错误（常见为 ``apriltag_ros`` 包缺失），按照提示自行弥补
		- 确认训练好的权重文件路径是否正确，是否有权限访问
		- 推荐改要用到的文件夹访问权限，而不是在 ``eval_kuavo.sh`` 前面加 ``sudo`` （容易出问题）
		- 重新配置 ``eval_kuavo.sh`` 运行的Python环境
		- 在某些慢一些的系统上面，可能需要改等待仿真起来那个位置（~348行）的 ``time.sleep`` ，可能需要调长一些

Q：仿真器 ``catkin build`` 的时候找不到模块报错，如找不到 ``humanoid_interface`` 
	A：检查以下事项：

        - 请确认运行 ``catkin build`` 之前先 ``source installed/setup.zsh`` 
        - 请勿使用 ``catkin clean`` ，会丢失关键包裹，用了请麻烦重新pull整个库
        - 重新pull整个库

Q：仿真器 ``catkin build`` 的时候报错 ``failed to make symbolic link .../../*.so``
	A：使用Windows来 ``git clone`` 这个库会导致symbolic link丢失

        - 使用Ubuntu环境来执行 ``git clone/pull`` 

Q：仿真器很卡
	A：检查以下事项：
    
        - 确认使用了 ``run_with_gpu.sh`` 正确使用CUDA加速
        - 确认docker是否正确使用了CUDA
        - 推荐不要使用WSL（Windows Subsystem for Linux），CUDA加速有问题，要是使用这个请在QQ群里面看看能不能找到解决方案

Q：仿真器运行 ``deploy.py`` 完全没有仿真页面
	A：确认没有残骸没完全杀死的ROS进程，可重启电脑试试

真机部署常见问题
=========================================

**Q：为什么镜像在真机部署时 SDK 或接口报错？**
    A：常见原因是使用了仿真赛阶段的旧版 KDC 代码，或没有基于真机赛官网提供的最新代码构建镜像。请使用 `真机赛文档 <https://kdc-doc.netlify.app/tianchi/cn/pages/real>`_ 中的最新仓库和部署说明重新构建，并确认镜像内 ``kuavo-humanoid-sdk`` 版本符合要求。

**Q：为什么容器里运行模型时提示缺少 Python 包？**
    A：通常是本地环境额外安装了依赖，但打包 Docker 镜像时没有带进去。建议先打包自己的 conda 环境，再按官网 Dockerfile 构建镜像：

    .. code-block:: bash

       conda install -c conda-forge conda-pack
       conda activate kdc
       conda pack -n kdc -o myenv.tar.gz

    构建镜像前，请确认推理所需依赖都已安装在该环境中。

**Q：为什么部署推理时提示缺少 ``pyaudio`` 或相关音频依赖？**
    A：KDC 在部署推理时通常需要 ``pyaudio`` 包，否则运行时容易报错。建议提前在 conda 环境中执行以下指令完成环境适配：

    .. code-block:: bash

       sudo apt update
       sudo apt install build-essential python3-dev portaudio19-dev
       pip install pyaudio

**Q：为什么 ``run_with_gpu.sh`` 启动后无法连接 ROS？**
    A：常见原因是启动脚本没有按真机部署通知更新，尤其是 ROS 网络配置写错。请确认 ``run_with_gpu.sh`` 的 ``docker run`` 中包含：

    .. code-block:: bash

       -e ROS_MASTER_URI=http://kuavo_master:11311
       -e ROS_IP=192.168.26.10

**Q：为什么配置了模型，但部署时找不到权重？**
    A：通常是 ``configs/deploy/kuavo_env.yaml`` 中的路径信息没有填对。请检查 ``inference`` 字段是否能对应到镜像内模型路径。

    .. code-block:: yaml

       inference:
         task: "your_task"
         method: "your_method"
         timestamp: "run_xxxxxxxx_xxxxxx"
         epoch: best

    对应路径格式：

    .. code-block:: text

       /root/kuavo_data_challenge/outputs/train/<task>/<method>/<timestamp>/epoch<epoch>

    例如 ``task: "small"``、``method: "act"``、``timestamp: "run_20260429_002926"``、``epoch: best`` 对应：

    .. code-block:: text

       /root/kuavo_data_challenge/outputs/train/small/act/run_20260429_002926/epochbest

    如果使用 ``pretrained_path``，请确认该路径在容器内真实存在。

**Q：为什么末端执行器相关配置会导致部署异常？**
    A：请确认 ``obs_key_map`` 中的末端部分与当前配置的 ``eef_type`` 类型保持一致，其余末端执行器话题建议暂时注释，避免加载到错误的末端状态话题。

**Q：为什么模型首次推理时尝试联网下载文件？**
    A：有些模型会在首次运行时下载缓存文件，例如 ACT 可能需要 ResNet18 相关缓存。如果比赛现场无网络，推理会失败。请提前在镜像中准备好所有缓存文件，或在构建镜像前完成一次模型加载测试，确保缓存已写入镜像。

**Q：如何提交前快速自检？**
    A：下载自检脚本并放在镜像 ``tar`` 和 ``run_with_gpu.sh`` 同级目录下：

    .. raw:: html

       <p><a href="../_static/code/check_docker_python_deps.sh" download="check_docker_python_deps.sh">下载 check_docker_python_deps.sh</a></p>

    .. code-block:: bash

       ./check_docker_python_deps.sh your_image.tar

    脚本会检查：

    - ``run_with_gpu.sh`` 中的 ROS 配置
    - Docker 镜像内 Python 依赖版本
    - ``kuavo_env.yaml`` 是否能对应到 ``outputs/train/...`` 模型路径
