.. _task:

********************
Task Description
********************

At its core, this competition is based on real dual-arm humanoid robots, with several tasks thoughtfully prepared that are highly representative of typical industrial applications workflow. In addition, a simulation environment that closely resembles the task workflows of the real robot is also provided, along with open access to high-quality task datasets, evaluation scripts, complete execution pipelines, online evaluation servers and ready-to-run baseline code. 
The simulation track is especially designed for competitors to familiarise themselves with the Kuavo robot dataset formats, algorithm development and algorithm testing with our baseline code. It also simulates and selects teams with highly matured algorithms that are highly worthy of real-robot competition in a fair manner.

Simulation Task Description
================================

Task 1: Toy Sorting
----------------------------------------------------------------------------

In this task, there will be assorted toys randomly laid out on a desk surface. The robot needs to grasp the toys, and place all the animal toys into the right basket, while all the car toys go into the left basket.

Within this task, the robot will start from a reasonable randomised location away from the desk; the height of the desk as well as the assortment of toys on the desk are also randomised.

- Scoring standards:
    a. 40 pts for every correct placement of each of the toys

    b. 20 pts for completing it within a specified timeframe. 1-pt **penalty** will be applied for every second elapsed outside of this timeframe

.. image:: ../_static/images/task3_sim.png

Task 2: Parcel Weighing
----------------------------------------------------------------

In this task, the robot is required to pick up a soft-pouch express parcel from a moving conveyor belt, place it on an electronic scale for weighing, and then transfer it to another conveyor belt.

Within this task, the positioning of the parcel and the scale will be randomised within a reasonable range.

Each task is out of 100 base points as the base task score.

- Scoring standards:
    a. 40 pts for the correct placement of the object onto its desginated area (the electronic scale)

    b. 40 pts for the correct placement of the object after weighing

    c. 20 pts for completing it within a specified timeframe. 1-pt **penalty** will be applied for every second elapsed outside of this timeframe

.. image:: ../_static/images/task2_sim.jpg


Task 3: Conveyor Belt Parts Sorting
----------------------------------------------------------------

In this task, the robot needs to pick up a component chosen from different categories representative in the industrial setting, lying in a randomised orientation on a moving conveyor belt, and then place the component into the correct sorting bin. 
Four such components are given in this task, and the task is considered as successful after correct placements of all four such components.

Within this task, the height of the conveyor, the positioning and orientation of the component, as well as when the component will be dropped off onto the conveyor belt, will be randomised within a reasonable range.

- Scoring standards:
    a. 20 pts for each successful sequence of grasp and final placement of each of the components

    b. 10 pts for successful completion of all four components in a row

    c. 10 pts for completing it within a specified timeframe. 1-pt **penalty** will be applied for every second elapsed outside of this timeframe

.. image:: ../_static/images/task2_sim.png


Real-machine Task Description
==================================

Task 1: Small Part Flipping
----------------------------------------------------------------------------

In this task, the robot stands still while the conveyor belt runs at medium speed to transport parts, and the robot performs flipping operations on the parts that need to be flipped.



.. image:: ../_static/images/task1_real.jpg

Task 2: Express Fackage Weighing
----------------------------------------------------------------

In this task, the robot stands still, grabs the express package on the table and places it on the weighing platform, checks whether the express label is facing up to determine if it needs to be flipped, and then places the package on the conveyor belt on the left-hand side.


Two express packages will be provided here, and the task is considered successful when both are correctly flipped and placed on the conveyor belt.

.. image:: ../_static/images/task2_real.jpg

Task 3: Unilever
----------------------------------------------------------------

In this task, Pick up the bottle from the table and place it on the conveyor belt.


Two bottles will be provided here, and placing both on the conveyor belt counts as completing the task.

.. image:: ../_static/images/task3_real.jpg
