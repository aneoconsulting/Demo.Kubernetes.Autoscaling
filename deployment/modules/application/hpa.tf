resource "helm_release" "keda_hpa" {
  name       = "hpa"
  namespace  = var.namespace
  chart      = "keda-hpa"
  repository = "${path.module}/charts"
  version    = "0.1.0"

  set {
    name  = "suffix"
    value = "demo"
  }
  set {
    name  = "type"
    value = try(var.hpa.type, "")
  }
  set {
    name  = "scaleTargetRef.apiVersion"
    value = "apps/v1"
  }
  set {
    name  = "scaleTargetRef.kind"
    value = "Deployment"
  }
  set {
    name  = "scaleTargetRef.name"
    value = kubernetes_deployment.application.metadata.0.name
  }
  set {
    name  = "scaleTargetRef.envSourceContainerName"
    value = kubernetes_deployment.application.spec.0.template.0.spec.0.container.0.name
  }
  set {
    name  = "pollingInterval"
    value = try(var.hpa.polling_interval, 30)
  }
  set {
    name  = "cooldownPeriod"
    value = try(var.hpa.cooldown_period, 300)
  }
  set {
    name  = "idleReplicaCount"
    value = try(var.hpa.idle_replica_count, 0)
  }
  set {
    name  = "minReplicaCount"
    value = try(var.hpa.min_replica_count, 1)
  }
  set {
    name  = "maxReplicaCount"
    value = try(var.hpa.max_replica_count, 1)
  }
  set {
    name  = "behavior.restoreToOriginalReplicaCount"
    value = try(var.hpa.restore_to_original_replica_count, true)
  }
  set {
    name  = "behavior.stabilizationWindowSeconds"
    value = try(var.hpa.behavior.stabilization_window_seconds, 300)
  }
  set {
    name  = "behavior.type"
    value = try(var.hpa.behavior.type, "Percent")
  }
  set {
    name  = "behavior.value"
    value = try(var.hpa.behavior.value, 100)
  }
  set {
    name  = "behavior.periodSeconds"
    value = try(var.hpa.behavior.period_seconds, 15)
  }

  values = [
    yamlencode(local.triggers),
  ]
}