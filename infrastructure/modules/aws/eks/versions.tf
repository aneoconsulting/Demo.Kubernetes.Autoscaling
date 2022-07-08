terraform {
  required_providers {
    aws        = {
      source  = "hashicorp/aws"
      version = "~> 4.18.0"
    }
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