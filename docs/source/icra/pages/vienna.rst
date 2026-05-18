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

.. note::
   This section is reserved for on-site task descriptions.
   (To be filled manually.)

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