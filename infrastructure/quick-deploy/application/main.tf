# Metrics exporter
module "application" {
  source               = "../../modules/application"
  docker_image         = var.application.docker_image
  namespace            = var.namespace
  node_selector        = var.application.node_selector
  service_type         = var.application.service_type
  port                 = var.application.port
  hpa                  = var.application.hpa
  metrics_exporter_url = local.metrics_exporter_url
  sqs_name             = local.sqs_name
  region               = var.region
}