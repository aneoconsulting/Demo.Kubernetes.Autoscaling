# Metrics exporter deployment
resource "kubernetes_deployment" "metrics_exporter" {
  metadata {
    name      = "metrics-exporter"
    namespace = var.namespace
    labels    = {
      app     = "demo"
      type    = "metrics"
      service = "metrics-exporter"
    }
  }
  spec {
    replicas = 1
    selector {
      match_labels = {
        app     = "demo"
        type    = "metrics"
        service = "metrics-exporter"
      }
    }
    template {
      metadata {
        name      = "metrics-exporter"
        namespace = var.namespace
        labels    = {
          app     = "demo"
          type    = "metrics"
          service = "metrics-exporter"
        }
      }
      spec {
        dynamic toleration {
          for_each = (var.node_selector != {} ? [
          for index in range(0, length(local.node_selector_keys)) : {
            key   = local.node_selector_keys[index]
            value = local.node_selector_values[index]
          }
          ] : [])
          content {
            key      = toleration.value.key
            operator = "Equal"
            value    = toleration.value.value
            effect   = "NoSchedule"
          }
        }
        dynamic image_pull_secrets {
          for_each = (var.docker_image.image_pull_secrets != "" ? [1] : [])
          content {
            name = var.docker_image.image_pull_secrets
          }
        }
        # Control plane container
        container {
          name              = "metrics-exporter"
          image             = var.docker_image.tag != "" ? "${var.docker_image.image}:${var.docker_image.tag}" : var.docker_image.image
          image_pull_policy = "IfNotPresent"
          port {
            name           = "metrics"
            container_port = var.port
          }
        }
      }
    }
  }
}

# Control plane service
resource "kubernetes_service" "metrics_exporter" {
  metadata {
    name      = kubernetes_deployment.metrics_exporter.metadata.0.name
    namespace = kubernetes_deployment.metrics_exporter.metadata.0.namespace
    labels    = {
      app     = kubernetes_deployment.metrics_exporter.metadata.0.labels.app
      service = kubernetes_deployment.metrics_exporter.metadata.0.labels.service
    }
  }
  spec {
    type     = var.service_type
    selector = {
      app     = kubernetes_deployment.metrics_exporter.metadata.0.labels.app
      service = kubernetes_deployment.metrics_exporter.metadata.0.labels.service
    }
    port {
      name        = kubernetes_deployment.metrics_exporter.spec.0.template.0.spec.0.container.0.port.0.name
      port        = var.port
      target_port = var.port
      protocol    = "TCP"
    }
  }
}