.. _submit:
 
**********
提交说明
**********


代码提交与评测
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

- 参考 `kuavo_data_challenge仓库 main 分支的 docker/readme <https://github.com/LejuRobotics/kuavo_data_challenge/blob/main/docker/readme.md>`_ ,将环境和代码打包为 docker 镜像提交至 `比赛官网 <https://tianchi.aliyun.com/competition/entrance/532415>`_ 。
评测结果和排行榜将在比赛官网公布。

- 注意事项

    1. 最终提交的文件为zip压缩包,里面包含两个文件,docker镜像tar文件,run_with_gpu.sh。
    

    2. 请各位选手将tar文件和zip压缩包的名字定义为  队伍/个人姓名_task{i}, 若队伍为中文可以用首字母或用个人姓名。例如我的队伍名是乐聚战队,我的姓名是kuavo,此次提交的是任务2,我的tar文件就叫lejuzhandui_task2.tar或者kuavo_task2.tar,最后提交的zip也是一样的名字。需要注意的是,run_with_gpu.sh中需要将IMAGE_NAME和CONTAINER_NAME也改成对应的名字,以免无法运行


    3. 打包镜像前,一定要注意把kuavo_sim_env.yaml里的配置改好,测试回合数(eval_episodes)为100回合,最大回合步数(max_episode_steps)不超过300(任务一和二)和600(任务三),一般200(任务一和二)和500(任务三)是足够的


    4. 提交时,一般情况使用提交结果入口即可正常提交。若文件过大导致上传失败（一般超过5G会出现这种情况）,可使用上传超大文件入口。注意上传超大文件里的命令每隔一小时会刷新。

- 视频教程
   .. video:: ../_static/videos/submit_instruction.mp4
      :width: 100%


真机赛事敬请等待...
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~