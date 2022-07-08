resource "aws_sqs_queue" "sqs" {
  name                       = var.sqs.name
  visibility_timeout_seconds = var.sqs.visibility_timeout_seconds
  message_retention_seconds  = var.sqs.message_retention_seconds
  kms_master_key_id          = var.kms_key_id
  tags                       = local.tags
}