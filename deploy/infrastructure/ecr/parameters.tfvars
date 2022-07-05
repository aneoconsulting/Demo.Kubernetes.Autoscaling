# Profile
profile = "default"

# Region
region = "us-east-1"

# SUFFIX
suffix = "demo"

# tags
tags = {}

# List of ECR repositories to create
ecr = [
  {
    name  = "demo-kas-scaler"
    image = "dockerhubaneo/demo_kas_scaler"
    tag   = "0.0.1-jgscaler.12.7fbe04f"
  },
  {
    name  = "demo-kas-client"
    image = "dockerhubaneo/demo_kas_client"
    tag   = "0.0.1-jgscaler.12.7fbe04f"
  }
]