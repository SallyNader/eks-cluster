![final-eks-project](https://user-images.githubusercontent.com/14328150/190855165-e39db11a-0173-46b7-84ac-f36c7225a6a7.PNG)

## Project Summery:
This project aim to build infrastructure in multiple availability zones to provide high availability and scalability, this IAC will build the following:
<br/>
1- Create VPC with public subnets, private subnets, NAT gateway and internet gateway.<br/>
2- Create NFS.<br/>
3- Use backend state to save the state of terraform on it using s3 and dynamodb database.<br/>
4- EKS cluster and deploy EC2 instances on multiple availability zones.<br/>
5- Creates auto scaling group to build bastion hosts to be able to ssh to EC2 instances on private network.<br/>
6- Scans the project code using Sonarqube to check code quality.<br/>

## Tools:

1- AWS            <br/>
2- Terraform        <br/>
3- Ansible        <br/>
4- Kubernetes<br/>
5- Jenkins<br/>
6- Sonarqube<br/>

## Prequesties: <br/>
1- You should have AWS account.  <br/>
2- You have to configure AWS CLI on your local machine.<br/>
3- You have to install and configure Jenkins on your local machine or on AWS EC2 instance.<br/>
4- You have to install and configure Sonarqube on your local machine or on AWS EC2 instance.<br/>
5- Install kubectl on your local machine.<br/>

## Steps:
1- Create Jenkins pipeline and put github url.<br/>
2- Add Sonarqube token to Jenkins configuration and change Sonarqube url in Jenkins pipeline file. <br/>
3- After running the pipeline successfully you can connect to the cluster on AWS through command **aws eks --region us-east-1 update-kubeconfig --name clusterName**
<br/>
also you can check if kubectl connected to the cluster **kubectl config view**  <br/>
to check cluster status **aws eks --region us-east-1 describe-cluster --name clusterName --query cluster.status**
