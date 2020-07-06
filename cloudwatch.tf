locals {
  cloudwatch_name = "/aws/flow-logs/${module.label.id}"
  # need for destroy when var.enabled is set to false
  cloudwatch_arn = format(
    "arn:aws:logs:%s:%s:log-group:%s:*",
    data.aws_region.cw.name,
    data.aws_caller_identity.cw.account_id,
    local.cloudwatch_name
  )
  cloudwatch_kms_key_id = var.cloudwatch_kms_master_key_arn != "" ? var.cloudwatch_kms_master_key_arn : null
}

data "aws_caller_identity" "cw" {}
data "aws_region" "cw" {}

resource "aws_cloudwatch_log_group" "self" {
  count = var.enabled && var.cloudwatch_generated ? 1 : 0

  name              = "/aws/flow-logs/${module.label.id}"
  retention_in_days = var.cloudwatch_retention_in_days
  kms_key_id        = var.cloudwatch_kms_generated ? module.kms-key.key_id : local.cloudwatch_kms_key_id
  tags              = module.label.tags
}
