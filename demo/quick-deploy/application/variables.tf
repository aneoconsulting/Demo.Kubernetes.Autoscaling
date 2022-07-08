# Profile
variable "profile" {
  description = "Profile of AWS credentials to deploy Terraform sources"
  type        = string
  default     = "default"
}

# Region
variable "region" {
  description = "AWS region where the infrastructure will be deployed"
  type        = string
  default     = "eu-west-3"
}

# Kubeconfig path
variable "k8s_config_path" {
  description = "Path of the configuration file of K8s"
  type        = string
  default     = "~/.kube/config"
}

# Kubeconfig context
variable "k8s_config_context" {
  description = "Context of K8s"
  type        = string
  default     = "default"
}

# EKS
variable "eks" {
  description = "EKS info"
  type        = any
}

# SQS
variable "sqs" {
  description = "SQS info"
  type        = any
}

# Metrics exporter
variable "metrics_exporter" {
  description = "Metrics exporter info"
  type        = any
}

# Kubernetes namespace
variable "namespace" {
  description = "Kubernetes namespace for Demo"
  type        = string
}

# application infos
variable "application" {
  description = "application info"
  type        = object({
    docker_image  = object({
      image              = string
      tag                = string
      image_pull_secrets = string
    })
    node_selector = any
    service_type  = string
    port          = number
    hpa           = any
  })
}