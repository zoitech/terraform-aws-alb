locals {
  # Security groups
  lb_security_groups_for_http = ["${aws_security_group.lb_group.id}","${aws_security_group.rule_all_out_2.id}","${aws_security_group.lb_http_listener_traffic_in.id}","${var.lb_security_group_ids}"]
  lb_security_groups_for_https = ["${aws_security_group.lb_group.id}","${aws_security_group.rule_all_out_2.id}","${aws_security_group.lb_https_listener_traffic_in.id}", "${var.lb_security_group_ids}"]
  lb_security_groups_for_http_https = ["${aws_security_group.lb_group.id}","${aws_security_group.rule_all_out_2.id}","${aws_security_group.lb_http_listener_traffic_in.id}","${aws_security_group.lb_https_listener_traffic_in.id}", "${var.lb_security_group_ids}"]
  lb_security_groups = ["${split(",", var.lb_http_listener ? var.lb_https_listener ? join(",", local.lb_security_groups_for_http_https) : join(",", local.lb_security_groups_for_http) : join(",", local.lb_security_groups_for_https))}"]
  # Subnet IDs
  lb_private_subnet_ids = ["${var.lb_private_subnet_ids}"]
  lb_public_subnet_ids = ["${var.lb_public_subnet_ids}"]
  lb_subnet_ids = ["${split(",", var.lb_internal ? join(",", local.lb_private_subnet_ids) : join(",", local.lb_public_subnet_ids))}"]
}
