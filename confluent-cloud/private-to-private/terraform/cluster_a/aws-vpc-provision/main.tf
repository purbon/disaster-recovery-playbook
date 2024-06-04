terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.68"
    }
  }
}

provider "aws" {
  region = var.region
}


variable "myips" {
  type    = list(string)
  default = []
}

locals {
 //  myip-cidr = "${var.myip}/32"
  myip-cidrs = [for myip in var.myips : "${myip}/32" ]
}

locals {
  jumphost-instance-type = "t3.2xlarge"
}


resource "aws_vpc" "bootcamp_cemea" {
  cidr_block = "10.0.0.0/16"
  instance_tenancy = "default"
  enable_dns_support = true
  enable_dns_hostnames = true

  tags = {
    Name = "${var.ownershort}-ccloud-test"
  }
}

resource "aws_subnet" "bootcamp_cemea" {
  count      = 3
  vpc_id     = aws_vpc.bootcamp_cemea.id
  cidr_block = "10.0.${10+count.index}.0/24"
  availability_zone = element(var.azs, count.index)
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.ownershort}-vpc-subnet-ccloud-${element(var.azs, count.index)}"
    Owner_Name = var.Owner_Name
    Owner_Email = var.Owner_Email
  }
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.bootcamp_cemea.id

  tags = {
      Name = "${var.ownershort}-vpc-gw"
      Owner_Name = var.Owner_Name
      Owner_Email = var.Owner_Email
  }
}

resource "aws_default_route_table" "bootcamp_vpc_route_table" {
  default_route_table_id = aws_vpc.bootcamp_cemea.default_route_table_id

  #route {
  #  cidr_block = "10.0.0.0/16"
  #  gateway_id = aws_internet_gateway.example.id
  #}

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = {
    Name = "${var.ownershort}-vpc-default-routing-table"
    Owner_Name = var.Owner_Name
    Owner_Email = var.Owner_Email
  }
}