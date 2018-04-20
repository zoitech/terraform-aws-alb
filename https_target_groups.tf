#### Create https target group(s) ####
resource "aws_lb_target_group" "tg_https" {
  # Check the number of https target group names matches the number of https target group ports.
  # If check is ok creates the number of https target group resources based on the number of https target group names
  count = "${var.lb_https_listener ? "${!var.lb_https_offloading ? "${length(var.https_target_group_names) == "${length(var.https_target_group_ports)}" ? "${length(var.https_target_group_names)}" : 0}" :0}" :0}"

  ### Required Arguments ###
  name     = "${var.prefix}${element(var.https_target_group_names, count.index)}${var.suffix}" # default prefix/suffix = "". Default target group name = ["https-target-group"] N.B. 32 Character limit with prefix/suffix
  port     = "${element(var.https_target_group_ports, count.index)}"                           # default = [443]
  protocol = "HTTPS"
  vpc_id   = "${var.vpc_id}"

  health_check {
    interval            = "${var.https_health_check_interval}"            #default = 30
    path                = "${var.https_health_check_path}"                #default = "/"
    port                = "${var.https_health_check_port}"                #default = "traffic-port"
    protocol            = "HTTPS"
    timeout             = "${var.https_health_check_timeout}"             #default = 5
    healthy_threshold   = "${var.https_health_check_healthy_threshold}"   #default = 3
    unhealthy_threshold = "${var.https_health_check_unhealthy_threshold}" #default = 3
    matcher             = "${var.https_health_check_matcher}"             #default = 200
  }

  target_type = "instance"

  ### Optional Arguments ###
  deregistration_delay = "${var.https_target_group_deregistration_delay}" # default = 300.

  stickiness {
    enabled         = "${var.https_target_group_stickiness_enabled}"         # default set to false
    type            = "lb_cookie"                                            # default = lb_cookie. Only possible value for applicatoin load balancer
    cookie_duration = "${var.https_target_group_stickiness_cookie_duration}" # default 8640 seconds (1 day).
  }
}

# Attach target to https target group(s)
resource "aws_lb_target_group_attachment" "attach_https_tg" {
  count = "${var.lb_https_listener ? "${!var.lb_https_offloading ? "${length(var.https_target_group_names) == "${length(var.https_target_group_ports)}" ? "${length(var.https_target_group_names)}" : 0}" :0}" :0}"

  target_group_arn = "${element(aws_lb_target_group.tg_https.*.arn, count.index)}"
  target_id        = "${var.target_id}"
  port             = "${element(var.https_target_group_ports, count.index)}"
}
