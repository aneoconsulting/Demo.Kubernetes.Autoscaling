# KMS
module "kms" {
  source = "../modules/kms"
  name   = local.kms_name
  tags   = local.tags
}

# EKS
module "eks" {
  source     = "../modules/eks"
  eks        = {
    name                                   = var.cluster_name
    version                                = var.eks.version
    cloudwatch_log_group_retention_in_days = var.eks.cloudwatch_log_group_retention_in_days
    cluster_endpoint_private_access        = var.eks.cluster_endpoint_private_access
    cluster_endpoint_public_access         = var.eks.cluster_endpoint_public_access
    cluster_endpoint_public_access_cidrs   = var.eks.cluster_endpoint_public_access_cidrs
    aws_auth_roles                         = var.eks.aws_auth_roles
    aws_auth_users                         = var.eks.aws_auth_users
  }
  vpc        = {
    id         = try(var.vpc.id, "")
    subnet_ids = try(var.vpc.private_subnet_ids, [])
  }
  kms_key_id = module.kms.selected.arn
  tags       = local.tags
}