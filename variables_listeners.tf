# Load balancer listener variables
## HTTP
variable "create_lb_http_listener" {
  description = "If true add a HTTP listener"
  default     = false
}

## Load balancer HTTP listener port
variable "lb_http_listener_port" {
  description = "HTTP listener port of the loadbalancer"
  default     = 80
}

## load balancer http redirect listener
variable "create_lb_http_redirect_listener" {
  default = false
}

## Load balancer HTTP redirect listener port
variable "lb_http_redirect_listener_port" {
  description = "HTTP redirect listener port of the loadbalancer"
  default     = 80
}

## Load balancer HTTP redirect to protocol
variable "lb_http_redirect_to_protocol" {
  description = "HTTP redirect listener to loadbalancer protocol"
  default     = "HTTPS"
}

## Load balancer HTTP redirect to port
variable "lb_http_redirect_to_port" {
  description = "HTTP redirect listener to loadbalancer port"
  default     = 443
}

## HTTPS
variable "create_lb_https_listener" {
  description = "If true add a HTTPS listener"
  default     = false
}

## Load balancer HTTPS offloading?
variable "enable_lb_https_offloading" {
  description = "If true offload to HTTP"
  default     = true
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
