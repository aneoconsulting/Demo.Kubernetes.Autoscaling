# Profile
variable "profile" {
  description = "Profile of AWS credentials to deploy Terraform sources"
  type        = string
  default     = "default"
}

# Region
variable "region" {
  description = "AWS region where the infrastructure will be deployed"
  type        = string
  default     = "us-east-1"
}

# S3 for backend
variable "backend" {
  description = "S3 bucket name for the backend of Terraform"
  type        = any
}

# SUFFIX
variable "suffix" {
  description = "To suffix the AWS resources"
  type        = string
  default     = ""
}

# tags
variable "tags" {
  description = "List of tags"
  type        = map(string)
}

# VPC
variable "vpc" {
  description = "Parameters of AWS VPC"
  type        = any
}

# Cluster name
variable "cluster_name" {
  description = "EKS cluster name"
  type        = string
}

# AWS EKS
variable "eks" {
  description = "Parameters of AWS EKS"
  type        = object({
    version                                = string
    cloudwatch_log_group_retention_in_days = number
    cluster_endpoint_private_access        = bool
    cluster_endpoint_public_access         = bool
    cluster_endpoint_public_access_cidrs   = list(string)
    aws_auth_roles                         = list(object({
      rolearn  = string
      username = string
      groups   = list(string)
    }))
    aws_auth_users                         = list(object({
      userarn  = string
      username = string
      groups   = list(string)
    }))
  })
}