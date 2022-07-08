# SQS images
output "sqs" {
  description = "SQS info"
  value       = {
    name                       = module.sqs.name
    kms_key_id                 = module.sqs.kms_key_id
    visibility_timeout_seconds = module.sqs.visibility_timeout_seconds
    message_retention_seconds  = module.sqs.message_retention_seconds
  }
}