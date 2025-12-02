.. _installation:

************************************
Installation & Training
************************************

To ensure a seamless development workflow, we have provided datasets, baseline codes and simulators for all competitors. Here is how to get started:

1. Installing the `kuavo_data_challenge <https://github.com/LejuRobotics/kuavo_data_challenge>`_ (Baseline code) Repository
======================================================================================================================================================
This repository is used for data conversion, model training and model deployment. Use git operation to fetch the latest codebase (master branch):  

   .. code-block:: bash
      
      git clone -b dev --depth=1 https://github.com/LejuRobotics/kuavo_data_challenge.git  

   .. note::
      For more details regarding to its installation and usage, please refer to this `documentation <http://huangrc1110.github.io/kdc-web>`_.

2. Installing the `kuavo-ros-opensource <https://github.com/LejuRobotics/kuavo-ros-opensource>`_ (Simulator) Repository
=======================================================================================================================================================
This repository contains the simulator. Use git operation to fetch the latest codebase (opensource/kuavo-data-challenge branch):

   .. code-block:: bash

      git clone -b opensource/kuavo-data-challenge --depth=1 https://github.com/LejuRobotics/kuavo-ros-opensource.git

   .. note::
      For more details regarding to its installation and usage, please refer to its corresponding `README <https://github.com/LejuRobotics/kuavo-ros-opensource/blob/opensource/kuavo-data-challenge/readme.md>`_  documentation found on its GitHub page

.. 3. Video Tutorial
.. ====================================================================================================
..    .. video:: ../_static/videos/demo.mp4
..       :width: 100%


.. 4. Local Model Deployment and Testing
.. ================================================
.. Please refer to this `documentation <http://huangrc1110.github.io/kdc-web>`_ for help on local deployment.