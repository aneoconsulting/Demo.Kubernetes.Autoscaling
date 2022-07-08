# Tags
variable "tags" {
  description = "Tags for resource"
  type        = any
}

# KMS to encrypt ECR repositories
variable "kms_key_id" {
  description = "KMS to encrypt ECR repositories"
  type        = string
}

# Name of SQS queue
variable "sqs" {
  description = "SQS info"
  type        = object({
    name                       = string
    visibility_timeout_seconds = number
    message_retention_seconds  = number
  })
}