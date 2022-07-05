# Tags
variable "tags" {
  description = "Tags for resource"
  type        = any
  default     = {}
}

# KMS to encrypt ECR repositories
variable "kms_key_id" {
  description = "KMS to encrypt ECR repositories"
  type        = string
  default     = ""
}

# List of ECR repositories to create
variable "repositories" {
  description = "List of ECR repositories to create"
  type        = list(object({
    name  = string
    image = string
    tag   = string
  }))
}