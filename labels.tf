module "label" {
  source  = "cloudposse/label/null"
  version = "0.16.0"

  namespace   = var.namespace
  environment = var.environment
  name        = var.name
  attributes  = concat(["flow-log"], var.attributes)
  tags        = var.tags
}
