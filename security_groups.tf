# Security group "group" for loadbalancer with no rules. To be used in other security group rules to specify the loadblaancer as the source.
resource "aws_security_group" "lb_group" {
  name        = "Group-ALB-${var.lb_name}"
  description = "Attach security group with loadbalancer name to loadbalancer with no rules"
  vpc_id      = "${var.vpc_id}"
}

# Security group which allows all outbound traffic
resource "aws_security_group" "rule_all_out" {
  name        = "Rule-all-out-all"
  description = "Allow all outgoing traffic"
  vpc_id      = "${var.vpc_id}"
}

resource "aws_security_group_rule" "rule_all_out" {
  type        = "egress"
  from_port   = 0
  to_port     = 0
  protocol    = -1
  cidr_blocks = ["0.0.0.0/0"]

  security_group_id = "${aws_security_group.rule_all_out.id}"
}

# Security group to allow traffic in on the http listener port
resource "aws_security_group" "lb_http_listener_traffic_in" {
  name        = "${var.lb_sg_http_name != "" ? "${var.lb_sg_http_name}" : "Rule-allow-${var.lb_source_traffic_name}-in-HTTP"}"
  description = "Allow traffic in from ${var.lb_source_traffic_name} on HTTP"
  vpc_id      = "${var.vpc_id}"
}

resource "aws_security_group_rule" "rule_allow_lb_http_listener_traffic_in" {
  type        = "ingress"
  from_port   = "${var.lb_http_listener_port}"
  to_port     = "${var.lb_http_listener_port}"
  protocol    = "tcp"
  cidr_blocks = ["${var.rule_allow_lb_http_listener_traffic_in_cidr_blocks}"]

  security_group_id = "${aws_security_group.lb_http_listener_traffic_in.id}"
}

# Security group to allow traffic in on the https listener port
resource "aws_security_group" "lb_https_listener_traffic_in" {
  name        = "${var.lb_sg_https_name != "" ? "${var.lb_sg_https_name}" : "Rule-allow-${var.lb_source_traffic_name}-in-HTTPS"}"
  description = "Allow traffic in from ${var.lb_source_traffic_name} on HTTPS"
  vpc_id      = "${var.vpc_id}"
}

resource "aws_security_group_rule" "rule_allow_lb_https_listener_traffic_in" {
  type        = "ingress"
  from_port   = "${var.lb_https_listener_port}"
  to_port     = "${var.lb_https_listener_port}"
  protocol    = "tcp"
  cidr_blocks = ["${var.rule_allow_lb_https_listener_traffic_in_cidr_blocks}"]

  security_group_id = "${aws_security_group.lb_https_listener_traffic_in.id}"
}
