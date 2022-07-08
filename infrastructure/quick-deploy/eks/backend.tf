terraform {
  backend "local" {
    path = "./generated/eks-terraform.tfstate"
    workspace_dir = "demo"
  }
}