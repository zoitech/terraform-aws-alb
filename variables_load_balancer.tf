## Load balancer variables
# Load balancer internal or external
variable "create_internal_lb" {
  description = "Define if the loadbalancer should be internal or not"
  default     = true
}

# Load balancer name
variable "lb_name" {
  description = "Name of the loadbalancer"
  default     = "loadbalancer"
}

# Load balancer subnet groups
variable "lb_subnet_ids" {
  type        = list(string)
  description = "The subnet ID(s) which should be attached to the loadbalancer"
  default     = []
}

## Load balancer security groups
variable "lb_security_group_ids" {
  type        = list(string)
  description = "Additional Security Group ID(s) which should be attached to the loadbalancer"
  default     = []
}

variable "lb_in_from_port" {
  description = "The from port to allow load balancer traffic in to the instance"
  default     = 80
}

variable "lb_in_to_port" {
  description = "The to port to allow load balancer traffic in to the instance"
  default     = 80
}

# Load balancer idle timeout
variable "lb_idle_timeout" {
  description = "Idle timeout for the loadbalancer."
  default     = 60
}

# Load balancer enable http2
variable "lb_enable_http2" {
  description = "Define is http2 is enabled"
  default     = true
}

# Load balancer deletion protection
variable "lb_enable_deletion_protection" {
  description = "Enable deletion protection"
  default     = false
}

