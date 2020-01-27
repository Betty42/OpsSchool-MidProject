variable "aws_access_key" {}
variable "aws_secret_key" {}
variable "private_key_path" {}
variable "key_name" {}

variable "aws_region" {
  default = "us-east-1"
}

variable "consul_version" {
  default = "1.4.0"
}

variable "azs" {
  type = "list"
  default = ["us-east-1a", "us-east-1b"]
}

variable "vpc_cidr" {
  default = "10.0.0.0/16"
}
