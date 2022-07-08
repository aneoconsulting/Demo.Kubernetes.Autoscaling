# Current account
data "aws_caller_identity" "current" {}

# Current AWS region
data "aws_region" "current" {}

locals {
  cluster_name       = (var.suffix != "" ? "${var.cluster_name}-${var.suffix}" : var.cluster_name)
  kms_name           = (var.suffix != "" ? "vpc-kms-${var.suffix}" : "vpc-kms")
  vpc_name           = (var.suffix != "" ? "vpc-${var.suffix}" : "vpc")
  tags               = merge(var.tags, {
    "application"        = "Demo Kubernetes Autoscaling"
    "deployment version" = var.suffix
    "created by"         = data.aws_caller_identity.current.arn
    "date"               = formatdate("EEE-DD-MMM-YY-hh:mm:ss:ZZZ", tostring(timestamp()))
  })
  availability_zones = [
  for idx in range(0, length(module.vpc.pods_subnet_ids)) :
  {
    availability_zone = try(tomap(data.external.availability_zone[idx].result).availability_zone, "")
    subnet_id         = module.vpc.pods_subnet_ids[idx]
  }
  ]
}