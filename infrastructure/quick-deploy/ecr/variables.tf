# Profile
variable "profile" {
  description = "Profile of AWS credentials to deploy Terraform sources"
  type        = string
}

# Region
variable "region" {
  description = "AWS region where the infrastructure will be deployed"
  type        = string
}

# SUFFIX
variable "suffix" {
  description = "To suffix the AWS resources"
  type        = string
  default     = ""
}

# AWS TAGs
variable "tags" {
  description = "Tags for AWS resources"
  type        = any
  default     = {}
}

# List of ECR repositories to create
variable "ecr" {
  description = "List of ECR repositories to create"
  type        = list(any)
}