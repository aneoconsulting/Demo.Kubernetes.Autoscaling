# KMS
module "kms" {
  source = "../modules/kms"
  name   = local.kms_name
  tags   = local.tags
}

# ECR
module "ecr" {
  source       = "../modules/ecr"
  repositories = var.ecr
  kms_key_id   = module.kms.selected.arn
  tags         = local.tags
}
