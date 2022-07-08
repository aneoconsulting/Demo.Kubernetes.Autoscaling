terraform {
  backend "local" {
    path = "./generated/vpc-terraform.tfstate"
    workspace_dir = "demo"
  }
}