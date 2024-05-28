

variable "confluent_cloud_api_key" {
  default = ""
}

variable "confluent_cloud_api_secret" {
  default = ""
}

variable "cluster_environment" {
  default = ""
}

variable "cluster_name" {
  default = ""
}

variable "secondary_cluster_environment" {
  default = ""
}

variable "secondary_cluster_name" {
  default = ""
}

variable "ownershort" {
  default = "pub"
}

module "cemea-cluster" {
  source         = "./dedicated-cluster"
  region         = "eu-central-1"
  confluent_cloud_api_key = var.confluent_cloud_api_key
  confluent_cloud_api_secret = var.confluent_cloud_api_secret
  cluster_environment = var.cluster_environment
  cluster_name = var.cluster_name
  ownershort = var.ownershort
}

module "another-cluster" {
  source         = "./dedicated-cluster"
  region         = "eu-west-3"
  confluent_cloud_api_key = var.confluent_cloud_api_key
  confluent_cloud_api_secret = var.confluent_cloud_api_secret
  cluster_environment = var.secondary_cluster_environment
  cluster_name = var.secondary_cluster_name
  ownershort = "pubs"
}