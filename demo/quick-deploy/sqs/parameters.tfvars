# Profile
profile = "default"

# Region
region = "eu-west-3"

# SUFFIX
suffix = "demo"

# Tags
tags = {}

# Name of SQS queue
sqs = {
  name                       = "sqs"
  visibility_timeout_seconds = 30 # 30s
  message_retention_seconds  = 345600 # 4 days
}
