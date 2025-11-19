.. _faq:

****************
FAQs
****************

Q: I would like to sign up for this competition, how would I sign up? How much does the signup cost?
    A: The signup process is free of charge. Go to Alibaba Cloud - Tianchi Competition - Engineering Development Competition - Leju Robotics REAL; Click Sign Up, fill in your personal information to sign up. (Note: For individual signups, school/company name can be left blank, Any teams in the signup information are not to be recorded as competition teams. For teaming up for the competition, please do so after everyone's signup have been completed)

Q: How do I create/join teams?
    A: After signup, click my teams found on the left pane to create/join teams. 2-4 members are allowed within every team.

Q: How do I participate in the real-machine competition? Is this an in-person only event?
    A: All participants/teams passing the first qualification round (simulator round) may participate in the real-machine competition. If for any reason one is unable to partake in-person for testing, we can arrange technical personnel live on-stage to configure for your testing

Q: How to apply for GPU compute power assistance?
	A: Relevant assistance resources are still under negotiation for now. We will provide an update as soon as any becomes available. We strongly encourage everyone to equip and utilise their own compute power for now.

Q: What data formats are provided for the datasets
	A: Everything uploaded are in native rosbag formats, but participants can freely use ``python kuavo_data/CvtRosbag2Lerobot.py`` to freely convert such datasets into Lerobot Parquet format en masse. For more details, please consult the ``kuavo_data_challenge`` readme documentation.

Q: Does the dataset needs to be downloaded all at once?
	A: We recommend you download only what you'll need during each download. There is no need for you to download everything at once, as such download size is humongous!

Q: After opening the simulator (i.e. ``deploy.py``), the simulator opens and immediately disappears.
	A: Please ensure that ``ROBOT_VERSION`` is set to 45. You can check this by ``echo $ROBOT_VERSION`` and see if 45 is correctly printed.

	    - Note that after every re-entry into the docker image, you need to rerun ``export ROBOT_VERSION=45``, or you can optionally add this line into the .zshrc file.

Q: During simutaneous execution of ``deploy.py`` and ``eval_kuavo.sh`` , the simulator opens successfully, but either the evaluation never begins, never restarts after the first reset round, and/or every round becomes a reset round in an infinite loop
	A: In the running ``eval_kuavo.sh``, check the following items in order:

		- Ensure that Option 8 was the one selected
		- Press L to check the log, ensure that there are no crash messages, potentially indicating missing Python packages (commonly ``apriltag_ros`` may be missing). Install any missing packages as prompted
		- Ensure that the pretrained weights filepath is correctly set, and that the code has sufficient permissions to access it
		- It is highly recommended that you change and grant the permissions of all folders in use with this project. It is not recommended for you to add ``sudo`` in front of ``eval_kuavo.sh`` as it may lead to unexpected errors
		- Reconfigure the Python environment containing the ``eval_kuavo.sh``
		- Under some slower systems, it may be necessary for you to wait longer for the simulator to be ready. Change the ``time.sleep`` at approx. Line 348 to a larger value.

Q: When ``catkin build`` ing the simulator, it fails to find necessary modules, such as ``humanoid_interface`` 
	A: Check the following checklist:

        - Please ensure that ``source installed/setup.zsh`` successfully executed prior to ``catkin build`` 
        - Do NOT use ``catkin clean``, as it may erase critical packages. If you accidentally used this, please re-pull the entire repository to start over.
        - re-pull the entire repository

Q: When ``catkin build`` ing the simulator, errors pop up that read ``failed to make symbolic link .../../*.so``
	A: If you used ``git clone`` inside Windows environment, where symbolic links do not work correctly under Linux, this can occur

        - Please use a Linux distro to perform ``git clone/pull`` 

Q: The simulator is very laggy
	A: Check the following checklist:
    
        - Please ensure that ``run_with_gpu.sh`` was used to create the docker container, and that it is using CUDA properly.
        - Ensure that docker is correctly using CUDA
        - It is not recommended for you to use WSL (Windows Subsystem for Linux) for this project, as it is reported that it has CUDA acceleration issues. If you are under such environment, please see the QQ group chat to see if there are any existing solutions inside the discussion group.

Q: No simulator window showing up after executing ``deploy.py`` for the simulator
	A: Please ensure that there are no running ROS processes that are not killed properly. Restart the computer and try againA: Please ensure that there are no running ROS processes that are not killed properly. Restart the computer and try again