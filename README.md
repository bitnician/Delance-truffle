# Solidity tutorial on medium
Article series can be found on my [_Medium_](https://bitnician.medium.com) profile!

## Introduction
This project that I call it **Delance** (Decentralized Freelance), is just for education purpose and no more.
After a walk through all of these series, you will be able to build your next great idea on the blockchain. (Of course, if blockchain is necessary for you and could improve your business.)

## What this project is all about?
In this project, we are going to build a freelancing platform. our participants in the project are the freelancer and employer. 
All of the freelancing projects have two important attributes: deadline and price. 
The employer usually likes to get the project before the deadline and the freelancer needs to get the project fee once he delivered the project.
The freelancer may also want to break the project to a couple of parts and request for payment after finishing each part. On the other hand, the employer would like to have some guarantee to make him sure the project will be delivered before the deadline.
Suppose the freelancer and employer get familiar together on twitter and make some agreement about the project price and the deadline.
The employer doesn’t want to deposit all of the payments before getting the project and the freelancer doesn’t want to start the project before getting any payment. 
He doesn’t even know about the financial situation of the employer. Does the employer have enough money to pay? 
Here we can use a smart contract: a self-executing contract with the terms of the agreement🔥


## Delance lifecycle

1. The employer will create a smart contract that accepts three arguments: the freelancer address, the deadline, and the project fee. the important thing here is the project fee is not just a number. the employer should deposit some ether in the smart contract. the balance of the smart contract will be the project fee. the interesting thing here is the employer cannot withdraw any amount of ether unless in some situations that we explain later. 
the image below shows the HTML form that the employer used to create a contract. notice that we don’t have an input for price. the employer should deposit some ether through his/her wallet while creating the contract. if no ether is sent, an Error will throw in the contract codes.

(https://miro.medium.com/max/1400/1*sJNfQLw_cV6C1Bz5OyjbxQ.png)

2. The freelancer can check the contract properties to see if the deadline and the project fee are matching with their agreements or not(the freelancer can find the contract on the blockchain. the contracts are also can be visible in our interface). if everything was right, the freelancer start the project.
When the project reached a good point, the freelancer can create a request and ask for some amount of ether.
the image below shows the HTML form that the freelancer used to create a request for payment.

(https://miro.medium.com/max/1400/1*S3Qvd-xIvJ6eWTbkFC0a-w.png)

3. We show all of the project details in our interface. the employer will see the freelancer requests and can unlock each of them. after that, the freelancer can withdraw the ether in just one click. the payments will be in his wallet up to 1 minute later.
Below image shows you all of the project details

(https://miro.medium.com/max/1400/1*M00OiyDw9EaUsr6Q3q-ntQ.png)


## Delance rules

Imagine the employer have a web development project. the project fee is 1 ether:

1. The freelancer has done the frontend stuff and creates a request with an amount of 0.3 ether. after the creation of a request, the freelancer should wait for the employer to unlock the request. then, the freelancer can withdraw ethers. freelancers cannot withdraw any amount of ether that is in the smart contract without the employer’s permission.

2. If the project ends before the deadline, the employer can mark the project as a completed and all of the remaining amounts of ethers that exist in the contract will be withdraw to the freelancer wallet. 
for example, the freelancer has got 0.8 ether so far. 0.3 for frontend and 0.5 for the backend. once the project is done, the employer change project status to complete and then, 0.2 ether will automatically transfer to the freelancer address.

3. If the deadline reached and the freelancer wasn’t able to deliver the final version, the employer has two option:
- The employer can increase the deadline: in this case, the freelancer would have extra time for delivering the project.
- The employer can cancel the project: in this case, all of the remaining ethers in the smart contract will be withdraw to the employer address. 
for example, the employer has unlocked 0.3 ether for the ‘frontend request’ and get the front-end codes. the freelancer got stuck in the backend and cannot deliver the project. If the deadline reached, the employer may cancel the project and 0.7 ether will automatically transfer to the freelancer address.











**[⬆ back to top](#table-of-contents)**
