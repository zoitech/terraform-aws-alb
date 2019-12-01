# Security group "group" for loadbalancer with no rules. 
#To be used in other security group rules to specify the loadblaancer as the source.
resource "aws_security_group" "lb_group" {
  name        = "Group-ALB-${var.lb_name}"
  description = "Attach security group with loadbalancer name to loadbalancer with no rules"
  vpc_id      = var.vpc_id
}

#http
resource "aws_security_group" "group_loadbalancer_in_http" {
  count       = local.create_sg_http_in
  name        = "tf-rule-alb-${var.prefix}${var.lb_name}-in-${lookup(element(var.http_target_group_parameters, 0), "port")}-${lookup(element(var.http_target_group_parameters, length(var.http_target_group_parameters)), "port")}"
  description = "Allow the load balancer in on ports ${lookup(element(var.http_target_group_parameters, 0), "port")}-${lookup(element(var.http_target_group_parameters, length(var.http_target_group_parameters)), "port")}"
  vpc_id      = var.vpc_id
}

resource "aws_security_group_rule" "rule_loadbalancer_in_http" {
  count                    = local.create_sg_http_in
  description              = "Allow the load balancer in on ports ${lookup(element(var.http_target_group_parameters, 0), "port")}-${length(var.http_target_group_parameters)}"
  type                     = "ingress"
  from_port                = lookup(element(var.http_target_group_parameters, 0), "port")
  to_port                  = lookup(element(var.http_target_group_parameters, length(var.http_target_group_parameters)), "port")
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.lb_group.id

  security_group_id = aws_security_group.group_loadbalancer_in_http[0].id
}

resource "aws_network_interface_sg_attachment" "sg_http_attachment" {
  count                = local.create_sg_http_attach
  security_group_id    = aws_security_group.group_loadbalancer_in_http[0].id
  network_interface_id = data.aws_instance.target_group_instances[count.index].network_interface_id
}

# https
resource "aws_security_group" "group_loadbalancer_in_https" {
  count       = local.create_sg_https_in
  name        = "tf-rule-alb-${var.prefix}${var.lb_name}-in-${lookup(element(var.https_target_group_parameters, 0), "port")}-${lookup(element(var.https_target_group_parameters, length(var.https_target_group_parameters)), "port")}"
  description = "Allow the load balancer in on ports ${lookup(element(var.https_target_group_parameters, 0), "port")}-${lookup(element(var.https_target_group_parameters, length(var.https_target_group_parameters)), "port")}"
  vpc_id      = var.vpc_id
}

resource "aws_security_group_rule" "rule_loadbalancer_in_https" {
  count                    = local.create_sg_https_in
  description              = "Allow the load balancer in on ports ${lookup(element(var.https_target_group_parameters, 0), "port")}-${length(var.https_target_group_parameters)}"
  type                     = "ingress"
  from_port                = lookup(element(var.https_target_group_parameters, 0), "port")
  to_port                  = lookup(element(var.https_target_group_parameters, length(var.https_target_group_parameters)), "port")
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.lb_group.id

  security_group_id = aws_security_group.group_loadbalancer_in_https[0].id
}

resource "aws_network_interface_sg_attachment" "sg_https_attachment" {
  count                = local.create_sg_https_attach
  security_group_id    = aws_security_group.group_loadbalancer_in_https[0].id
  network_interface_id = data.aws_instance.target_group_instances[count.index].network_interface_id
}
