*************************************************
The 1st Real-world Embodied AI Learning Challenge
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


Welcome to the official competition manual for the 1st Real-world Embodied AI Learning Challenge! This manual covers all the details about the datasets, baseline codes as well as the simulator used in this competition. As for the official competition rules, important dates and other general info, please consult our official `competition website <https://www.kdc.icra.lejurobot.com/home>`_ .

The competition repositories consist of two parts: The baseline code (kuavo_data_challenge repository) and the simulator (kuavo-ros-opensource repository). Their features are as follows:

   - Simulator is based on MuJoCo, with built-in realistic robotic models, restoring real-physics simulation
   - Supports Rosbag to Lerobot parquet data conversion
   - Imitation Learning (IL) model training framework (DP, ACT)
   - Simulator deployment interface as well as automatic high-precision model grading system
   - Real-device verification and its deployment


Getting Started
===================
.. descriptions here are active

1. :doc:`pages/signup`
      The signup process for this competition

2. :doc:`pages/datasets`
      Detailed description of the datasets

3. :doc:`pages/installation`
      Baseline code installation and usage

4. :doc:`pages/submit`
      Details on how to submit your models

.. toctree::
   :maxdepth: 1
   :hidden:
   :caption: Introduction

   pages/introduction
   pages/tasks

.. toctree::
   :maxdepth: 1
   :hidden:
   :caption: Competition Overview

   pages/signup
   pages/datasets
   pages/installation
   pages/submit

.. toctree::
   :maxdepth: 1
   :hidden:
   :caption: Additional Resources

   pages/faq
.. pages/forums

Please consider joining our discussion group:
========================================================================
To facilitate discussion and raising/solving problems and concerns, we have organised a `Discord Server <https://discord.gg/H8RFYH4KNM>`_ just for our contestants, please consider clicking the link to accept the invitation!

This manual is being updated in a regular basis...
========================================================================

Open-sourcing Agreement
============================================
This competition is open sourced under the `MIT License <https://opensource.org/licenses/MIT>`_ .
