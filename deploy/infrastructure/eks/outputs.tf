output "eks" {
  description = "EKS info"
  value       = {
    kms_arn = module.eks.kms_key_id
  }
}