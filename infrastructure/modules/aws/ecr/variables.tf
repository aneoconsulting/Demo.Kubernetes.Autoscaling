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

# List of ECR repositories to create
variable "repositories" {
  description = "List of ECR repositories to create"
  type        = list(any)
}