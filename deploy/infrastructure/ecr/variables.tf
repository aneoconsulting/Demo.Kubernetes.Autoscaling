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

# List of ECR repositories to create
variable "ecr" {
  description = "List of ECR repositories to create"
  type        = list(object({
    name  = string
    image = string
    tag   = string
  }))
}