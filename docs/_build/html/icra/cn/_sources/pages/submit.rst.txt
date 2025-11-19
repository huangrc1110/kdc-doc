.. _submit:
 
**********
Submission
**********


Code Submission and Evaluation
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Please refer to the `kuavo_data_challenge main branch docker/readme <https://github.com/LejuRobotics/kuavo_data_challenge/blob/main/docker/readme.md>`_ documentation to pack the environment and codebase into a docker image, and then submit it through our `competition website <https://tianchi.aliyun.com/competition/entrance/532415>`_.

The official evaluation results and leaderboard will be updated in real-time on our competition website.

Important Notes
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

1. 最终提交的文件为zip压缩包, 里面包含两个文件, docker镜像tar文件, run_with_gpu.sh
。

2. 请各位选手将tar文件和zip压缩包的名字定义为  队伍/个人姓名_task{i}, 若队伍为中文可以用首字母或用个人姓名。例如我的队伍名是乐聚战队,我的姓名是kuavo,此次提交的是任务2,我的tar文件就叫lejuzhandui_task2.tar或者kuavo_task2.tar,最后提交的zip也是一样的名字。需要注意的是,run_with_gpu.sh中需要将IMAGE_NAME和CONTAINER_NAME也改成对应的名字,以免无法运行
。

3. 打包镜像前, 一定要注意把kuavo_sim_env.yaml里的配置改好, 测试回合数(eval_episodes)为100回合,最大回合步数(max_episode_steps)不超过300(任务一和二)和600(任务三), 一般200(任务一和二)和500(任务三)是足够的
。

4. 提交时, 一般情况使用提交结果入口即可正常提交。若文件过大导致上传失败(一般超过5G会出现这种情况), 可使用上传超大文件入口。注意上传超大文件里的命令每隔一小时会刷新
。

5. 提交前，请先确认好已经成功加入队伍(个人选手可以不用)，若提交并获得到成绩后更改队伍或加入队伍，之前的成绩会作废。每队仅需一名选手提交, 请勿重复提交
。

6. 官方评测系统和本地仓库评测系统类似，各位选手提交前可以先在本地测试自己的模型性能，以便随时修改自己的代码，性能调试后再提交，以免过多浪费其他选手的评测资源
。

7. 提交后，若评测成功，可以在天池竞赛提交页看到自己的分数，若评测失败，会显示评测失败并显示原因，此时请检查提交的文件是否正确
。

Video Guide on How to Submit (Please skip the lengthy packing and downloading processes)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   .. video:: ../_static/videos/submit_instruction.mp4
      :width: 100%


Real-machine competition details coming soon...
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~