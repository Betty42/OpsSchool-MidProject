# OpsSchool-MidProject
Opsschool Mid Course project. Creates a VPC (on us-east-1 by default) with two availability zones, each one with two subnets, one public and one private. The public subnets contain a single NAT, a Jenkins master (on one subnet), and a Jenkins node (on the other). The private subnets contain an EKS master and a worker group. Once the Jenkins is up and the required credentials are entered, you can configure a pipeline job to get a phonebook app from git, dockerfy it, and deploy it to EKS, on two pods with a load-balancer.
In this assignment you will build a small prod like environment

Opsschool Mid Course project's goal is to deploy a highly available web application on AWS, that is publicly accessible (open to the internet).
Tools used:
*   Ansible – Configuration Management
*   Terraform – Infrastructure Provisioning
*   K8s – Container Orchestration Platform
*   Docker – Container Runtime
*   Consul – Service Discovery
*   Jenkins – CICD

# The Infrastructure
*   VPC (us-east-1)
*   2 availability zones, each one with 2 subnets, public and private
*   Jenkins master & Jenkins node
*   EKS master and a worker group on private subnets

# Requirements
*   Terraform >0.12.20
*   Ansible >2.9.2
*   Github User
*   AWS - User, AWS CLI, Keypair

# Make it work
*Terraform*

```git clone https://github.com/Betty42/OpsSchool-MidProject```

```terraform init```

```terraform validate```

```terraform plan```

```terraform apply```

*_Jenkins_*
* Connect to master with port 8080
* Download Plugins
* Create Github Credentials
* Create Dockerhub Credentials
* Connect the node
* Run Pipeline from Jenkinsfile using SCM

# What you get

is a pipeline job that gets a sample app from github. 
The app gets dockerfied and deployed to EKS on 2 pods with a LB

# Get rid of it
```terraform destroy``` :boom:

