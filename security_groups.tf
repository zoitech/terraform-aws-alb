# Security group "group" for loadbalancer with no rules. 
#To be used in other security group rules to specify the loadblaancer as the source.
resource "aws_security_group" "lb_group" {
  name        = "Group-ALB-${var.lb_name}"
  description = "Attach security group with loadbalancer name to loadbalancer with no rules"
  vpc_id      = var.vpc_id
}

data "aws_instance" "target_group_instances" {
  count       = length(split(",", var.target_ids))
  instance_id = element(split(",", var.target_ids), count.index)

}

resource "aws_security_group" "group_loadbalancer_in" {
  name        = "tf-rule-alb-${var.prefix}${var.lb_name}-in-${var.lb_in_from_port}-${var.lb_in_to_port}"
  description = "Allow the load balancer in on ports ${var.lb_in_from_port}-${var.lb_in_to_port}"
  vpc_id      = var.vpc_id
}

resource "aws_security_group_rule" "rule_loadbalancer_in" {
  description              = "Allow the load balancer in on ports ${var.lb_in_from_port}-${var.lb_in_to_port}"
  type                     = "ingress"
  from_port                = var.lb_in_from_port
  to_port                  = var.lb_in_to_port
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.lb_group.id

  security_group_id = aws_security_group.group_loadbalancer_in.id
}

resource "aws_network_interface_sg_attachment" "sg_attachment" {
  count                = length(split(",", var.target_ids))
  security_group_id    = aws_security_group.group_loadbalancer_in.id
  network_interface_id = data.aws_instance.target_group_instances[count.index].network_interface_id
}
