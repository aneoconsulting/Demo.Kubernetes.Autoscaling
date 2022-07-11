# Profile
profile = "default"

# Region
region = "eu-west-3"

# SUFFIX
suffix = "demo"

# Tags
tags = {}

# List of ECR repositories to create
ecr = [
  {
    name  = "cluster-autoscaler"
    image = "k8s.gcr.io/autoscaling/cluster-autoscaler"
    tag   = "v1.23.0"
  },
  {
    name  = "aws-node-termination-handler"
    image = "public.ecr.aws/aws-ec2/aws-node-termination-handler"
    tag   = "v1.15.0"
  },
  {
    name  = "keda"
    image = "ghcr.io/kedacore/keda"
    tag   = "2.7.1"
  },
  {
    name  = "keda-metrics-apiserver"
    image = "ghcr.io/kedacore/keda-metrics-apiserver"
    tag   = "2.7.1"
  },
  {
    name  = "demo-kas-scaler"
    image = "dockerhubaneo/demo_kas_scaler"
    tag   = "0.0.1-jgscaler.12.7fbe04f"
  },
  {
    name  = "demo-kas-client"
    image = "dockerhubaneo/demo_kas_client"
    tag   = "0.0.1-jgscaler.12.7fbe04f"
  },
  {
    name  = "application"
    image = "k8s.gcr.io/hpa-example"
    tag   = "latest"
  },
]
