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

Common Technical Issues & Resolution
=====================================================
Q: How to use two repositories (baseline code and simulator) together?
	A: The baseline code repository provides an example of how to convert the dateset, model training and model inference. The simulator repository serve as the simulation environment as well as scorement system. Two repositories are independent.

Q: I am implementing model inference, but the simulator keeps reset. What should I do?
	A: Normally this is due to incorrect config settings. Please make sure all paths, names are correctly set.

Q: I am using dockers for both simulator and baseline code, but when I start model inference, nothing happens. What should I do?
	A: If you make sure all configs are correct, you might have to set up container to container communication.
