output "ecr" {
  description = "ecr info"
  value       = {
    repositories = module.ecr.repositories
    kms_arn      = module.ecr.kms_key_id
  }
}