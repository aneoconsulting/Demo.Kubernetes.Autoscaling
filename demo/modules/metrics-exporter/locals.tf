locals {
  node_selector_keys   = keys(var.node_selector)
  node_selector_values = values(var.node_selector)
  host                 = kubernetes_service.metrics_exporter.spec.0.cluster_ip
  port                 = kubernetes_service.metrics_exporter.spec.0.port.0.port
  url                  = "${kubernetes_service.metrics_exporter.spec.0.cluster_ip}:${kubernetes_service.metrics_exporter.spec.0.port.0.port}"
}