## Load balancer variables
# Load balancer internal or external
variable "lb_internal" {
  description = "Define if the loadbalancer should be internal or not"
  default     = true
}

# Load balancer name
variable "lb_name" {
  description = "Name of the loadbalancer"
  default     = "loadbalancer"
}

# Load balancer public subnet groups
variable "lb_public_subnet_ids" {
  type        = list(string)
  description = "The Public Subnet ID(s) which should be attached to the loadbalancer"
  default     = []
}

# Load balancer private subnet groups
variable "lb_private_subnet_ids" {
  type        = list(string)
  description = "The Private Subnet ID(s) which should be attached to the loadbalancer"
  default     = []
}

## Load balancer security groups
# Load balancer additional security groups
variable "lb_security_group_ids" {
  type        = list(string)
  description = "Additional Security Group ID(s) which should be attached to the loadbalancer"
  default     = []
}

# Loadbalancer source traffic name (for security group allowing listener traffic in)
variable "lb_source_traffic_name" {
  description = "Name of source traffic for the loadbalancer within the HTTP and HTTPS security group. E.g. Rule-allow-public-in-HTTP"
  default     = ""
}

# Loadbalancer HTTP security group name
variable "lb_sg_http_name" {
  description = "Name of the HTTP security group"
  default     = ""
}

# Loadbalancer HTTPS security group name
variable "lb_sg_https_name" {
  description = "Name of the HTTP security group"
  default     = ""
}

# CIDR blocks specifying IP(s) allowed in on the http listener port for the loadbalancer
variable "rule_allow_lb_http_listener_traffic_in_cidr_blocks" {
  type        = list(string)
  description = "CIDR blocks loadbalancer http listener source traffic"
  default     = ["0.0.0.0/0"]
}

# CIDR blocks specifying IP(s) allowed in on the https listener port for the loadbalancer
variable "rule_allow_lb_https_listener_traffic_in_cidr_blocks" {
  type        = list(string)
  description = "CIDR blocks loadbalancer https listener source traffic"
  default     = ["0.0.0.0/0"]
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

