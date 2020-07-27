### HTTPS target group variables ###
variable "https_target_group_parameters" {
  #https://github.com/terraform-providers/terraform-provider-aws/pull/8268
  type    = list(any)
  default = null
  # default = [
  #   {
  #     target_group = "default-https"
  #     host_headers = ["default.com"]
  #     port         = 443
  #   }
  # ]
}

# HTTPS target group degregistration delay
variable "https_target_group_deregistration_delay" {
  description = "Deregistration delay for the https target group(s)"
  default     = 300 #Possible values in seconds: 0-3600
}

##HTTPS target group health checks
# HTTPS target group health check intveral
variable "https_health_check_interval" {
  description = "Set HTTPS health check interval"
  default     = 30 #min=5 max=300
}

# HTTPS target group health check path
variable "https_health_check_path" {
  description = "Set HTTPS health check path"
  default     = "/"
}

# HTTPS target group health check port
variable "https_health_check_port" {
  description = "Set HTTPS health check port"
  default     = "traffic-port"
}

# HTTPS target group health check protocol
variable "https_health_check_protocol" {
  description = "Set HTTPS health check protocol"
  default     = "HTTPS"
}

# HTTPS target group health check timeout
variable "https_health_check_timeout" {
  description = "Set HTTPS health check timeout"
  default     = 5 #min=2 max=60
}

# HTTPS target group health check healthy threshold
variable "https_health_check_healthy_threshold" {
  description = "Set HTTPS health check healthy threshold"
  default     = 3
}

# HTTPS target group health cehck unhealthy threshold
variable "https_health_check_unhealthy_threshold" {
  description = "Set HTTPS health check unhealthy threshold"
  default     = 3
}

# HTTPS target group health check  matcher
variable "https_health_check_matcher" {
  description = "Set HTTPS health check matcher"
  default     = 200 #Matcher aka success code. Range-example: 200-299
}

## HTTPS target group sticky cookie settings
# HTTPS target group stickiness enabled/disabled
variable "https_target_group_stickiness_enabled" {
  description = "Turn stickiness on/off for the https target group(s)"
  default     = false
}

# HTTPS cookie duration for stickiness if enabled
variable "https_target_group_stickiness_cookie_duration" {
  description = "Cookie Duration for stickiness of the https target group(s)"
  default     = 8640 #Possible values 1-604800 (604800 = 1 day).
}

