variable "confluent_cloud_api_key" {
  default = ""
}

variable "confluent_cloud_api_secret" {
  default = ""
}

variable "cluster_environment" {
  default = ""
  type = string
}

variable "cluster_name" {
  default = ""
}

variable "ownershort" {
  default = "pub"
}

variable "Owner_Name" {
  default = "Pere Urbon"
}

variable "Owner_Email" {
  default = "pere@confluent.io"
}

variable "vpc_id" {
  default = ""
}

variable "subnets_to_privatelink" {
  default = ""
}

variable "aws_account_id" {
  default = ""
}

module "cemea-cluster" {
  source         = "./dedicated-privatelink-aws"
  region         = "eu-central-1"
  confluent_cloud_api_key = var.confluent_cloud_api_key
  confluent_cloud_api_secret = var.confluent_cloud_api_secret
  cluster_environment = var.cluster_environment
  cluster_name = var.cluster_name
  ownershort = "pub"
  Owner_Email = var.Owner_Email
  Owner_Name = var.Owner_Name
  vpc_id = var.vpc_id
  subnets_to_privatelink = var.subnets_to_privatelink
  aws_account_id = var.aws_account_id
}

module "public-cluster" {
  source         = "./dedicated-public"
  region         = "eu-west-3"
  confluent_cloud_api_key = var.confluent_cloud_api_key
  confluent_cloud_api_secret = var.confluent_cloud_api_secret
  cluster_environment = var.cluster_environment
  cluster_name = "${var.cluster_name}-public"
  ownershort = "pubp"
}