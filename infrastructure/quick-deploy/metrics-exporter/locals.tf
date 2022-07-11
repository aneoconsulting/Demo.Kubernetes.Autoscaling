locals {
  eks = {
    cluster_endpoint      = try(var.eks.cluster_endpoint, "")
    certificate_authority = try(var.eks.certificate_authority, "")
    token                 = try(var.eks.token, "")
  }
}