.. _faq:

****************
FAQs
****************

General Questions
=================================

Q: Why there are two stages in the competition (simulator stage and real-machine stage)?
    A: The simulator stage allows participants to rapidly iterate and test their algorithms in a safe and controlled environment, while the real-machine stage provides an opportunity to validate the performance of their models on actual hardware, ensuring robustness and practical applicability.

Q: How do I participate in the real-machine competition? Is this an in-person only event?
    A: All participants/teams passing the first qualification round (simulator round) may participate in the real-machine competition. All qualified teams have the option to either send their code for remote evaluation on our real-robot platform, or attend the in-person event, which will locate in Beijing, China.

Q: Am I allowed to use external datasets for training my models?
	A: No, only the datasets provided by the competition organisers are allowed to be used for model training. Use of any external datasets will lead to immediate disqualification.

Q: Are there any restrictions on the model architectures or algorithms that can be used?
	A: You can use any models or learning based algorithms you wish, as long as they can be run within the provided environment. The baseline code shows an example of what kind of models that works in our workflow. You are free to modify or replace any part of the baseline code. 

Q: How will the submissions be evaluated and how do I submit my code?
	A: For submission, we would require you to package your code and environment into a docker image, which will be run on our evaluation server. In other word, we only provide simulation environment part. It will be pretty much like how you test your model locally but surely there will be some differences like seed setting, time limit, etc. 
	Instructions on how to submit your code (for two stages) will be updated soon in the 'Submission' page.

Q: Do I have to complete all three tasks?
	A: Strictly speaking, no. But it is highly recommended to do so. The final ranking will be based on the total score of all three tasks, so completing all three tasks will give you a better chance to win the competition.

Q: Why hasn't my submission been evaluated yet?
	A: If your submission result has not appeared in the evaluation, it means your work has not been pulled by the evaluators yet. Please be patient and wait, as it usually takes 1-3 business days for evaluation, or you can contact the administrator.

Q: Why do simulation evaluations often fail? How to resolve this?
	A: There can be many reasons for evaluation failures, including but not limited to: incorrect model file paths, model file permission issues, environment configuration problems, additional downloads or configurations required. It is recommended that you first check whether the image can be loaded locally and perform inference normally. If everything works fine locally, please contact the administrator in the group, and we will help you resolve the issue as soon as possible.

Q: Why can't I submit again after submitting once?
	A: Instructions on the number of times participants can upload submissions: Each task can only be submitted once per day. Participants should thoroughly verify your work locally before uploading. If you have no submission opportunities left for the day, please wait patiently for the next day's submission opportunity, or contact the administrator if you have other questions.

Q: Is there any difference between team members?
	A: It has been repaired. There is basically no difference between the captain and the team members. Please don't set up two teams for one player, which may cause abnormal scoring.

Common Technical Issues & Resolution
=====================================================
Q: How much harddisk space do I need to set aside for the datasets and baseline code?
	A: The total size of the datasets is around 1.4TB (300GB for TASK1, 300GB for TASK2, and 800GB for TASK3). The baseline code and simulator are relatively small in size (less than 1GB). But notice that you don't have to download all datasets at once. And if you choose to use lerobot format, the size will be much smaller.

Q: How to use two repositories (baseline code and simulator) together?
	A: The baseline code repository provides an example of how to convert the dateset, model training and model inference. The simulator repository serve as the simulation environment as well as scorement system. Two repositories are independent.

Q: I am implementing model inference, but the simulator keeps reset. What should I do?
	A: Normally this is due to incorrect config settings. Please make sure all paths, names are correctly set.

Q: I am using dockers for both simulator and baseline code, but when I start model inference, nothing happens. What should I do?
	A: If you make sure all configs are correct, you might have to set up container to container communication.
