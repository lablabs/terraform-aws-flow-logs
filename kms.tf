locals {
  kms_alias   = var.kms_alias == "" ? "alias/${module.label.id}" : var.kms_alias
  kms_enabled = var.cloudwatch_kms_generated || var.bucket_kms_generated ? true : false
}

data "aws_caller_identity" "kms" {}

data "aws_iam_policy_document" "kms" {
  statement {
    sid    = "AllowKMSAllForOwnerAccount"
    effect = "Allow"

    actions = [
      "kms:*",
    ]

    resources = [
      "*"
    ]

    principals {
      type = "AWS"

      identifiers = [
        "arn:aws:iam::${data.aws_caller_identity.kms.account_id}:root"
      ]
    }
  }

  statement {
    sid    = "AllowKeyUsageInFlowLog"
    effect = "Allow"

    actions = [
      "kms:Encrypt*",
      "kms:Decrypt*",
      "kms:ReEncrypt*",
      "kms:GenerateDataKey*",
      "kms:Describe*"
    ]

    resources = [
      "*"
    ]

    principals {
      type = "Service"

      identifiers = [
        "delivery.logs.amazonaws.com",
        "logs.amazonaws.com"
      ]
    }
  }
}

module "kms-key" {
  source  = "cloudposse/kms-key/aws"
  version = "0.4.0"

  namespace   = module.label.namespace
  environment = module.label.environment
  name        = module.label.name
  attributes  = module.label.attributes
  tags        = module.label.tags

  enabled     = var.enabled && local.kms_enabled ? true : false
  description = var.kms_description
  alias       = local.kms_alias
  policy      = join("", data.aws_iam_policy_document.kms.*.json)
}
