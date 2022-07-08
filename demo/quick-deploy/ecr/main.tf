# AWS KMS
module "kms" {
  source = "../../modules/aws/kms"
  name   = local.kms_name
  tags   = local.tags
}

# AWS ECR
module "ecr" {
  source       = "../../modules/aws/ecr"
  tags         = local.tags
  kms_key_id   = module.kms.selected.arn
  repositories = var.ecr
}