output "name" {
  description = "Name of SQS queue"
  value       = aws_sqs_queue.sqs.name
}

output "visibility_timeout_seconds" {
  description = "visibility timeout seconds"
  value       = aws_sqs_queue.sqs.visibility_timeout_seconds
}

output "message_retention_seconds" {
  description = "message retention seconds"
  value       = aws_sqs_queue.sqs.message_retention_seconds
}

output "kms_key_id" {
  description = "ARN of KMS used for SQS"
  value       = var.kms_key_id
}