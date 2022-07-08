locals {
  eks                  = {
    cluster_endpoint      = try(var.eks.cluster_endpoint, "")
    certificate_authority = try(var.eks.certificate_authority, "")
    token                 = try(var.eks.token, "")
  }
  sqs_name             = try(var.sqs.name, "")
  metrics_exporter_url = try(var.metrics_exporter.url, "")
}