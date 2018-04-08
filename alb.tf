resource "aws_lb" "application_loadbalancer" {
  ### Required Arguments ###
  name               = "${var.prefix}${var.lb_name}${var.suffix}"
  internal           = "${var.lb_internal}"
  load_balancer_type = "application"
  security_groups    = ["${local.lb_security_groups}"]
  subnets            = ["${local.lb_subnet_ids}"]

  ### Optional Arguments ###
  idle_timeout               = "${var.lb_idle_timeout}"
  enable_http2               = "${var.lb_enable_http2}"
  enable_deletion_protection = "${var.lb_enable_deletion_protection}"

  access_logs {
    bucket  = "${var.s3_log_bucket_name}"
    prefix  = "${var.s3_log_bucket_Key_name}"
    enabled = "${var.enable_alb_access_logs}" #default = false
  }
}
