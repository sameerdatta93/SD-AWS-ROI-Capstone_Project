Capstone Project

Region: us-east-1

Description: The project will create a VPC, 2 public subnets (multi-AZ), 2 private subnets, 1 db subnet, IGW, NAt Gateway (for private subnet ec2 to install nginx via user data during startup) and updated route tables.
Have created a sample application and deployed to ec2. Application gets installed and server get started in the user data script of the ec2. EC2 are inside private subnet and in ASG which is explosed via ALB which is internet facing. The sg of ec2 allows traffic from ALB sg.
RDS is created in separate rds subnet which allows traffic only from ec2 sg. 
ALB is deployed in public subnet and in multi-AZ for high availability. Cross Zone Load balancing is enabled by default in ALB. 
Application is exposed via ALB.

Steps to run Terraform:
1. Create a new EC2 instance with basic Linux AMI in default subnet with internet connectivity, region = us-east-1 and enter below user-data in advanced details section while creating ec2. This will install terraform.
#!/bin/bash 
sudo yum install -y yum-utils
sudo yum-config-manager --add-repo https://rpm.releases.hashicorp.com/AmazonLinux/hashicorp.repo
sudo yum -y install terraform
cd /home/ec2-user/
git clone https://github.com/sameerdatta93/SD-AWS-ROI-Capstone_Project.git
chown -R ec2-user:ec2-user /home/ec2-user/SD-AWS-ROI-Capstone_Project
2. Allow it some time to execute user data. It will install terraform and checkout git. So no need to checkout manually.
3. Create and download the secret access key for your account, if not already downloaded
4. Connect the ec2 instance using ec2 Instance connect
5. Configure the aws with access keys using 'aws configure' command. Enter region as us-east-1
6. Go inside the git checkout folder using 'cd SD-AWS-ROI-Capstone_Project/capstone/'
7. Run terraform init
8. Run terraform plan (total 26 resources) and apply
9. Post Apply, we will be getting the alb url as the output which we can use to open the application
    Note: Wait for few minutes(1-2 mins) for the application to launch required services for the frontend to be loaded.
10. Destroy towards the end if not required.

Note: Application is just a basic feedback collection form with some basic validation and on submit entries should have been stored in RDS. Backend application is not setup entirely as was facing some issues, also IAM was supposed to be created for it to interact with DB. So only the frontend is visible for now and the backend connection is missing.
Infrastructure is completed from app functinality point of view, could include some good to have things like Route53, IAM, secret variables, CW metrics for scaling in actual scenario.  
To run in diffent environments we can have different tfvars and can specify tfvar file name during apply if it is for dev, prod etc


