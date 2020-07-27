# Create http listener for the loadbalancer if "var.lb_http_listener == true"
resource "aws_lb_listener" "application_loadbalancer_listener_http" {
  count             = local.create_lb_http_listener
  load_balancer_arn = aws_lb.application_loadbalancer.arn
  port              = var.lb_http_listener_port
  protocol          = "HTTP"

  default_action {
    target_group_arn = aws_lb_target_group.tg_http[0].arn
    type             = "forward"
  }
}

# Create http listener rules
resource "aws_lb_listener_rule" "http_host_based_routing" {
  count        = local.create_lb_http_listener_rules
  listener_arn = aws_lb_listener.application_loadbalancer_listener_http[0].arn

  action {
    type             = "forward"
    target_group_arn = element(aws_lb_target_group.tg_http.*.arn, count.index)
  }

  condition {
    host_header {
      values = lookup(element(var.http_target_group_parameters, count.index), "host_headers")
    }
  }

  lifecycle {
    create_before_destroy = true
  }
}

# Create http redirect listener for the loadbalancer if "var.lb_http_redirect_listener == true"
resource "aws_lb_listener" "application_loadbalancer_listener_http_redirect" {
  count             = local.create_lb_http_redirect_listener
  load_balancer_arn = aws_lb.application_loadbalancer.arn
  port              = var.lb_http_redirect_listener_port
  protocol          = "HTTP"

  default_action {
    type = "redirect"

    redirect {
      port        = var.lb_http_redirect_to_port
      protocol    = var.lb_http_redirect_to_protocol
      status_code = "HTTP_301"
    }
  }
}

# Redirect http 
# resource "aws_lb_listener_rule" "redirect_http" {
#   count        = local.create_lb_http_redirect_listener_rules
#   listener_arn = aws_lb_listener.application_loadbalancer_listener_http_redirect[0].arn

#   action {
#     type = "redirect"

#     redirect {
#       port        = "443"
#       protocol    = "HTTPS"
#       status_code = "HTTP_301"
#     }
#   }

#   condition {
#     host_header {
#       values = ["*.*"]
#     }
#   }
# }
