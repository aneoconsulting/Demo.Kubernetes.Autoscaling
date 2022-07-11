locals {
  node_selector_keys   = keys(var.node_selector)
  node_selector_values = values(var.node_selector)
  host                 = kubernetes_service.application.status.0.load_balancer.0.ingress.0.hostname
  port                 = kubernetes_service.application.spec.0.port.0.port
  url                  = "${local.host}:${local.port}"

  # HPA
  hpa_triggers = {
    triggers = [
    for trigger in try(var.hpa.triggers, []) :
    {
      type     = "external"
      metadata = {
        scalerAddress = var.metrics_exporter_url
        sqsQueue      = var.sqs_name
        region        = var.region
        message_count = trigger.message_count
      }
    }
    ]
  }

  triggers = {
    triggers = [for trigger in local.hpa_triggers.triggers : trigger if trigger != {}]
  }
}