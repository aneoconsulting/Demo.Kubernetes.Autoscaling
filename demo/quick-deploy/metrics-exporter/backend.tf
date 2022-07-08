terraform {
  backend "local" {
    path = "./generated/metrics-exporter-terraform.tfstate"
    workspace_dir = "demo"
  }
}