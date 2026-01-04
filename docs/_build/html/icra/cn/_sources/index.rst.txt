*************************************************
The 1st Real-world Embodied AI Learning Challenge
*************************************************

.. raw:: html

  <style>.wy-nav-content .document h1:first-of-type{display:none;}</style>

.. image:: ./_static/images/heading.png

.. .. raw:: html

..    <div class="banner-video-container" style="position: relative; width: 100%; max-width: 1200px; height: 360px; margin: 0 auto; overflow: hidden;">
..       <video autoplay loop muted playsinline class="banner-video" poster="./_static/images/banner1.png" style="position: absolute; inset: 0; width: 100%; height: 90%; object-fit: cover; z-index: 1;">
..          <source src="./_static/videos/banner1.mov" type="video/quicktime">
..          <source src="./_static/videos/banner1.mov" type="video/mp4">
..          Your browser does not support the video tag.
..       </video>
..       <img src="./_static/images/banner1.png" alt="Banner" class="banner-image" style="position: absolute; left: 50%; top: 45%; transform: translate(-50%, -50%); max-width: 70%; max-height: 45%; width: auto; height: auto; object-fit: contain; z-index: 2; pointer-events: none;" />
..    </div>
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




.. .. image:: https://kuavo.lejurobot.com/manual/assets/images/kuavo_4pro-cf84d43f1c370666c6e810d2807ae3e4.png
..    :width: 400px
.. note::
   This manual is being updated in a regular basis...

**Welcome** to the official competition manual for the 1st Real-world Embodied AI Learning Challenge! This manual covers all the details about the datasets, baseline codes as well as the simulator used in this competition. As for the official competition rules, important dates and other general info, please consult our official `competition website <https://www.kdc.icra.lejurobot.com/home>`_ .

The competition repositories consist of two parts: The baseline code (kuavo_data_challenge repository) and the simulator (kuavo-ros-opensource repository). Their features are as follows:

   - Simulator is based on MuJoCo, with built-in realistic robotic models, restoring real-physics simulation
   - Supports Rosbag to Lerobot parquet data conversion
   - Imitation Learning (IL) model training framework (DP, ACT)
   - Simulator deployment interface as well as automatic high-precision model grading system
   - Real-device verification and its deployment

Process
===================
The competition consists of the following steps:

1. Sign up for the competition through the competition website

2. Download datasets and baseline codes as well as environment setup

3. Train your models, you are free to use any learning based methods

4. Submit your models and beat other competitors in the leaderboard!

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


Open-sourcing Agreement
============================================
This competition is open sourced under the `MIT License <https://opensource.org/licenses/MIT>`_ .
