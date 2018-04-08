data "aws_caller_identity" "current" {}

# Account
provider "aws" {
  region = "${var.aws_region}"
}

# Region
variable "aws_region" {
  description = "The AWS region to run in."
  default     = "eu-central-1"
}

# VPC ID
variable "vpc_id" {
  description = "The VPC ID in which the resources should be created."
}

# Prefix
variable "prefix" {
  description = "A prefix which is added to each resource name."
  default     = ""
}

# Suffix
variable "suffix" {
  description = "A suffix which is added to each resource name."
  default     = ""
}
