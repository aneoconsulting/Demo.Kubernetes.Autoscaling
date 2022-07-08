provider "kubernetes" {
  host                   = local.eks.cluster_endpoint
  cluster_ca_certificate = base64decode(local.eks.certificate_authority.0.data)
  token                  = local.eks.token
  #config_path            = pathexpand("~/.kube/config")
  insecure               = false
}

# package manager for kubernetes
provider "helm" {
  helm_driver = "configmap"
  kubernetes {
    host                   = local.eks.cluster_endpoint
    cluster_ca_certificate = base64decode(local.eks.certificate_authority.0.data)
    token                  = local.eks.token
    #config_path            = pathexpand("~/.kube/config")
    insecure               = false
  }
}