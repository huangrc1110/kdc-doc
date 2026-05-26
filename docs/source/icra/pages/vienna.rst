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

.. note::

   1. All on-site entries must be submitted through the official ICRA platform. During evaluation, models are downloaded uniformly from the platform.
   2. Both Level 1 and Level 2 datasets are open in parallel on-site. Teams may choose the evaluation group at their own discretion. 
   3. When submitting works, teams should clearly indicate the target group in the submission name, for example: ``task1_level1&2``, ``task1_level1``, ``task1_level2``.

Vienna On-Site Dataset
======================

Vienna on-site dataset:
`Vienna dataset on HuggingFace <https://huggingface.co/datasets/LejuRobotics/kuavo_data_challenge_icra/tree/main/vienna>`_

Dataset notes:

1. On-site data collection will be conducted throughout the competition. For each task, competition datasets are expected to be released one day before the match day (or earlier if available).
2. The on-site competition dataset format is consistent with the real-robot competition dataset format.
3. Both Level 1 and Level 2 competition datasets will be released on-site in sync.
4. Staff members will continuously collect data to supplement the dataset during the event, and participants may also try on-site data collection.

On-Site Task Description
========================

On-Site Competition Notes
-------------------------

The on-site competition follows the real-robot competition baseline framework with level-based adjustments only:

1. Existing scenarios are split into two stages: Level 1 and Level 2.
2. Level 1 task content remains unchanged.
3. Level 2 scenarios and operation actions are adjusted slightly.

Task Overview
-------------

Task 1
^^^^^^

Metal Parts Righting
Overall Task:
Small parts are placed both face-up and face-down on a conveyor belt. The robot must grasp face-down parts with one hand, flip them, and place them face-up.

Level 1 Scenario Video:

.. video:: ../_static/videos/vienna_task1_level1.mp4
   :width: 100%
.. raw:: html

   <div style="clear: both;"></div>

------------------------------

Level 2 Scenario Video:

.. video:: ../_static/videos/vienna_task1_level2.mp4
   :width: 100%
.. raw:: html

   <div style="clear: both;"></div>

Task 2
^^^^^^

Daily Chemical Bottle Pick & Place
Overall Task:
Bottles of identical specifications are randomly placed on a tabletop within the right hand's working radius. The right hand grasps each bottle and transfers it mid-air to the left hand, which then places it onto a conveyor belt. The conveyor belt work area falls within the field of view of the robot's head-mounted camera.

Level 1 Scenario Video:

.. video:: ../_static/videos/vienna_task2_level1.mp4
   :width: 100%
.. raw:: html

   <div style="clear: both;"></div>

------------------------------

Level 2 Scenario Video:

.. video:: ../_static/videos/vienna_task2_level2.mp4
   :width: 100%
.. raw:: html

   <div style="clear: both;"></div>

Task 3
^^^^^^

Express Package Scanning
Overall Task:
Grasp parcel from conveyor belt with one hand, place it on the label-scanning platform; left hand adjusts the parcel label face-up, then grasps with one hand and places on the conveyor belt on the other side.

Level 1 Scenario Video:

.. video:: ../_static/videos/vienna_task3_level1.mp4
   :width: 100%
.. raw:: html

   <div style="clear: both;"></div>

------------------------------

Level 2 Scenario Video:

.. video:: ../_static/videos/vienna_task3_level2.mp4
   :width: 100%
.. raw:: html

   <div style="clear: both;"></div>

Task Scoring
------------

General Rules
^^^^^^^^^^^^^

The on-site competition features three scenarios. Each scenario has two difficulty levels with different scoring configurations.

Evaluation Limit - Each submitted model may attempt up to 3 evaluations per scenario; the average score is taken.

Data Collection - 200 data samples are collected per task: 100 for Level 1 and 100 for Level 2 scenarios.

Inference Failure - If a single scoring action fails 3 consecutive attempts, the round is deemed failed. Any collision or abnormal event also results in round failure.

Task 1: Metal Parts Righting (10 pts)
--------------------------------------

