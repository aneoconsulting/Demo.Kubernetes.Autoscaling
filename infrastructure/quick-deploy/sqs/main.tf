# AWS KMS
module "kms" {
  source = "../../modules/aws/kms"
  name   = local.kms_name
  tags   = local.tags
}

# AWS SQS
module "sqs" {
  source     = "../../modules/aws/sqs"
  tags       = local.tags
  kms_key_id = module.kms.selected.arn
  sqs        = {
    name                       = local.sqs.name
    visibility_timeout_seconds = local.sqs.visibility_timeout_seconds
    message_retention_seconds  = local.sqs.message_retention_seconds
  }
}