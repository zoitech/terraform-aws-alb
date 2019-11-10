#### Create http target group(s) ####
resource "aws_lb_target_group" "tg_http" {
  # Check the number of http target group names matches the number of http target group ports.
  # If check is ok creates the number of http target group resources based on the number of http target group names
  count = var.lb_http_listener ? length(var.http_target_group_names) == length(var.http_target_group_ports) ? length(var.http_target_group_names) : 0 : 0

  ### Required Arguments ###
  name     = "${var.prefix}${element(var.http_target_group_names, count.index)}${var.suffix}" # default prefix/suffix = "". Default target group name = ["http-target-group"] N.B. 32 Character limit with prefix/suffix
  port     = element(var.http_target_group_ports, count.index)                                # default = [80]
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  health_check {
    interval            = var.http_health_check_interval #default = 30
    path                = var.http_health_check_path     #default = "/"
    port                = var.http_health_check_port     #default = "traffic-port"
    protocol            = "HTTP"
    timeout             = var.http_health_check_timeout             #default = 5
    healthy_threshold   = var.http_health_check_healthy_threshold   #default = 3
    unhealthy_threshold = var.http_health_check_unhealthy_threshold #default = 3
    matcher             = var.http_health_check_matcher             #default = 200
  }

  target_type = "instance"

  ### Optional Arguments ###
  deregistration_delay = var.http_target_group_deregistration_delay # default = 300.

  stickiness {
    enabled         = var.http_target_group_stickiness_enabled         # default set to false
    type            = "lb_cookie"                                      # default = lb_cookie. Only possible value for applicatoin load balancer
    cookie_duration = var.http_target_group_stickiness_cookie_duration # default 8640 seconds (1 day).
  }
  #tags = https://github.com/hashicorp/terraform/issues/15226
}

# Attach up to 8 targets to http target group(s)
# aws_alb_target_group_attachment errors out when multiple instance id's used
# Workaround until https://github.com/terraform-providers/terraform-provider-aws/issues/647 is solved
resource "aws_lb_target_group_attachment" "attach_http_tg_target1" {
  count            = local.http_target_id_1
  target_group_arn = element(aws_lb_target_group.tg_http.*.arn, count.index)
  target_id        = element(split(",", var.target_ids), 0)
  port             = element(var.http_target_group_ports, count.index)
}

resource "aws_lb_target_group_attachment" "attach_http_tg_target2" {
  count            = local.http_target_id_2
  target_group_arn = element(aws_lb_target_group.tg_http.*.arn, count.index)
  target_id        = element(split(",", var.target_ids), 1)
  port             = element(var.http_target_group_ports, count.index)
}

resource "aws_lb_target_group_attachment" "attach_http_tg_target3" {
  count            = local.http_target_id_3
  target_group_arn = element(aws_lb_target_group.tg_http.*.arn, count.index)
  target_id        = element(split(",", var.target_ids), 2)
  port             = element(var.http_target_group_ports, count.index)
}

resource "aws_lb_target_group_attachment" "attach_http_tg_target4" {
  count            = local.http_target_id_4
  target_group_arn = element(aws_lb_target_group.tg_http.*.arn, count.index)
  target_id        = element(split(",", var.target_ids), 3)
  port             = element(var.http_target_group_ports, count.index)
}

resource "aws_lb_target_group_attachment" "attach_http_tg_target5" {
  count            = local.http_target_id_5
  target_group_arn = element(aws_lb_target_group.tg_http.*.arn, count.index)
  target_id        = element(split(",", var.target_ids), 4)
  port             = element(var.http_target_group_ports, count.index)
}

resource "aws_lb_target_group_attachment" "attach_http_tg_target6" {
  count            = local.http_target_id_6
  target_group_arn = element(aws_lb_target_group.tg_http.*.arn, count.index)
  target_id        = element(split(",", var.target_ids), 5)
  port             = element(var.http_target_group_ports, count.index)
}

resource "aws_lb_target_group_attachment" "attach_http_tg_target7" {
  count            = local.http_target_id_7
  target_group_arn = element(aws_lb_target_group.tg_http.*.arn, count.index)
  target_id        = element(split(",", var.target_ids), 6)
  port             = element(var.http_target_group_ports, count.index)
}

resource "aws_lb_target_group_attachment" "attach_http_tg_target8" {
  count            = local.http_target_id_8
  target_group_arn = element(aws_lb_target_group.tg_http.*.arn, count.index)
  target_id        = element(split(",", var.target_ids), 7)
  port             = element(var.http_target_group_ports, count.index)
}

