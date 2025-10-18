*************************************************
第一届具身智能操作任务挑战赛&创业启航营官方文档
*************************************************

.. raw:: html

  <style>.wy-nav-content .document h1:first-of-type{display:none;}</style>

.. .. raw:: html

..   <h1 style="text-align:center;margin:0.3em 0 0;">第一届具身智能操作任务挑战赛&创业启航营官方文档</h1>
..   <br>

.. image:: ./_static/images/heading.png

.. raw:: html

   <div align="center">

.. image:: https://img.shields.io/pypi/v/kuavo-humanoid-sdk.svg
   :target: https://pypi.org/project/kuavo-humanoid-sdk/
   :alt: Version

.. image:: https://img.shields.io/pypi/l/kuavo-humanoid-sdk.svg
   :target: #
   :alt: License

.. image:: https://img.shields.io/pypi/pyversions/kuavo-humanoid-sdk.svg
   :target: https://pypi.python.org/pypi/kuavo-humanoid-sdk
   :alt: Supported Python Versions

.. raw:: html

   </div>



.. raw:: html

  <p></p>




.. image:: https://kuavo.lejurobot.com/manual/assets/images/kuavo_4pro-cf84d43f1c370666c6e810d2807ae3e4.png


本文档为 "第一届具身智能操作任务挑战赛&创业启航营" 参赛使用说明文档，主要涵盖本次赛事的数据、基准代码、仿真模拟器等使用的相关内容。有关比赛规则、重要日期等通用信息，请参阅 `比赛官网 <https://tianchi.aliyun.com/competition/entrance/532415>`_ 。

本赛事支持代码分为基准代码（kuavo_data_challenge 仓库）、仿真器（kuavo-ros-opensource 仓库）两大部分。功能一览如下：

   - 仿真器基于MuJoCo，自带真实的机器人模型，以真实的物理学还原效果
   - 支持 rosbag 到 Lerobot 的数据转换
   - IL 模型训练框架（DP, ACT）
   - 模拟器部署接口以及自动，准确的评分系统
   - 真机认证和部署接口


快速开始
===================
.. descriptions here are active

1. :doc:`pages/signup`
      阿里云天池赛事报名信息

2. :doc:`pages/datasets`
      训练将用到的数据集详细信息

3. :doc:`pages/installation`
      赛事基准代码的安装及使用方法

4. :doc:`pages/submit`
      模型提交详细信息

.. toctree::
   :maxdepth: 1
   :hidden:
   :caption: 赛事介绍

   pages/introduction
   pages/tasks

.. toctree::
   :maxdepth: 1
   :hidden:
   :caption: 赛事流程

   pages/signup
   pages/datasets
   pages/installation
   pages/submit

.. toctree::
   :maxdepth: 1
   :hidden:
   :caption: 辅助信息

   pages/faq
   pages/forums

加入讨论群：
============
为方便大家讨论和解决问题，我们组织了技术同学建了一个 `QQ群 <./_static/images/qq_team.jpg>`_ ，请点击链接扫码入群。

此文档持续更新中...
=====================

开源协议
========
本赛事依照 `MIT 许可证 <https://opensource.org/licenses/MIT>`_ 进行开源。
