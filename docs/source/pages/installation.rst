.. _installation:

************
赛事资源使用指南
************

为确保比赛过程顺利，我们提供了数据下载、基准代码、模拟器环境等相关资源，供参赛者使用。以下是步骤说明及相关链接：

1. 数据集下载
=========================================
   数据集下载需要使用阿里云对象存储 OSS，说明如下。

   a. ossutil 下载与安装

      - Linux/macOS 一键安装（推荐）

        .. code-block:: bash

           sudo -v ; curl https://gosspublic.alicdn.com/ossutil/install.sh | sudo bash

        .. note::

           安装过程中需要解压工具（unzip 或 7z），请提前安装。安装完成后，``ossutil`` 将安装到 ``/usr/bin/`` 目录下。

      - 下载地址

         .. list-table::
            :header-rows: 1
            :widths: 18 82

            * - 平台
              - 地址
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


      - 手动安装方法

        .. code-block:: bash

           # 1. 下载压缩包（以 Linux x64 为例）
           wget https://gosspublic.alicdn.com/ossutil/1.7.19/ossutil-v1.7.19-linux-amd64.zip
           # 2. 解压
           unzip ossutil-v1.7.19-linux-amd64.zip
           # 3. 添加执行权限
           chmod +x ossutil
           # 4. 移动到系统 PATH 目录（可选）
           sudo mv ossutil /usr/local/bin/

   b. 验证安装

      .. code-block:: bash

         ossutil

      如果显示使用选项，则安装成功。若需更新版本，可执行：

      .. code-block:: bash

         ossutil update

   c. ossutil 配置

      交互式配置（推荐）：

      .. code-block:: bash

         ossutil config

      按提示输入：

      - 配置文件路径：默认为 ``~/.ossutilconfig`` ，直接回车使用默认路径
      - 语言设置：输入 ``CH``（中文）或 ``EN``（英文）
      - Endpoint：``https://oss-cn-hangzhou.aliyuncs.com``
      - AccessKey ID：``LTAI5tJCN2XX2sYt6wWhdvqk``
      - AccessKey Secret：``xbROt0HCaQexY2JrLl2UDScvS3qHpj``

      遇到 ``systoken`` 直接回车即可，提示出现的先后顺序可能不同。

   d. 验证配置与使用

      - 验证配置

        .. code-block:: bash

           # 输出指定桶名下的文件夹（不包含子文件）
           ossutil ls oss://kuavo-data-challenge-simdata/ -d

        若能正常显示存储空间列表，说明配置成功。

      - 浏览存储空间内容

        .. code-block:: bash

           # 列出指定存储空间的对象（不包括子目录）
           ossutil ls oss://kuavo-data-challenge-simdata/ -d
           # 递归列出所有对象（包括子目录）
           ossutil ls oss://kuavo-data-challenge-simdata/
           # 递归列出指定前缀的对象（包括子目录）
           ossutil ls oss://kuavo-data-challenge-simdata/folder-name/

      - 查看对象信息

        .. code-block:: bash

           # 查看单个对象的详细信息
           ossutil stat oss://kuavo-data-challenge-simdata/file-name
           # 查看特定路径对象个数与空间占用
           ossutil du oss://kuavo-data-challenge-simdata/file-name

      - 搜索文件

        .. code-block:: bash

           # 按文件名模式搜索 --include
           ossutil ls oss://kuavo-data-challenge-simdata/ --include "*.jpg"
           # 排除特定文件 --exclude
           ossutil ls oss://kuavo-data-challenge-simdata/ --exclude "*.tmp"
           # 组合使用包含与排除
           ossutil ls oss://kuavo-data-challenge-simdata/ --include "*.log" --exclude "*debug*"

   e. 下载说明

      - 下载单个文件

        .. code-block:: bash

           # 下载文件到当前目录
           ossutil cp oss://kuavo-data-challenge-simdata/<file-path>/<file-name> ./

           # 下载文件并重命名
           ossutil cp oss://kuavo-data-challenge-simdata/<file-path>/<file-name> <local-path>/<local-name>

           # 下载文件到指定目录
           ossutil cp oss://kuavo-data-challenge-simdata/<file-path>/<file-name> <local-path>

      - 批量下载文件

        .. code-block:: bash

           # 下载整个目录 -r
           ossutil cp -r oss://kuavo-data-challenge-simdata/<file-path>/ <local-path>

      - 断点续传下载

        .. code-block:: bash

           # 启用断点续传（大文件自动启用） -u
           ossutil cp -u oss://kuavo-data-challenge-simdata/large-file.zip ./local-folder/
           ossutil cp -u -r oss://kuavo-data-challenge-simdata/remote-folder/ ./local-folder/
           # 设置分块个数 -j
           ossutil cp oss://kuavo-data-challenge-simdata/large-file.zip ./local-folder/ -j 5

   f. 常见问题

      - 使用 ``-j 10`` 增加并行任务数以提高下载速度
      - 使用 ``-u`` 参数启用断点续传

   g. 视频教程

      .. video:: ../_static/videos/instruction.mp4
         :width: 100%

2. 安装 `kuavo_data_challenge <https://github.com/LejuRobotics/kuavo_data_challenge>`_ 仓库
===================================================================================================
此仓库用于数据转换、模型训练、模型部署），使用 git 获取最新的代码仓库（main 分支：  

   .. code-block:: bash
      
      git clone --depth=1 https://github.com/LejuRobotics/kuavo_data_challenge.git  

   .. note::
      详细步骤请参阅其在 GitHub 上的对应 `README <https://github.com/LejuRobotics/kuavo_data_challenge/blob/main/README.md>`_ 文档。

3. 安装 `kuavo-ros-opensource <https://github.com/LejuRobotics/kuavo-ros-opensource>`_ 仓库
====================================================================================================
此仓库用于运行仿真器，使用 git 获取最新的仿真器仓库（opensource/kuavo-data-challenge 分支）：

   .. code-block:: bash

      git clone -b opensource/kuavo-data-challenge --depth=1 https://github.com/LejuRobotics/kuavo-ros-opensource.git

   .. note::
      详细步骤请参阅其在 GitHub 上的对应 `README <https://github.com/LejuRobotics/kuavo-ros-opensource/blob/opensource/kuavo-data-challenge/readme.md>`_ 文档。

   