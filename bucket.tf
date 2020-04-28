locals {
  bucket_arn                = local.log_bucket_creation_enabled ? "arn:aws:s3:::${module.label.id}/flow-logs/" : var.bucket_arn
  bucket_sse_algorithm      = (var.bucket_kms_generated || var.bucket_kms_master_key_arn != "") ? "aws:kms" : "AES256"
  bucket_kms_master_key_arn = var.bucket_kms_generated ? module.kms-key.key_arn : var.bucket_kms_master_key_arn
}

module "log-bucket" {
  # FIXME:
  # https://github.com/cloudposse/terraform-aws-s3-log-storage/pull/27
  # https://github.com/cloudposse/terraform-aws-s3-log-storage/pull/28
  source = "git::https://github.com/lablabs/terraform-aws-s3-log-storage.git?ref=opt-out-standard-transition-fix-pub-access"

  namespace   = module.label.namespace
  environment = module.label.environment
  name        = module.label.name
  attributes  = module.label.attributes
  tags        = module.label.tags

  enabled                    = var.enabled && local.log_bucket_creation_enabled ? true : false
  force_destroy              = var.bucket_force_destroy
  policy                     = data.aws_iam_policy_document.bucket.json
  acl                        = var.bucket_acl
  sse_algorithm              = local.bucket_sse_algorithm
  kms_master_key_arn         = local.bucket_kms_master_key_arn
  lifecycle_rule_enabled     = var.bucket_lifecycle_rule_enabled
  expiration_days            = var.bucket_expiration_days
  lifecycle_prefix           = var.bucket_lifecycle_prefix
  lifecycle_tags             = var.bucket_lifecycle_tags
  enable_standard_transition = var.bucket_enable_standard_transition
  standard_transition_days   = var.bucket_standard_transition_days
  enable_glacier_transition  = var.bucket_enable_glacier_transition
  glacier_transition_days    = var.bucket_glacier_transition_days
}

data "aws_iam_policy_document" "bucket" {
  statement {
    sid    = "AWSLogDeliveryWrite"
    effect = "Allow"
    actions = [
      "s3:PutObject"
    ]
    resources = [
      "${local.bucket_arn}*"
    ]

    principals {
      type        = "Service"
      identifiers = ["delivery.logs.amazonaws.com"]
    }

    condition {
      test     = "StringEquals"
      variable = "s3:x-amz-acl"

      values = [
        "bucket-owner-full-control"
      ]
    }
  }

  statement {
    sid    = "AWSLogDeliveryAclCheck"
    effect = "Allow"
    actions = [
      "s3:GetBucketAcl"
    ]

    resources = [
      split("/", local.bucket_arn)[0]
    ]

    principals {
      type        = "Service"
      identifiers = ["delivery.logs.amazonaws.com"]
    }
  }
}