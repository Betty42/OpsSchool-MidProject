variable "additional_ip_addresses_for_eks_access" {
  type    = list(string)
  default = ["141.226.13.22/32"]
}
data "aws_subnet_ids" "eks_subnets" {
  vpc_id      = "${aws_vpc.OpsSchool-MidProject-VPC.id}"
}
data "aws_vpc" "eks_vpc" {
  id      = "${aws_vpc.OpsSchool-MidProject-VPC.id}"
}
terraform {
  required_version = ">= 0.12.0"
}
#provider "aws" {
#  version = ">= 2.28.1"
#  profile = "default"
#  region  = "us-east-1"
#}
provider "random" {
  version = "~> 2.1"
}
provider "local" {
  version = "~> 1.2"
}
provider "null" {
  version = "~> 2.1"
}
provider "template" {
  version = "~> 2.1"
}
data "aws_eks_cluster" "cluster" {
  name = module.eks.cluster_id
}
data "aws_eks_cluster_auth" "cluster" {
  name = module.eks.cluster_id
}
provider "kubernetes" {
  host                   = data.aws_eks_cluster.cluster.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority.0.data)
  token                  = data.aws_eks_cluster_auth.cluster.token
  load_config_file       = false
  version                = "~> 1.10"
}
data "aws_availability_zones" "available" {
}
locals {
  cluster_name = "opsSchool-eks-${random_string.suffix.result}"
}
resource "random_string" "suffix" {
  length  = 8
  special = false
}
# CIDR will be "My IP" \ all Ips from which you need to access the worker nodes
resource "aws_security_group" "worker_group_mgmt" {
  name_prefix = "worker_group_mgmt"
  vpc_id      = "${aws_vpc.OpsSchool-MidProject-VPC.id}"
  ingress {
    from_port = 22
    to_port   = 22
    protocol  = "tcp"
    cidr_blocks = var.additional_ip_addresses_for_eks_access
  }
}
resource "aws_security_group" "all_worker_mgmt" {
  name_prefix = "all_worker_management"
  vpc_id      = "${aws_vpc.OpsSchool-MidProject-VPC.id}"
  ingress {
    from_port = 22
    to_port   = 22
    protocol  = "tcp"
    cidr_blocks = [
      "0.0.0.0/0"
    ]
  }
  ingress {
    from_port = 30036
    to_port = 30036
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
module "eks" {
  source       = "terraform-aws-modules/eks/aws"
  cluster_name = local.cluster_name
  subnets      = "${aws_subnet.MidProject-Subnet-Pub.*.id}"
  tags = {
    Environment = "test"
    GithubRepo  = "terraform-aws-eks"
    GithubOrg   = "terraform-aws-modules"
  }
  vpc_id      = "${aws_vpc.OpsSchool-MidProject-VPC.id}"
  worker_groups = [
    {
      name                          = "worker-group-1"
      instance_type                 = "t2.medium"
      asg_desired_capacity          = 2
      additional_security_group_ids = [aws_security_group.worker_group_mgmt.id]
    }
  ]
  worker_additional_security_group_ids = [aws_security_group.all_worker_mgmt.id]
}
resource "null_resource" "example1" {
  provisioner "local-exec" {
    command = "aws eks update-kubeconfig --name ${local.cluster_name}"
  }
}








