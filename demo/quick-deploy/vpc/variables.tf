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
}

# SUFFIX
variable "suffix" {
  description = "To suffix the AWS resources"
  type        = string
}

# AWS TAGs
variable "tags" {
  description = "Tags for AWS resources"
  type        = any
  default     = {}
}

# EKS cluster name
variable "cluster_name" {
  description = "EKS cluster name"
  type        = string
}

# VPC
variable "vpc" {
  description = "Parameters of AWS VPC"
  type        = object({
    name                                            = string
    # list of CIDR block associated with the private subnet
    cidr_block_private                              = list(string)
    # list of CIDR block associated with the public subnet
    cidr_block_public                               = list(string)
    # Main CIDR block associated to the VPC
    main_cidr_block                                 = string
    # cidr block associated with pod
    pod_cidr_block_private                          = list(string)
    enable_private_subnet                           = bool
    flow_log_cloudwatch_log_group_retention_in_days = number
    peering                                         = object({
      enabled      = bool
      peer_vpc_ids = list(string)
    })
  })
}