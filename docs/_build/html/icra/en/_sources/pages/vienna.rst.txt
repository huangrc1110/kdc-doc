.. _vienna::

***************************
Vienna On-Site Competition
***************************

Vienna On-Site Competition Preparation
======================================

In the Vienna on-site competition, the participant workflow remains consistent with the real-robot track:

1. Use the same project codebase and runtime logic as the real-robot competition.
2. Modify configuration files using the same principles and fields as the real-robot competition.
3. Follow the same submission packaging process for deployment and evaluation.

Vienna On-Site Dataset
======================

Vienna on-site dataset:
https://huggingface.co/datasets/LejuRobotics/kuavo_data_challenge_icra/tree/main/vienna

On-Site Task Description
========================

Task Overview
--------

Task 1
^^^^^^^^^

Metal Parts Righting
Scenario Description: Small parts are placed both face-up and face-down on a conveyor belt. The robot must grasp face-down parts with one hand, flip them, and place them face-up.

Level 1

.. video:: ../_static/videos/vienna_task1_level1.mp4
   :width: 100%
.. raw:: html

   <div style="clear: both;"></div>

Level 2

.. video:: ../_static/videos/vienna_task1_level2.mp4
   :width: 100%
.. raw:: html

   <div style="clear: both;"></div>

Task 2
^^^^^^^^^

Daily Chemical Bottle Pick & Place
Scenario Specification: Bottles of identical specifications are randomly placed on a tabletop within the right hand’s working radius. The right hand grasps each bottle and transfers it mid-air to the left hand, which then places it onto a conveyor belt. The conveyor belt work area falls within the field of view of the robot’s head-mounted camera.

Level 1

.. video:: ../_static/videos/vienna_task2_level1.mp4
   :width: 100%
.. raw:: html

   <div style="clear: both;"></div>

Level 2

.. video:: ../_static/videos/vienna_task2_level2.mp4
   :width: 100%
.. raw:: html

   <div style="clear: both;"></div>

Task 3
^^^^^^^^^

Express Package Scanning
Scenario Description: Grasp parcel from conveyor belt with one hand, place it on the label-scanning platform;,left hand adjusts the parcel label faces up, then grasps with one hand and places on conveyor belt on the other side.

Level 1

.. video:: ../_static/videos/vienna_task3_level1.mp4
   :width: 100%
.. raw:: html

   <div style="clear: both;"></div>

Level 2

.. video:: ../_static/videos/vienna_task3_level2.mp4
   :width: 100%
.. raw:: html

   <div style="clear: both;"></div>

Task Scoring
--------

General Rules
^^^^^^^^^^^^^^^^^^^^^^^^^^^^
The on-site competition features three scenarios. Each scenario has two difficulty levels with different scoring configurations.

Evaluation Limit — Each submitted model may attempt up to 3 evaluations per scenario; the average score is taken.

Data Collection — 200 data samples are collected per task: 100 for Level 1 and 100 for Level 2 scenarios.

Inference Failure — If a single scoring action fails 3 consecutive attempts, the round is deemed failed. Any collision or abnormal event also results in round failure.

Task 1: Metal Parts Righting（10 pts）
----------------------------------------------------------------

Difficulty Levels and Scoring Criteria:

Level 1 (Total Score: 6 pts)：
The conveyor belt is stationary. Within the robot's right-hand reach, there are 3 face-down metal parts,3 placed at random positions. The gripper grasps each part and completes the flip.

Time limit per evaluation: 3 minutes.

* Grasping a face-down part and completing the flip scores 1.5 pts

* Completing all parts scores 1.5 pts

Level 2 (Total Score: 4 pts)：
The conveyor belt is moving. There are 4 small parts: face-down and face-up 2 each, placed randomly within the right hand's reach. The right hand grasps face-down parts from the moving belt; face-up parts are identified but not manipulated.

Time limit: 5 minutes.

* 1 pt for grasping a face-down part and completing the flip

* 1 pt for identifying face-up and moving away. 

Task 2: Daily Chemical Bottle Pick & Place（15 pts）
----------------------------------------------------------------

Difficulty Levels and Scoring Criteria:

Level 1 (5 pts)：
The right hand grasps one bottle and performs a mid-air handoff to the left hand, which then places the bottle steadily onto the conveyor belt.

Time limit per evaluation: 3 minutes.

* 1 pt for successfully grasping the bottle without dropping

* bimanual handoff scores 2 pts

* the other hand places bottle on conveyor belt scores 2 pts

Level 2 (10 pts)：
Two bottles of identical specifications are randomly placed within the right hand’s working radius. The right hand grasps each bottle one at a time and performs a mid-air handoff to the left hand, which then places the bottles onto the conveyor belt one by one in a stable manner.

Time limit per evaluation: 6 minutes.

* 1 pt for grasping any bottle without dropping

* bimanual handoff scores 2 pts

* other hand places bottle on conveyor belt scores 2 pts. 

Task 3: Express Package Scanning（25 pts）
----------------------------------------------------------------
Difficulty Levels and Scoring Criteria:

Level 1 (10 pts)：
Two parcels placed one at a time: one label-up, one label-down; Right hand grasps nearby parcel and places on scanning platform; left hand flips label-down parcel and places it on conveyor belt.

Time limit per evaluation: 6 minutes.

* Grasping and placing parcel on scanning platform scores 1 pt
* successfully flipping label-down parcel and placing on scanning platform scores 4 pts
* placing on conveyor belt scores 2 pts. 

Level 2 (15 pts)：
Three parcels placed simultaneously within the right hand's reach,1 label-up and 2 label-down；Right hand grasps nearby parcel and places on scanning platform; left hand flips label-down parcels and places on conveyor belt.

Time limit: 10 minutes.

* 1 pt for grasping and placing on scanning platform

* 3 pts for flipping label-down parcel and placing on scanning platform

* 2 pts for placing on conveyor belt. 

Vienna On-Site Process Differences
==================================

Compared with the regular real-robot track process, the Vienna on-site process includes these differences:

1. Submission path: teams may submit via the ICRA official website, or directly deploy/download to the on-site evaluation host for evaluation.
2. On-site scoring: officials perform on-site scoring and present a live leaderboard.
3. Compute resources: to accelerate iteration, each team is provided with 4 GPU server slots. Resource allocation is expected to be announced before competition start so teams can pre-configure environments.
4. Data transfer: on-site collected data will be stored on local hard drives. Teams can upload data to training servers via on-site hard drives, or download from HuggingFace directly (on-site hard-drive quantity is limited).

Vienna On-Site Workflow Diagram
===============================

.. image:: ../_static/images/vienna_data_flow.svg
   :width: 100%
   :alt: Vienna on-site data and evaluation workflow

On-Site Schedule
================

.. raw:: html

   <iframe src="../_static/docs/REAL-I_Competition_Guide.pdf" width="100%" height="900px" style="border: 1px solid #ddd;"></iframe>