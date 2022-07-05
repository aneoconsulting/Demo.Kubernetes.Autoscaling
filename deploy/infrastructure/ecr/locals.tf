# Current account
data "aws_caller_identity" "current" {}

locals {
  # tags
  tags = merge({
    "application"        = "demo-kubernetes-autoscaling"
    "deployment version" = var.suffix
    "created by"         = data.aws_caller_identity.current.arn
    "date"               = formatdate("EEE-DD-MMM-YY-hh:mm:ss:ZZZ", tostring(timestamp()))
  }, var.tags)

  # KMS
  kms_name = "demo-ecr-${var.suffix}"
}
