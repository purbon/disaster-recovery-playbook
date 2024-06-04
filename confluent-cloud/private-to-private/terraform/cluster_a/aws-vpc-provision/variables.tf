variable "region" {
  description = "The AWS Region of the existing VPC"
  type        = string
}

variable "ownershort" {
  description = "Prefix, label per owner name"
  type        = string
}

variable "Owner_Name" {
  description = "Owner Name"
  type        = string
}

variable "Owner_Email" {
  description = "Owner email"
  type        = string
}

variable "azs" {
  description = "Run the EC2 Instances in these Availability Zones"
  type = list
}

variable "key_name" {}


data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}