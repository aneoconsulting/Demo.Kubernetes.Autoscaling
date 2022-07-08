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

# Name of SQS queue
variable "sqs" {
  description = "SQS info"
  type        = object({
    name                       = string
    visibility_timeout_seconds = number
    message_retention_seconds  = number
  })
}