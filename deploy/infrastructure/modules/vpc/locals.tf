locals {
  tags = merge({ module = "vpc" }, var.tags)
}
