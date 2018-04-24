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
  http_tg_attachment_conditionals =  "${var.lb_http_listener ?  "${length(var.http_target_group_names) == "${length(var.http_target_group_ports)}" ? "${length(var.http_target_group_names)}" : 0}" :0}"
  http_target_id_1 = "${length(split(",", var.target_ids)) >= 1 ? "${local.http_tg_attachment_conditionals}" :0}"
  http_target_id_2 = "${length(split(",", var.target_ids)) >= 2 ? "${local.http_tg_attachment_conditionals}" :0}"
  http_target_id_3 = "${length(split(",", var.target_ids)) >= 3 ? "${local.http_tg_attachment_conditionals}" :0}"
  http_target_id_4 = "${length(split(",", var.target_ids)) >= 4 ? "${local.http_tg_attachment_conditionals}" :0}"
  http_target_id_5 = "${length(split(",", var.target_ids)) >= 5 ? "${local.http_tg_attachment_conditionals}" :0}"
  http_target_id_6 = "${length(split(",", var.target_ids)) >= 6 ? "${local.http_tg_attachment_conditionals}" :0}"
  http_target_id_7 = "${length(split(",", var.target_ids)) >= 7 ? "${local.http_tg_attachment_conditionals}" :0}"
  http_target_id_8 = "${length(split(",", var.target_ids)) >= 8 ? "${local.http_tg_attachment_conditionals}" :0}"

  # HTTPS target group attachment
  https_tg_attachment_conditionals = "${var.lb_https_listener ? "${!var.lb_https_offloading ?  "${length(var.https_target_group_names) == "${length(var.https_target_group_ports)}" ? "${length(var.https_target_group_names)}" : 0}" :0}" :0}"

  https_target_id_1 = "${length(split(",", var.target_ids)) >= 1 ? "${local.https_tg_attachment_conditionals}" :0}"
  https_target_id_2 = "${length(split(",", var.target_ids)) >= 2 ? "${local.https_tg_attachment_conditionals}" :0}"
  https_target_id_3 = "${length(split(",", var.target_ids)) >= 3 ? "${local.https_tg_attachment_conditionals}" :0}"
  https_target_id_4 = "${length(split(",", var.target_ids)) >= 4 ? "${local.https_tg_attachment_conditionals}" :0}"
  https_target_id_5 = "${length(split(",", var.target_ids)) >= 5 ? "${local.https_tg_attachment_conditionals}" :0}"
  https_target_id_6 = "${length(split(",", var.target_ids)) >= 6 ? "${local.https_tg_attachment_conditionals}" :0}"
  https_target_id_7 = "${length(split(",", var.target_ids)) >= 7 ? "${local.https_tg_attachment_conditionals}" :0}"
  https_target_id_8 = "${length(split(",", var.target_ids)) >= 8 ? "${local.https_tg_attachment_conditionals}" :0}"
}
