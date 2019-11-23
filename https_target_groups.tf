#### Create https target group(s) ####
resource "aws_lb_target_group" "tg_https" {
  count = local.create_tg_https

  ### Required Arguments ###
  name     = "${var.prefix}${lookup(element(var.https_target_group_parameters, count.index), "target_group")}"
  port     = lookup(element(var.https_target_group_parameters, count.index), "port")
  protocol = "HTTPS"
  vpc_id   = var.vpc_id

  health_check {
    interval            = var.https_health_check_interval #default = 30
    path                = var.https_health_check_path     #default = "/"
    port                = var.https_health_check_port     #default = "traffic-port"
    protocol            = "HTTPS"
    timeout             = var.https_health_check_timeout             #default = 5
    healthy_threshold   = var.https_health_check_healthy_threshold   #default = 3
    unhealthy_threshold = var.https_health_check_unhealthy_threshold #default = 3
    matcher             = var.https_health_check_matcher             #default = 200
  }

  target_type = "instance"

  ### Optional Arguments ###
  deregistration_delay = var.https_target_group_deregistration_delay # default = 300.

  stickiness {
    enabled         = var.https_target_group_stickiness_enabled         # default set to false
    type            = "lb_cookie"                                       # default = lb_cookie. Only possible value for applicatoin load balancer
    cookie_duration = var.https_target_group_stickiness_cookie_duration # default 8640 seconds (1 day).
  }
  tags = var.tg_tags
}

# Attach up to 8 targets to https target group(s)
# aws_alb_target_group_attachment errors out when multiple instance id's used
# Workaround until https://github.com/terraform-providers/terraform-provider-aws/issues/647 is solved
resource "aws_lb_target_group_attachment" "attach_https_tg_target1" {
  count            = local.https_target_id_1
  target_group_arn = element(aws_lb_target_group.tg_https.*.arn, count.index)
  target_id        = element(split(",", var.target_ids), 0)
  port             = lookup(element(var.http_target_group_parameters, count.index), "port")
}

resource "aws_lb_target_group_attachment" "attach_https_tg_target2" {
  count            = local.https_target_id_2
  target_group_arn = element(aws_lb_target_group.tg_https.*.arn, count.index)
  target_id        = element(split(",", var.target_ids), 1)
  port             = lookup(element(var.http_target_group_parameters, count.index), "port")
}

resource "aws_lb_target_group_attachment" "attach_https_tg_target3" {
  count            = local.https_target_id_3
  target_group_arn = element(aws_lb_target_group.tg_https.*.arn, count.index)
  target_id        = element(split(",", var.target_ids), 2)
  port             = lookup(element(var.http_target_group_parameters, count.index), "port")
}

resource "aws_lb_target_group_attachment" "attach_https_tg_target4" {
  count            = local.https_target_id_4
  target_group_arn = element(aws_lb_target_group.tg_https.*.arn, count.index)
  target_id        = element(split(",", var.target_ids), 3)
  port             = lookup(element(var.http_target_group_parameters, count.index), "port")
}

resource "aws_lb_target_group_attachment" "attach_https_tg_target5" {
  count            = local.https_target_id_5
  target_group_arn = element(aws_lb_target_group.tg_https.*.arn, count.index)
  target_id        = element(split(",", var.target_ids), 4)
  port             = lookup(element(var.http_target_group_parameters, count.index), "port")
}

resource "aws_lb_target_group_attachment" "attach_https_tg_target6" {
  count            = local.https_target_id_6
  target_group_arn = element(aws_lb_target_group.tg_https.*.arn, count.index)
  target_id        = element(split(",", var.target_ids), 5)
  port             = lookup(element(var.http_target_group_parameters, count.index), "port")
}

resource "aws_lb_target_group_attachment" "attach_https_tg_target7" {
  count            = local.https_target_id_7
  target_group_arn = element(aws_lb_target_group.tg_https.*.arn, count.index)
  target_id        = element(split(",", var.target_ids), 6)
  port             = lookup(element(var.http_target_group_parameters, count.index), "port")
}

resource "aws_lb_target_group_attachment" "attach_https_tg_target8" {
  count            = local.https_target_id_8
  target_group_arn = element(aws_lb_target_group.tg_https.*.arn, count.index)
  target_id        = element(split(",", var.target_ids), 7)
  port             = lookup(element(var.http_target_group_parameters, count.index), "port")
}

