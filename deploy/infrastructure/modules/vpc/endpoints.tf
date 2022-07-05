module "vpc_endpoints" {
  source             = "terraform-aws-modules/vpc/aws//modules/vpc-endpoints"
  version            = "3.14.2"
  vpc_id             = module.vpc.vpc_id
  security_group_ids = [module.vpc.default_security_group_id]
  create             = true
  tags               = local.tags
  depends_on         = [
    module.vpc
  ]

  endpoints = {
    ec2_autoscaling = {
      service             = "autoscaling"
      private_dns_enabled = var.vpc.enable_private_subnet
      subnet_ids          = var.vpc.enable_private_subnet ? matchkeys(module.vpc.private_subnets, tolist(module.vpc.private_subnets_cidr_blocks), var.vpc.private_subnets) : []
      security_group_ids  = var.vpc.enable_private_subnet ? [module.vpc.default_security_group_id] : []
    }
    ec2             = {
      service             = "ec2"
      private_dns_enabled = var.vpc.enable_private_subnet
      subnet_ids          = var.vpc.enable_private_subnet ? matchkeys(module.vpc.private_subnets, tolist(module.vpc.private_subnets_cidr_blocks), var.vpc.private_subnets) : []
      security_group_ids  = var.vpc.enable_private_subnet ? [module.vpc.default_security_group_id] : []
    }
    ecr_dkr         = {
      service             = "ecr.dkr"
      private_dns_enabled = var.vpc.enable_private_subnet
      subnet_ids          = var.vpc.enable_private_subnet ? matchkeys(module.vpc.private_subnets, tolist(module.vpc.private_subnets_cidr_blocks), var.vpc.private_subnets) : []
      security_group_ids  = var.vpc.enable_private_subnet ? [module.vpc.default_security_group_id] : []
    }
    ecr_api         = {
      service             = "ecr.api"
      private_dns_enabled = var.vpc.enable_private_subnet
      subnet_ids          = var.vpc.enable_private_subnet ? matchkeys(module.vpc.private_subnets, tolist(module.vpc.private_subnets_cidr_blocks), var.vpc.private_subnets) : []
      security_group_ids  = var.vpc.enable_private_subnet ? [module.vpc.default_security_group_id] : []
    }
    sts             = {
      service             = "sts"
      private_dns_enabled = var.vpc.enable_private_subnet
      subnet_ids          = var.vpc.enable_private_subnet ? matchkeys(module.vpc.private_subnets, tolist(module.vpc.private_subnets_cidr_blocks), var.vpc.private_subnets) : []
      security_group_ids  = var.vpc.enable_private_subnet ? [module.vpc.default_security_group_id] : []
    }
    ssm             = {
      service             = "ssm"
      private_dns_enabled = var.vpc.enable_private_subnet
      subnet_ids          = var.vpc.enable_private_subnet ? matchkeys(module.vpc.private_subnets, tolist(module.vpc.private_subnets_cidr_blocks), var.vpc.private_subnets) : []
      security_group_ids  = var.vpc.enable_private_subnet ? [module.vpc.default_security_group_id] : []
    }
    ssmmessages     = {
      service             = "ssmmessages"
      private_dns_enabled = var.vpc.enable_private_subnet
      subnet_ids          = var.vpc.enable_private_subnet ? matchkeys(module.vpc.private_subnets, tolist(module.vpc.private_subnets_cidr_blocks), var.vpc.private_subnets) : []
      security_group_ids  = var.vpc.enable_private_subnet ? [module.vpc.default_security_group_id] : []
    }
    sqs             = {
      service             = "sqs"
      private_dns_enabled = var.vpc.enable_private_subnet
      subnet_ids          = var.vpc.enable_private_subnet ? matchkeys(module.vpc.private_subnets, tolist(module.vpc.private_subnets_cidr_blocks), var.vpc.private_subnets) : []
      security_group_ids  = var.vpc.enable_private_subnet ? [module.vpc.default_security_group_id] : []
    }
  }
}