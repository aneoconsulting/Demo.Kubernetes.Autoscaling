# Tags
variable "tags" {
  description = "Tags for resource"
  type        = any
  default     = {}
}

# KMS to encrypt ECR repositories
variable "kms_key_id" {
  description = "KMS to encrypt EBS"
  type        = string
  default     = ""
}

# VPC
variable "vpc" {
  description = "VPC info"
  type        = any
}

# AWS EKS
variable "eks" {
  description = "Parameters of AWS EKS"
  type        = object({
    name                                   = string
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
