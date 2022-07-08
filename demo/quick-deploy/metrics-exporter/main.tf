# Metrics exporter
module "metrics_exporter" {
  source        = "../../modules/metrics-exporter"
  docker_image  = var.metrics_exporter.docker_image
  namespace     = var.namespace
  node_selector = var.metrics_exporter.node_selector
  service_type  = var.metrics_exporter.service_type
  port          = var.metrics_exporter.port
}