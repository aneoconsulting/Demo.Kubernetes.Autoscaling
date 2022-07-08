# Profile
profile = "default"

# Region
region = "eu-west-3"

# Kubeconfig path
k8s_config_path = "~/.kube/config"

# Kubeconfig context
k8s_config_context = "default"

# Kubernetes namespace
namespace = "demo"

# metrics exporter infos
metrics_exporter = {
  docker_image  = {
    image              = "125796369274.dkr.ecr.eu-west-3.amazonaws.com/demo-kas-scaler"
    tag                = "0.0.1-jgscaler.12.7fbe04f"
    image_pull_secrets = ""
  }
  node_selector = {}
  service_type  = "ClusterIP"
  port          = 1080
}
