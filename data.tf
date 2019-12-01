data "aws_caller_identity" "current" {
}

data "aws_instance" "target_group_instances" {
  count       = length(split(",", var.target_ids))
  instance_id = element(split(",", var.target_ids), count.index)
}
