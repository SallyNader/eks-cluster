![final-eks-project](https://user-images.githubusercontent.com/14328150/190855165-e39db11a-0173-46b7-84ac-f36c7225a6a7.PNG)

## Project Summery:
This project aim to build infrastructure in multiple availability zones to provide high availability and scalability, this IAC will build the following:
<br/>
1- Creates VPC with public subnets and private subnets, NAT gateway and internet gateway.<br/>
2- Creates EFS.<br/>
3- Uses remote backend state to save the state of terraform on it using s3 and dynamodb database.<br/>
4- Creates EKS cluster and deploy EC2 instances on multiple availability zones.<br/>
5- Creates auto scaling group to build bastion hosts to be able to ssh to EC2 instances on private network.<br/>
6- Creates kubernetes deployments and services to deploy node.js project.<br/>
7- Scans the project code using Sonarqube to check code quality.<br/>
## Tools:

1- AWS            <br/>
2- Terraform        <br/>
3- Kubernetes<br/>
4- Jenkins<br/>
5- Sonarqube<br/>

## Prequesties: <br/>
1- You should have AWS account.  <br/>
2- You have to configure AWS CLI on your local machine.<br/>
3- You have to install and configure Jenkins on your local machine or on AWS EC2 instance.<br/>
4- You have to install and configure Sonarqube on your local machine or on AWS EC2 instance.<br/>
5- Install kubectl on your local machine.<br/>

## Steps:
1- Create Jenkins pipeline and put github url.<br/>
2- Add Sonarqube token to Jenkins configuration and change parameters in Jenkins pipeline file. <br/>
3- After running the pipeline successfully you can connect to the cluster on AWS through command **aws eks --region us-east-1 update-kubeconfig --name clusterName**
<br/>
also you can check if kubectl connected to the cluster through command **kubectl config view**  <br/>
to check cluster status **aws eks --region us-east-1 describe-cluster --name clusterName --query cluster.status**   <br/>
4- Now you can deploy kubernetes deployments and services, you have to ssh to bastion host to be able to ssh to EC2 instance in private subnet that located on eks cluster. <br/>
5- After connecting to the private EC2 instance you can deploy node.js deployments and services through command  **kubectl apply -f pathTofile** ,
**note:** you will find the project files in **/home/ec2-user/project** because nfs monut data here.
