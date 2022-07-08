# Application
output "url" {
  description = "URL of application"
  value       = local.url
}

output "port" {
  description = "Port of application"
  value       = local.port
}

output "host" {
  description = "Host of application"
  value       = local.host
}

output "name" {
  description = "Name of application"
  value       = kubernetes_service.application.metadata.0.name
}

output "namespace" {
  description = "Namespace of application"
  value       = var.namespace
}