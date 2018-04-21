locals {
  # Security groups
  lb_security_groups_for_http       = ["${aws_security_group.lb_group.id}", "${aws_security_group.rule_all_out.id}", "${aws_security_group.lb_http_listener_traffic_in.id}", "${var.lb_security_group_ids}"]
  lb_security_groups_for_https      = ["${aws_security_group.lb_group.id}", "${aws_security_group.rule_all_out.id}", "${aws_security_group.lb_https_listener_traffic_in.id}", "${var.lb_security_group_ids}"]
  lb_security_groups_for_http_https = ["${aws_security_group.lb_group.id}", "${aws_security_group.rule_all_out.id}", "${aws_security_group.lb_http_listener_traffic_in.id}", "${aws_security_group.lb_https_listener_traffic_in.id}", "${var.lb_security_group_ids}"]
  lb_security_groups                = ["${split(",", var.lb_http_listener ? var.lb_https_listener ? join(",", local.lb_security_groups_for_http_https) : join(",", local.lb_security_groups_for_http) : join(",", local.lb_security_groups_for_https))}"]

  # Subnet IDs
  lb_private_subnet_ids = ["${var.lb_private_subnet_ids}"]
  lb_public_subnet_ids  = ["${var.lb_public_subnet_ids}"]
  lb_subnet_ids         = ["${split(",", var.lb_internal ? join(",", local.lb_private_subnet_ids) : join(",", local.lb_public_subnet_ids))}"]

  # HTTP target group attachment
  http_target_id_1 = "${var.lb_http_listener ? "${length(split(",", var.target_ids)) >= 1 ? "${length(var.http_target_group_names) == "${length(var.http_target_group_ports)}" ? "${length(var.http_target_group_names)}" : 0}" :0}" :0}"
  http_target_id_2 = "${var.lb_http_listener ? "${length(split(",", var.target_ids)) >= 2 ? "${length(var.http_target_group_names) == "${length(var.http_target_group_ports)}" ? "${length(var.http_target_group_names)}" : 0}" :0}" :0}"
  http_target_id_3 = "${var.lb_http_listener ? "${length(split(",", var.target_ids)) >= 3 ? "${length(var.http_target_group_names) == "${length(var.http_target_group_ports)}" ? "${length(var.http_target_group_names)}" : 0}" :0}" :0}"
  http_target_id_4 = "${var.lb_http_listener ? "${length(split(",", var.target_ids)) >= 4 ? "${length(var.http_target_group_names) == "${length(var.http_target_group_ports)}" ? "${length(var.http_target_group_names)}" : 0}" :0}" :0}"
  http_target_id_5 = "${var.lb_http_listener ? "${length(split(",", var.target_ids)) >= 5 ? "${length(var.http_target_group_names) == "${length(var.http_target_group_ports)}" ? "${length(var.http_target_group_names)}" : 0}" :0}" :0}"
  http_target_id_6 = "${var.lb_http_listener ? "${length(split(",", var.target_ids)) >= 6 ? "${length(var.http_target_group_names) == "${length(var.http_target_group_ports)}" ? "${length(var.http_target_group_names)}" : 0}" :0}" :0}"
  http_target_id_7 = "${var.lb_http_listener ? "${length(split(",", var.target_ids)) >= 7 ? "${length(var.http_target_group_names) == "${length(var.http_target_group_ports)}" ? "${length(var.http_target_group_names)}" : 0}" :0}" :0}"
  http_target_id_8 = "${var.lb_http_listener ? "${length(split(",", var.target_ids)) >= 8 ? "${length(var.http_target_group_names) == "${length(var.http_target_group_ports)}" ? "${length(var.http_target_group_names)}" : 0}" :0}" :0}"

  # HTTPS target group attachment
  https_target_id_1 = "${var.lb_https_listener ? "${!var.lb_https_offloading ? "${length(split(",", var.target_ids)) >= 1 ? "${length(var.https_target_group_names) == "${length(var.https_target_group_ports)}" ? "${length(var.https_target_group_names)}" : 0}" :0}" :0}" :0}"
  https_target_id_2 = "${var.lb_https_listener ? "${!var.lb_https_offloading ? "${length(split(",", var.target_ids)) >= 2 ? "${length(var.https_target_group_names) == "${length(var.https_target_group_ports)}" ? "${length(var.https_target_group_names)}" : 0}" :0}" :0}" :0}"
  https_target_id_3 = "${var.lb_https_listener ? "${!var.lb_https_offloading ? "${length(split(",", var.target_ids)) >= 3 ? "${length(var.https_target_group_names) == "${length(var.https_target_group_ports)}" ? "${length(var.https_target_group_names)}" : 0}" :0}" :0}" :0}"
  https_target_id_4 = "${var.lb_https_listener ? "${!var.lb_https_offloading ? "${length(split(",", var.target_ids)) >= 4 ? "${length(var.https_target_group_names) == "${length(var.https_target_group_ports)}" ? "${length(var.https_target_group_names)}" : 0}" :0}" :0}" :0}"
  https_target_id_5 = "${var.lb_https_listener ? "${!var.lb_https_offloading ? "${length(split(",", var.target_ids)) >= 5 ? "${length(var.https_target_group_names) == "${length(var.https_target_group_ports)}" ? "${length(var.https_target_group_names)}" : 0}" :0}" :0}" :0}"
  https_target_id_6 = "${var.lb_https_listener ? "${!var.lb_https_offloading ? "${length(split(",", var.target_ids)) >= 6 ? "${length(var.https_target_group_names) == "${length(var.https_target_group_ports)}" ? "${length(var.https_target_group_names)}" : 0}" :0}" :0}" :0}"
  https_target_id_7 = "${var.lb_https_listener ? "${!var.lb_https_offloading ? "${length(split(",", var.target_ids)) >= 7 ? "${length(var.https_target_group_names) == "${length(var.https_target_group_ports)}" ? "${length(var.https_target_group_names)}" : 0}" :0}" :0}" :0}"
  https_target_id_8 = "${var.lb_https_listener ? "${!var.lb_https_offloading ? "${length(split(",", var.target_ids)) >= 8 ? "${length(var.https_target_group_names) == "${length(var.https_target_group_ports)}" ? "${length(var.https_target_group_names)}" : 0}" :0}" :0}" :0}"

}
