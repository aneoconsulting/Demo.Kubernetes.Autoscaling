terraform {
  backend "local" {
    path = "./generated/sqs-terraform.tfstate"
    workspace_dir = "demo"
  }
}