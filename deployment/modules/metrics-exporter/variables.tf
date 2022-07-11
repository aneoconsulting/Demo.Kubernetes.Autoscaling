# Global variables
variable "namespace" {
  description = "Namespace of Demo resources"
  type        = string
}

# Docker image
variable "docker_image" {
  description = "Docker image for Metrics exporter"
  type        = object({
    image              = string
    tag                = string
    image_pull_secrets = string
  })
}

# Node selector
variable "node_selector" {
  description = "Node selector for Metrics exporter"
  type        = any
}

# Type of service
variable "service_type" {
  description = "Service type which can be: ClusterIP, NodePort or LoadBalancer"
  type        = string
}

# Port of service
variable "port" {
  description = "Port of service"
  type        = number
}