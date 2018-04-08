## Load balancer access logs
# Enable access logs
variable "enable_alb_access_logs" {
  description = "Turn alb access logs on or off."
  default     = false
}

# S3 bucket name for access logs
variable "s3_log_bucket_name" {
  description = "Name of the logs bucket."
  default     = ""
}

# S3 bucket key (folder)
variable "s3_log_bucket_Key_name" {
  description = "Name of the folder to store logs in the bucket."
  default     = ""
}

# Enable the lifecycle rule for the S3 bucket
variable "lifecycle_rule_enabled" {
  description = "To enable the lifecycle rule"
  default     = false
}

# Lifecycle rule for the S3 bucket
variable "lifecycle_rule_id" {
  description = "Name of the lifecyle rule id."
  default     = ""
}

# Prefix for S3 bucket lifecycle rule
variable "lifecycle_rule_prefix" {
  description = "Lifecycle rule prefix."
  default     = ""
}

# Delete access log files older than X days
variable "lifecycle_rule_expiration" {
  description = "Delete log files X days after creation"
  default     = 90
}

# The account ID for the principle within the bucket policy needs to match the region to allow the load balancer to write the logs to the bucket
variable "principle_account_id" {
  description = "Set principle account ID for the region"
  default     = "054676820928"
}
