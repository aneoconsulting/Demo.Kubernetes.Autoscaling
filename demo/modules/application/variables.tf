# Global variables
variable "namespace" {
  description = "Namespace of Demo resources"
  type        = string
}

# Docker image
variable "docker_image" {
  description = "Docker image for application"
  type        = object({
    image              = string
    tag                = string
    image_pull_secrets = string
  })
}

# Node selector
variable "node_selector" {
  description = "Node selector for application"
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

# HPA
variable "hpa" {
  description = "HPA info"
  type        = any
}

# Metrics exporter url
variable "metrics_exporter_url" {
  description = "Metrics exporter url"
  type        = string
}

# SQS name
variable "sqs_name" {
  description = "SQS name"
  type        = string
}

# Region
variable "region" {
  description = "AWS region where the infrastructure will be deployed"
  type        = string
}