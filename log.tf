locals {
  log_destination_type = var.enabled ? var.log_destination_type : []

  log_bucket_creation_enabled     = contains(var.log_destination_type, "s3") && var.bucket_generated ? true : false
  log_cloudwatch_creation_enabled = contains(var.log_destination_type, "cloud-watch-logs") && var.cloudwatch_generated ? true : false

  log_destinations_cw     = local.log_cloudwatch_creation_enabled ? local.cloudwatch_arn : var.cloudwatch_group_arn
  log_destinations_bucket = local.log_bucket_creation_enabled ? local.bucket_arn : var.bucket_arn

  log_source_type_vpc    = var.log_vpc_id != "" ? true : false
  log_source_type_subnet = length(var.log_subnet_ids) > 0 ? true : false
  log_source_type_eni    = length(var.log_eni_ids) > 0 ? true : false

  log_source = var.enabled ? compact(concat(
    [var.log_vpc_id],
    var.log_subnet_ids,
    var.log_eni_ids
  )) : []
}


resource "aws_flow_log" "cloudwatch" {
  for_each = toset([
    for source in local.log_source :
    source
    if contains(var.log_destination_type, "cloud-watch-logs")
  ])

  iam_role_arn = aws_iam_role.cloudwatch[0].arn

  log_destination_type = "cloud-watch-logs"
  log_destination      = local.log_destinations_cw

  vpc_id    = local.log_source_type_vpc ? each.value : null
  subnet_id = local.log_source_type_subnet ? each.value : null
  eni_id    = local.log_source_type_eni ? each.value : null

  log_format               = "${var.log_format} ${var.log_format_additional_fields}"
  traffic_type             = var.log_traffic_type
  max_aggregation_interval = var.log_max_aggregation_interval
  tags                     = module.label.tags

  depends_on = [
    aws_cloudwatch_log_group.self
  ]
}

resource "aws_iam_role" "cloudwatch" {
  count = var.enabled && contains(var.log_destination_type, "cloud-watch-logs") ? 1 : 0

  name               = "${module.label.id}-cw"
  assume_role_policy = data.aws_iam_policy_document.flow_log_cw_assume[0].json
  tags               = module.label.tags
}

data "aws_iam_policy_document" "flow_log_cw_assume" {
  count = var.enabled && contains(var.log_destination_type, "cloud-watch-logs") ? 1 : 0

  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["vpc-flow-logs.amazonaws.com"]
    }
  }
}

resource "aws_iam_role_policy" "flow_log_cw" {
  count = var.enabled && contains(var.log_destination_type, "cloud-watch-logs") ? 1 : 0

  name   = "${module.label.id}-cw"
  role   = aws_iam_role.cloudwatch[0].id
  policy = data.aws_iam_policy_document.flow_log_cw[0].json
}

data "aws_iam_policy_document" "flow_log_cw" {
  count = var.enabled && contains(var.log_destination_type, "cloud-watch-logs") ? 1 : 0

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
  for_each = toset([
    for source in local.log_source :
    source
    if contains(var.log_destination_type, "s3")
  ])

  log_destination_type = "s3"
  log_destination      = local.log_destinations_bucket

  vpc_id    = local.log_source_type_vpc ? each.value : null
  subnet_id = local.log_source_type_subnet ? each.value : null
  eni_id    = local.log_source_type_eni ? each.value : null

  log_format               = "${var.log_format} ${var.log_format_additional_fields}"
  traffic_type             = var.log_traffic_type
  max_aggregation_interval = var.log_max_aggregation_interval
  tags                     = module.label.tags

  depends_on = [
    module.log-bucket
  ]
}