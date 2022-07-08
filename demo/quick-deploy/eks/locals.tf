# Current account
data "aws_caller_identity" "current" {}

locals {
  cluster_name = (var.suffix != "" ? "${var.cluster_name}-${var.suffix}" : var.cluster_name)
  kms_name     = (var.suffix != "" ? "eks-kms-${var.suffix}" : "eks-kms")
  vpc          = {
    id                 = try(var.vpc.id, "")
    private_subnet_ids = try(var.vpc.private_subnet_ids, [])
    pods_subnet_ids    = try(var.vpc.pods_subnet_ids, [])
    availability_zones = try(var.vpc.availability_zones, [])
  }
  tags         = merge(var.tags, {
    "application"        = "Demo Kubernetes Autoscaling"
    "deployment version" = var.suffix
    "created by"         = data.aws_caller_identity.current.arn
    "date"               = formatdate("EEE-DD-MMM-YY-hh:mm:ss:ZZZ", tostring(timestamp()))
  })
}

# Empty Kubeconfig
resource "null_resource" "empty_kubeconfig" {
  provisioner "local-exec" {
    command = "mkdir -p ${pathexpand("~/.kube")}"
  }
  provisioner "local-exec" {
    command = "touch ${pathexpand("~/.kube/config")}"
  }
  provisioner "local-exec" {
    command = "sed -i 's/: null/: []/g' ${pathexpand("~/.kube/config")}"
  }
}