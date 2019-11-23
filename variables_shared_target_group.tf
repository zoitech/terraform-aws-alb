# HTTP/HTTPS target group IDs
variable "target_ids" {
  description = "Instance IDs for the target group(s)"
  default     = ""
}

variable "tg_tags" {
  description = "Tags for target groups"
  type        = map()
}
