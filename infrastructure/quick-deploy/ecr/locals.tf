# Current account
data "aws_caller_identity" "current" {}

locals {
  kms_name = (var.suffix != "" ? "ecr-kms-${var.suffix}" : "ecr-kms")
  tags     = merge(var.tags, {
    "application"        = "Demo Kubernetes Autoscaling"
    "deployment version" = var.suffix
    "created by"         = data.aws_caller_identity.current.arn
    "date"               = formatdate("EEE-DD-MMM-YY-hh:mm:ss:ZZZ", tostring(timestamp()))
  })
}