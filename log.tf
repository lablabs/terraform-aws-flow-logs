locals {
  log_destination_type = var.enabled ? var.log_destination_type : []

  log_bucket_enabled     = contains(var.log_destination_type, "s3")
  log_cloudwatch_enabled = contains(var.log_destination_type, "cloud-watch-logs")

  log_bucket_creation_enabled     = local.log_bucket_enabled && var.bucket_generated ? true : false
  log_cloudwatch_creation_enabled = local.log_cloudwatch_enabled && var.cloudwatch_generated ? true : false

  log_destinations_cw     = local.log_cloudwatch_creation_enabled ? local.cloudwatch_arn : var.cloudwatch_group_arn
  log_destinations_bucket = local.log_bucket_creation_enabled ? local.bucket_arn : var.bucket_arn

  log_source_type_vpc    = var.log_vpc_id != "" ? true : false
  log_source_type_subnet = length(var.log_subnet_ids) > 0 ? true : false
  log_source_type_eni    = length(var.log_eni_ids) > 0 ? true : false
}

resource "aws_flow_log" "cloudwatch" {
  count = var.enabled && local.log_cloudwatch_enabled ? (
    length(var.log_vpc_id) +
    length(var.log_subnet_ids) +
    length(var.log_eni_ids)
  ) : 0

  iam_role_arn = aws_iam_role.cloudwatch[0].arn

  log_destination_type = "cloud-watch-logs"
  log_destination      = local.log_destinations_cw

  vpc_id    = local.log_source_type_vpc ? var.log_vpc_id[count.index] : null
  subnet_id = local.log_source_type_subnet ? var.log_subnet_ids[count.index] : null
  eni_id    = local.log_source_type_eni ? var.log_eni_ids[count.index] : null

  log_format               = "${var.log_format} ${var.log_format_additional_fields}"
  traffic_type             = var.log_traffic_type
  max_aggregation_interval = var.log_max_aggregation_interval
  tags                     = module.label.tags

  depends_on = [
    aws_cloudwatch_log_group.self,
  ]
}

resource "aws_iam_role" "cloudwatch" {
  count = var.enabled && local.log_cloudwatch_creation_enabled ? 1 : 0

  name               = "${module.label.id}-cw"
  assume_role_policy = data.aws_iam_policy_document.flow_log_cw_assume[0].json
  tags               = module.label.tags
}

data "aws_iam_policy_document" "flow_log_cw_assume" {
  count = var.enabled && local.log_cloudwatch_creation_enabled ? 1 : 0

  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["vpc-flow-logs.amazonaws.com"]
    }
  }
}

resource "aws_iam_role_policy" "flow_log_cw" {
  count = var.enabled && local.log_cloudwatch_creation_enabled ? 1 : 0

  name   = "${module.label.id}-cw"
  role   = aws_iam_role.cloudwatch[0].id
  policy = data.aws_iam_policy_document.flow_log_cw[0].json
}

data "aws_iam_policy_document" "flow_log_cw" {
  count = var.enabled && local.log_cloudwatch_creation_enabled ? 1 : 0

  statement {
    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
      "logs:DescribeLogGroups",
      "logs:DescribeLogStreams",
    ]

    resources = [
      "*",
    ]
  }
}

resource "aws_flow_log" "bucket" {
  count = var.enabled && local.log_bucket_enabled ? (
    length(var.log_vpc_id) +
    length(var.log_subnet_ids) +
    length(var.log_eni_ids)
  ) : 0

  log_destination_type = "s3"
  log_destination      = local.log_destinations_bucket

  vpc_id    = local.log_source_type_vpc ? var.log_vpc_id[count.index] : null
  subnet_id = local.log_source_type_subnet ? var.log_subnet_ids[count.index] : null
  eni_id    = local.log_source_type_eni ? var.log_eni_ids[count.index] : null

  log_format               = "${var.log_format} ${var.log_format_additional_fields}"
  traffic_type             = var.log_traffic_type
  max_aggregation_interval = var.log_max_aggregation_interval
  tags                     = module.label.tags

  depends_on = [
    module.log-bucket
  ]
}