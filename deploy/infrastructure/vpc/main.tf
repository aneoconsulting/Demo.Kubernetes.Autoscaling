# KMS
module "kms" {
  source = "../modules/kms"
  name   = local.kms_name
  tags   = local.tags
}

# VPC
module "vpc" {
  source       = "../modules/vpc"
  vpc          = {
    name                                            = var.vpc.name
    private_subnets                                 = var.vpc.cidr_block_private
    public_subnets                                  = var.vpc.cidr_block_public
    main_cidr_block                                 = var.vpc.main_cidr_block
    pod_cidr_block_private                          = var.vpc.pod_cidr_block_private
    enable_private_subnet                           = var.vpc.enable_private_subnet
    enable_nat_gateway                              = var.vpc.enable_private_subnet
    single_nat_gateway                              = var.vpc.enable_private_subnet
    flow_log_cloudwatch_log_group_retention_in_days = var.vpc.flow_log_cloudwatch_log_group_retention_in_days
    flow_log_cloudwatch_log_group_kms_key_id        = module.kms.selected.arn
  }
  cluster_name = var.cluster_name
  tags         = local.tags
}