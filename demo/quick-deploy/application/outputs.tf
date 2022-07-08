output "application" {
  description = "Application URL"
  value       = {
    url  = module.application.url
    host = module.application.host
    port = module.application.port
    name = module.application.name
  }
}