terraform {
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.8.0"
    }
    helm       = {
      source  = "hashicorp/helm"
      version = "~> 2.4.1"
    }
  }
}