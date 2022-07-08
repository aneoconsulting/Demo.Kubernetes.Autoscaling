# Current account
data "aws_caller_identity" "current" {}

locals {
  kms_name = (var.suffix != "" ? "sqs-kms-${var.suffix}" : "sqs-kms")
  sqs      = {
    name                       = (var.suffix != "" ? "${try(var.sqs.name, "sqs")}-${var.suffix}" : "sqs")
    visibility_timeout_seconds = tonumber(try(var.sqs.visibility_timeout_seconds, 30))
    message_retention_seconds  = tonumber(try(var.sqs.message_retention_seconds, 345600))
  }
  tags     = merge(var.tags, {
    "application"        = "Demo Kubernetes Autoscaling"
    "deployment version" = var.suffix
    "created by"         = data.aws_caller_identity.current.arn
    "date"               = formatdate("EEE-DD-MMM-YY-hh:mm:ss:ZZZ", tostring(timestamp()))
  })
}