# Create https listener for the loadbalancer if "var.create_lb_https_listener == true" and "var.enable_lb_https_offloading == false"
resource "aws_lb_listener" "application_loadbalancer_listener_https" {
  count             = local.create_lb_https_listener
  load_balancer_arn = aws_lb.application_loadbalancer.arn
  port              = var.lb_https_listener_port
  protocol          = "HTTPS"

  default_action {
    target_group_arn = (var.enable_lb_https_offloading == true ? aws_lb_target_group.tg_http[0].arn : aws_lb_target_group.tg_https[0].arn)
    type             = "forward"
  }

  certificate_arn = var.certificate_arn
}

# Create https listener rules
resource "aws_lb_listener_rule" "https_host_based_routing" {
  count        = local.create_lb_https_listener_rules
  listener_arn = aws_lb_listener.application_loadbalancer_listener_https[0].arn

  action {
    type             = "forward"
    target_group_arn = (var.enable_lb_https_offloading == true ? element(aws_lb_target_group.tg_http.*.arn, count.index) : element(aws_lb_target_group.tg_https.*.arn, count.index))
  }

  condition {
    host_header {
      values = (var.enable_lb_https_offloading == true ? lookup(element(var.http_target_group_parameters, count.index), "host_headers") : lookup(element(var.https_target_group_parameters, count.index), "host_headers"))
    }
  }
}
