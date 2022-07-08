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

# Application infos
application = {
  docker_image  = {
    image              = "125796369274.dkr.ecr.eu-west-3.amazonaws.com/application"
    tag                = "latest"
    image_pull_secrets = ""
  }
  node_selector = {}
  service_type  = "LoadBalancer"
  port          = 80
  hpa           = {
    polling_interval  = 15
    cooldown_period   = 300
    min_replica_count = 1
    max_replica_count = 10
    behavior          = {
      restore_to_original_replica_count = true
      stabilization_window_seconds      = 300
      type                              = "Percent"
      value                             = 100
      period_seconds                    = 15
    }
    triggers          = [
      {
        type          = "external"
        message_count = "2"
      },
    ]
  }
}
