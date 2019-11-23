locals {
  # load balancer
  create_internal_lb = (var.create_internal_lb == true ? 1 : 0)

  # load balancer listeners
  ## alb_http_listeners.tf
  create_lb_http_listener       = (var.create_lb_http_listener == true ? 1 : 0)
  create_lb_http_listener_rules = (var.create_lb_http_listener == true && var.http_target_group_parameters != null ? length(var.http_target_group_parameters) : 0)
  ## alb_https_listeners.tf
  create_lb_https_listener = (var.create_lb_https_listener == true ? 1 : 0)
  #create_lb_https_listener_rules = (var.create_lb_https_listener == true && var.https_target_group_parameters != null ? length(var.https_target_group_parameters) : 0)
  create_lb_https_listener_rules = (var.create_lb_https_listener == true ? (var.enable_lb_https_offloading == true && var.http_target_group_parameters != null ? length(var.http_target_group_parameters) : (var.enable_lb_https_offloading == false && var.https_target_group_parameters != null ? length(var.https_target_group_parameters) : 0)) : 0)
  # target groups
  ## http target group
  create_tg_http = (var.create_lb_http_listener == true && var.http_target_group_parameters != null ? length(var.http_target_group_parameters) : 0)
  ## https target groups
  create_tg_https = (var.create_lb_https_listener == true && var.enable_lb_https_offloading == false && var.https_target_group_parameters != null ? length(var.https_target_group_parameters : 0)
  # Security groups
  lb_security_groups = concat([aws_security_group.lb_group.id], var.lb_security_group_ids)

  # Subnet IDs
  lb_private_subnet_ids = [var.lb_private_subnet_ids]
  lb_public_subnet_ids  = [var.lb_public_subnet_ids]
  lb_subnet_ids = [split(
    ",",
    var.lb_internal ? join(",", local.lb_private_subnet_ids) : join(",", local.lb_public_subnet_ids),
  )]

  # HTTP target group attachment
  http_tg_attachment_conditionals = var.create_lb_http_listener == true ? length(var.http_target_group_parameters) : 0
  http_target_id_1                = length(split(",", var.target_ids)) >= 1 ? local.http_tg_attachment_conditionals : 0
  http_target_id_2                = length(split(",", var.target_ids)) >= 2 ? local.http_tg_attachment_conditionals : 0
  http_target_id_3                = length(split(",", var.target_ids)) >= 3 ? local.http_tg_attachment_conditionals : 0
  http_target_id_4                = length(split(",", var.target_ids)) >= 4 ? local.http_tg_attachment_conditionals : 0
  http_target_id_5                = length(split(",", var.target_ids)) >= 5 ? local.http_tg_attachment_conditionals : 0
  http_target_id_6                = length(split(",", var.target_ids)) >= 6 ? local.http_tg_attachment_conditionals : 0
  http_target_id_7                = length(split(",", var.target_ids)) >= 7 ? local.http_tg_attachment_conditionals : 0
  http_target_id_8                = length(split(",", var.target_ids)) >= 8 ? local.http_tg_attachment_conditionals : 0

  # HTTPS target group attachment
  https_tg_attachment_conditionals = var.create_lb_https_listener == true ? var.enable_lb_https_offloading == false ? length(var.https_target_group_parameters) : 0 : 0

  https_target_id_1 = length(split(",", var.target_ids)) >= 1 ? local.https_tg_attachment_conditionals : 0
  https_target_id_2 = length(split(",", var.target_ids)) >= 2 ? local.https_tg_attachment_conditionals : 0
  https_target_id_3 = length(split(",", var.target_ids)) >= 3 ? local.https_tg_attachment_conditionals : 0
  https_target_id_4 = length(split(",", var.target_ids)) >= 4 ? local.https_tg_attachment_conditionals : 0
  https_target_id_5 = length(split(",", var.target_ids)) >= 5 ? local.https_tg_attachment_conditionals : 0
  https_target_id_6 = length(split(",", var.target_ids)) >= 6 ? local.https_tg_attachment_conditionals : 0
  https_target_id_7 = length(split(",", var.target_ids)) >= 7 ? local.https_tg_attachment_conditionals : 0
  https_target_id_8 = length(split(",", var.target_ids)) >= 8 ? local.https_tg_attachment_conditionals : 0
}

