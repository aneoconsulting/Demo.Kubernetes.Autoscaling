# EKS
variable "eks" {
  description = "EKS info"
  type        = any
}

# Kubernetes namespace
variable "namespace" {
  description = "Kubernetes namespace for Keda"
  type        = string
}

# Keda infos
variable "keda" {
  description = "Keda infos"
  type        = object({
    docker_image  = object({
      keda             = object({
        image = string
        tag   = string
      })
      metricsApiServer = object({
        image = string
        tag   = string
      })
    })
    node_selector = any
  })
}