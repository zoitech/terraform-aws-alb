# Load balancer listener variables
## Load balancer HTTP listener needed?
variable "create_lb_http_listener" {
  description = "If true add a HTTP listener"
  default     = false
}

## Load balancer HTTPS listener needed?
variable "lb_https_listener" {
  description = "If true add a HTTPS listener"
  default     = false
}

## Load balancer HTTPS offloading?
variable "lb_https_offloading" {
  description = "If true offload to HTTP"
  default     = true
}

## Load balancer HTTP listener port
variable "lb_http_listener_port" {
  description = "HTTP listener port of the loadbalancer"
  default     = 80
}

## Loadbalancer HTTPS listener port
variable "lb_https_listener_port" {
  description = "HTTPS listener port of the loadbalancer"
  default     = 443
}

## Certificate ARN for the HTTPS listener
variable "certificate_arn" {
  description = "Certificate ARN for the HTTPS listener"
  default     = null
}
