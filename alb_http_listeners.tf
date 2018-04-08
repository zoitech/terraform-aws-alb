# Create http listener for the loadbalancer if "var.lb_http_listener == true"
resource "aws_lb_listener" "application_loadbalancer_listener_http" {
  count = "${var.lb_http_listener}"
  load_balancer_arn = "${aws_lb.application_loadbalancer.arn}"
  port              = "${var.lb_http_listener_port}"
  protocol          = "HTTP"

  default_action {
    target_group_arn = "${aws_lb_target_group.tg_http.0.arn}"
    type             = "forward"
  }
}
# Create http listener rules
resource "aws_lb_listener_rule" "http_host_based_routing" {
  count = "${var.lb_http_listener ? "${length(var.http_host_headers) == "${length(var.http_target_group_names)}" ? "${length(var.http_host_headers)}" : 0}" :0}"

  listener_arn = "${aws_lb_listener.application_loadbalancer_listener_http.arn}"

  action {
    type             = "forward"
    target_group_arn = "${element(aws_lb_target_group.tg_http.*.arn, count.index)}"
  }

  condition {
    field  = "host-header"
    values = ["${element(var.http_host_headers, count.index)}"]
  }
}
