### HTTP target group variables ###
# HTTP target group names
variable "http_target_group_names" {
  type        = "list"
  description = "Name(s) of the http target group(s)"
  default     = ["http-target-group"]                 #N.B. Target Group name acceptable characters: letters, digits or the dash
}

# HTTP target group ports
variable "http_target_group_ports" {
  type        = "list"
  description = "Port(s) of the http target group(s)"
  default     = [80]
}

# HTTP target group degregistration delay
variable "http_target_group_deregistration_delay" {
  description = "Deregistration delay for the http target group(s)"
  default     = 300                                                 #Possible values in seconds: 0-3600
}

##HTTP target group health checks
# HTTP target group health check intveral
variable "http_health_check_interval" {
  description = "Set HTTP health check interval"
  default     = 30                               #min=5 max=300
}

# HTTP target group health check path
variable "http_health_check_path" {
  description = "Set HTTP health check path"
  default     = "/"
}

# HTTP target group health check port
variable "http_health_check_port" {
  description = "Set HTTP health check port"
  default     = "traffic-port"
}

# HTTP target group health check protocol
variable "http_health_check_protocol" {
  description = "Set HTTP health check protocol"
  default     = "HTTP"
}

# HTTP target group health check timeout
variable "http_health_check_timeout" {
  description = "Set HTTP health check timeout"
  default     = 5                               #min=2 max=60
}

# HTTP target group health check healthy threshold
variable "http_health_check_healthy_threshold" {
  description = "Set HTTP health check healthy threshold"
  default     = 3
}

# HTTP target group health cehck unhealthy threshold
variable "http_health_check_unhealthy_threshold" {
  description = "Set HTTP health check unhealthy threshold"
  default     = 3
}

# HTTP target group health check  matcher
variable "http_health_check_matcher" {
  description = "Set HTTP health check matcher"
  default     = 200                             #Matcher aka success code. Range-example: 200-299
}

## HTTP target group sticky cookie settings
# HTTP target group stickiness enabled/disabled
variable "http_target_group_stickiness_enabled" {
  description = "Turn stickiness on/off for the http target group(s)"
  default     = false
}

# HTTP cookie duration for stickiness if enabled
variable "http_target_group_stickiness_cookie_duration" {
  description = "Cookie Duration for stickiness of the http target group(s)"
  default     = 8640                                                         #Possible values 1-604800 (604800 = 1 day).
}
