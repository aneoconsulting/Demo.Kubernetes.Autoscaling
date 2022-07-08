terraform {
  backend "local" {
    path = "./generated/keda-terraform.tfstate"
    workspace_dir = "demo"
  }
}