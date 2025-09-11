.. _installation:

************
安装指南
************

为确保比赛过程顺利，参赛选手需按照要求完成以下两个仓库的安装与配置：

1. 安装 `kuavo_data_challenge <https://github.com/LejuRobotics/kuavo_data_challenge>`_ 仓库（此仓库用于数据转换、模型训练、模型部署）,切换至main分支：
   
   .. note::
      详细步骤请参阅其在 GitHub 上的对应 `README <https://github.com/LejuRobotics/kuavo_data_challenge/blob/main/README.md>`_ 文档。

   使用 git 获取最新的kuavo_data_challenge仓库（main 分支）：  

   .. code-block:: bash

      git clone --depth=1 https://github.com/LejuRobotics/kuavo_data_challenge.git

2. 安装 `kuavo-ros-opensource <https://github.com/LejuRobotics/kuavo-ros-opensource>`_ 仓库（此仓库用于运行仿真器），切换至opensource/kuavo-data-challenge分支：

   .. note::
      详细步骤请参阅其在 GitHub 上的对应 `README <https://github.com/LejuRobotics/kuavo-ros-opensource/blob/opensource/kuavo-data-challenge/readme.md>`_ 文档。

   使用 git 获取最新的仿真器仓库kuavo-ros-opensource（opensource/kuavo-data-challenge 分支）：

   .. code-block:: bash

      git clone -b opensource/kuavo-data-challenge --depth=1 https://github.com/LejuRobotics/kuavo-ros-opensource.git

