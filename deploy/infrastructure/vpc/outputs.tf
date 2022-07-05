output "vpc" {
  description = "VPC info"
  value       = {
    id                     = module.vpc.id
    cidr_block             = module.vpc.cidr_block
    pod_cidr_block_private = module.vpc.pod_cidr_block_private
    private_subnet_ids     = module.vpc.private_subnet_ids
    public_subnet_ids      = module.vpc.public_subnet_ids
    pods_subnet_ids        = module.vpc.pods_subnet_ids
    kms_arn                = module.vpc.kms_key_id
  }
}