# Profile
profile = "default"

# Region
region = "eu-west-3"

# Kubeconfig path
k8s_config_path = "~/.kube/config"

# Kubeconfig context
k8s_config_context = "default"

# Kubernetes namespace
namespace = "default"

# Keda infos
keda = {
  docker_image       = {
    keda             = {
      image = "125796369274.dkr.ecr.eu-west-3.amazonaws.com/keda"
      tag   = "2.7.1"
    }
    metricsApiServer = {
      image = "125796369274.dkr.ecr.eu-west-3.amazonaws.com/keda-metrics-apiserver"
      tag   = "2.7.1"
    }
  }
  image_pull_secrets = ""
  node_selector      = { "grid/type" = "Operator" }
}
