locals {
  # Keda
  keda_namespace              = try(var.namespace, "default")
  keda_keda_image             = try(var.keda.docker_image.keda.image, "ghcr.io/kedacore/keda")
  keda_keda_tag               = try(var.keda.docker_image.keda.tag, "latest")
  keda_metricsApiServer_image = try(var.keda.docker_image.metricsApiServer.image, "ghcr.io/kedacore/keda-metrics-apiserver")
  keda_metricsApiServer_tag   = try(var.keda.docker_image.metricsApiServer.tag, "latest")
  keda_node_selector          = try(var.keda.node_selector, {})
  eks                         = {
    cluster_endpoint      = try(var.eks.cluster_endpoint, "")
    certificate_authority = try(var.eks.certificate_authority, "")
    token                 = try(var.eks.token, "")
  }
}