.. _installation:

************************************
Installation & Training
************************************

To ensure a seamless development workflow, we have provided datasets, baseline codes and simulators for all competitors. Here is how to get started:

1. Installing the `kuavo_data_challenge <https://github.com/LejuRobotics/kuavo_data_challenge/tree/icra>`_ (Baseline code) Repository
======================================================================================================================================================
This repository is used for data conversion, model training and model deployment. Use git operation to fetch the latest codebase (**icra** branch):  

   .. code-block:: bash
      
      git clone -b icra --depth=1 https://github.com/LejuRobotics/kuavo_data_challenge.git  


2. Installing the `kuavo-ros-opensource <https://github.com/LejuRobotics/kuavo-ros-opensource/tree/opensource/kuavo-data-challenge-icra>`_ (Simulator) Repository
=======================================================================================================================================================
This repository contains the simulator. Use git operation to fetch the latest codebase (**opensource/kuavo-data-challenge-icra** branch):

   .. code-block:: bash

      git clone -b opensource/kuavo-data-challenge-icra --depth=1 https://github.com/LejuRobotics/kuavo-ros-opensource.git


3. Video Tutorial
====================================================================================================
   .. video:: ../_static/videos/icra_instruction_installation.mp4
      :width: 100%


.. 4. Local Model Deployment and Testing
.. ================================================
.. Please refer to this `documentation <http://huangrc1110.github.io/kdc-web>`_ for help on local deployment.