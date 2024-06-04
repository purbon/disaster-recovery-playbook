variable "confluent_cloud_api_key" {
  description = "Confluent Cloud API Key (also referred as Cloud API ID)"
  type        = string
}

variable "confluent_cloud_api_secret" {
  description = "Confluent Cloud API Secret"
  type        = string
  sensitive   = true
}

variable "cluster_environment" {
  description = "Target environment name to be created or used"
  type        = string
}

variable "cluster_name" {
  description = "Target environment name to be created or used"
  type        = string
}

variable "region" {
  description = "Target region for the deployment"
  type        = string
}

variable "ownershort" {
  description = "Prefix, label per owner name"
  type        = string
}