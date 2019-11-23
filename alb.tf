resource "aws_lb" "application_loadbalancer" {
  ### Required Arguments ###
  name               = "${var.prefix}${var.lb_name}${var.suffix}"
  internal           = local.create_internal_lb
  load_balancer_type = "application"
  security_groups    = local.lb_security_groups
  subnets            = var.lb_subnet_ids

  ### Optional Arguments ###
  idle_timeout               = var.lb_idle_timeout
  enable_http2               = var.lb_enable_http2
  enable_deletion_protection = var.lb_enable_deletion_protection
}

