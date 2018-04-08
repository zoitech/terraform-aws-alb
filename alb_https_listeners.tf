# Create https listener for the loadbalancer if "var.lb_https_listener == true"
resource "aws_lb_listener" "application_loadbalancer_listener_https" {
  count = "${var.lb_https_listener}"
  load_balancer_arn = "${aws_lb.application_loadbalancer.arn}"
  port              = "${var.lb_https_listener_port}"
  protocol          = "HTTPS"

  default_action {
    target_group_arn = "${aws_lb_target_group.tg_https.0.arn}"
    type             = "forward"
  }
  certificate_arn = "${var.certificate_arn}"
}
# Create https listener rules
resource "aws_lb_listener_rule" "https_host_based_routing" {
  count = "${var.lb_https_listener ? "${length(var.https_host_headers) == "${length(var.https_target_group_names)}" ? "${length(var.https_host_headers)}" : 0}" :0}"

  listener_arn = "${aws_lb_listener.application_loadbalancer_listener_https.arn}"

  action {
    type             = "forward"
    target_group_arn = "${element(aws_lb_target_group.tg_https.*.arn, count.index)}"
  }

  condition {
    field  = "host-header"
    values = ["${element(var.https_host_headers, count.index)}"]
  }
}