Level 1 (Total Score: 6 pts):
Task actions:The conveyor belt is stationary. Within the robot's right-hand reach, there are 3 face-down metal parts,3 placed at random positions. The gripper grasps each part and completes the flip.

Scoring:

*   Grasp face-down part and complete flip: 1.5 pts (per count)

*   All parts completed: 1.5 pts (one-time)

Time limit per evaluation: 3 minutes.

------------------------------

Level 2 (Total Score: 4 pts):
Task actions:The conveyor belt is moving. There are 4 small parts: face-down and face-up 2 each, placed randomly within the right hand's reach. The right hand grasps face-down parts from the moving belt; face-up parts are identified but not manipulated.

Scoring:

*   Grasp face-down part and complete flip: 1 pt (per count)

*   Identify face-up part and move away: 1 pt (per count)

Time limit per evaluation: 5 minutes.

Task 2: Daily Chemical Bottle Pick & Place (15 pts)
------------------------------------------------------

Level 1 (Total Score: 5 pts):
Task actions:The right hand grasps one bottle and performs a mid-air handoff to the left hand, which then places the bottle steadily onto the conveyor belt.

Scoring:

*   Successfully grasp bottle: 1 pt (one-time)

*   Complete bimanual handoff: 2 pts (one-time)

*   Place bottle on conveyor belt: 2 pts (one-time)

Time limit per evaluation: 3 minutes.

------------------------------

Level 2 (Total Score: 10 pts):
Task actions:Two bottles of identical specifications are randomly placed within the right hand’s working radius. The right hand grasps each bottle one at a time and performs a mid-air handoff to the left hand, which then places the bottles onto the conveyor belt one by one in a stable manner.

Scorig:

*   Successfully grasp bottle: 1 pt (per count)

*   Complete bimanual handoff: 2 pts (per count)

*   Place bottle on conveyor belt: 2 pts (per count)

Time limit per evaluation: 6 minutes.

------------------------------

Task 3: Express Package Scanning (25 pts)
------------------------------------------

Level 1 (Total Score: 10 pts):
Task actions:Two parcels placed one at a time: one label-up, one label-down; Right hand grasps nearby parcel and places on scanning platform; left hand flips label-down parcel and places it on conveyor belt.

Scoring:

*   Grasp parcel and place: 1 pt (per count)

*   Flip label-down parcel and place: 4 pts (one-time)

*   Grasp and place on conveyor belt: 2 pts (per count)

Time limit per evaluation: 6 minutes.

------------------------------

Level 2 (Total Score: 15 pts):
Task actions:Three parcels placed simultaneously within the right hand's reach,1 label-up and 2 label-down；Right hand grasps nearby parcel and places on scanning platform; left hand flips label-down parcels and places on conveyor belt.

Scoring:

*   Grasp parcel and place: 1 pt (per count)

*   Flip label-down parcel and place: 3 pts (per count)

*   Grasp and place on conveyor belt: 2 pts (per count)

Time limit per evaluation: 10 minutes.

Vienna On-Site Process Differences
==================================

Compared with the regular real-robot track process, the Vienna on-site process includes these differences:

1. On-site scoring: Officials perform on-site scoring and present a live leaderboard.
2. GPU servers: The organizer plans to provide free GPU servers. Please follow the Vienna on-site dedicated group for official updates. For daily participation and development, teams are still encouraged to prioritize their own devices.
3. Data timing and format: Full-process competition datasets are released one day before each match day, and the dataset format remains consistent with the real-robot track.

On-Site Daily Schedule
====================================

.. image:: ../_static/images/REAL-I_On-Site_Competition_Schedule.jpg
   :width: 100%
   :alt: REAL-I On-Site Competition Schedule

Vienna On-Site Workflow Diagram
===============================

.. image:: ../_static/images/icra_workflow.svg
   :width: 100%
   :alt: Vienna on-site data and evaluation workflow

On-Site Schedule
================

.. raw:: html

   <iframe src="../_static/docs/REAL-I_Competition_Guide.pdf" width="100%" height="900px" style="border: 1px solid #ddd;"></iframe>
