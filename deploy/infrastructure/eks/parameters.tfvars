# Profile
profile = "default"

# Region
region = "us-east-1"

# SUFFIX
suffix = "demo"

# tags
tags = {}

# Cluster name
cluster_name = "demo-cluster"

# AWS EKS
eks = {
  version                                = "1.22"
  cloudwatch_log_group_retention_in_days = 30
  cluster_endpoint_private_access        = true
  cluster_endpoint_public_access         = true
  cluster_endpoint_public_access_cidrs   = ["0.0.0.0/0"]
  aws_auth_roles                         = []
  aws_auth_users                         = []
}