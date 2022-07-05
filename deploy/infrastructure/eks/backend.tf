terraform {
  backend "s3" {
    encrypt              = true
    region               = var.region
    profile              = var.profile
    key                  = "eks-terraform.tfstate"
    force_path_style     = true
    workspace_key_prefix = "demo"
  }
}