terraform {
  backend "local" {
    path = "./generated/ecr-terraform.tfstate"
    workspace_dir = "demo"
  }
}