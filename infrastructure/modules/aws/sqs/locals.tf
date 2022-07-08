locals {
  tags       = merge({ module = "sqs" }, var.tags)
}
