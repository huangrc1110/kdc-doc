.. _installation:

******************
安装训练指南
******************

为确保比赛过程顺利，我们提供了数据下载、基准代码、仿真器环境等相关资源，供参赛者使用。以下是步骤说明及相关链接：

1. 安装 `kuavo_data_challenge <https://github.com/LejuRobotics/kuavo_data_challenge>`_ （基准代码）仓库
======================================================================================================================================================
此仓库用于数据转换、模型训练、模型部署，使用 git 获取最新的代码仓库（main 分支）：  

   .. code-block:: bash
      
      git clone --depth=1 https://github.com/LejuRobotics/kuavo_data_challenge.git  

   .. note::
      详细安装及使用步骤请参阅其在 GitHub 上的对应 `README <https://github.com/LejuRobotics/kuavo_data_challenge/blob/main/README.md>`_ 文档。

2. 安装 `kuavo-ros-opensource <https://github.com/LejuRobotics/kuavo-ros-opensource>`_ （仿真器环境）仓库
=======================================================================================================================================================
此仓库用于运行仿真器，使用 git 获取最新的仿真器仓库（opensource/kuavo-data-challenge 分支）：

   .. code-block:: bash

      git clone -b opensource/kuavo-data-challenge --depth=1 https://github.com/LejuRobotics/kuavo-ros-opensource.git

   .. note::
      详细安装及使用步骤请参阅其在 GitHub 上的对应 `README <https://github.com/LejuRobotics/kuavo-ros-opensource/blob/opensource/kuavo-data-challenge/readme.md>`_ 文档。

3. 视频教程
====================================================================================================
   .. video:: ../_static/videos/demo.mp4
      :width: 100%


4. 本地模型推理测试
================================================
参考 `kuavo_data_challenge仓库 main 分支的 readme <https://github.com/LejuRobotics/kuavo_data_challenge/blob/main/README.md>`_ ，进行本地模型推理测试。