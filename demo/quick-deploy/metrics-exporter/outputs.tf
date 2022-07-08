output "metrics_exporter" {
  description = "Metrics exporter URL"
  value       = {
    url  = module.metrics_exporter.url
    host = module.metrics_exporter.host
    port = module.metrics_exporter.port
    name = module.metrics_exporter.name
  }
}