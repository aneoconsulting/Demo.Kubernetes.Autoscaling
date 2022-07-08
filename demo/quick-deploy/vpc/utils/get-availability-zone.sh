#! /bin/bash
# Exit if any of the intermediate steps fail
set -e

AVAILABILITY_ZONE=$(aws ec2 describe-subnets --region "$1" --filters "Name=vpc-id,Values=$2" "Name=subnet-id,Values=$3" --query "Subnets[*].AvailabilityZone" --output text)

jq -n --arg availability_zone "$AVAILABILITY_ZONE" '{"availability_zone":$availability_zone}'