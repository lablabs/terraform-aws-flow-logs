output "flow_log_cloudwatch_attributes" {
  description = "Map of the cloudwatch flow logs attributes, where key is source id (vpc, subnet, enis)"
  value       = aws_flow_log.cloudwatch
}

output "flow_log_cloudwatch_ids" {
  description = "Map of the cloudwatch flow logs ID, where key is source id (vpc, subnet, enis)"
  value = {
    for source, attributes in aws_flow_log.cloudwatch :
    source => attributes.id
  }
}

output "flow_log_cloudwatch_role_id" {
  description = "The flow log cloudwatch role ID"
  value       = element(concat(aws_iam_role.cloudwatch.*.id, [""]), 0)
}

output "flow_log_bucket_attributes" {
  description = "Map of the bucket flow logs attributes, where key is source id (vpc, subnet, enis)"
  value       = aws_flow_log.bucket
}

output "flow_log_bucket_ids" {
  description = "Map of the bucket flow logs ID, where key is source id (vpc, subnet, enis)"
  value = {
    for source, attributes in aws_flow_log.bucket :
    source => attributes.id
  }
}

output "bucket_domain_name" {
  description = "Session manager log bucket FQDN"
  value       = module.log-bucket.bucket_domain_name
}

output "bucket_id" {
  description = "Session manager log bucket ID"
  value       = module.log-bucket.bucket_id
}

output "bucket_arn" {
  description = "Session manager log bucket ARN"
  value       = module.log-bucket.bucket_arn
}

output "bucket_policy_document" {
  description = "The bucket policy JSON document"
  value       = data.aws_iam_policy_document.bucket
}

output "kms_key_arn" {
  description = "Session manager log KMS key ARN"
  value       = module.kms-key.key_arn
}

output "kms_key_id" {
  description = "Session manager log KMS key ID"
  value       = module.kms-key.key_id
}

output "kms_key_alias_name" {
  description = "Session manager log KMS key alias name"
  value       = module.kms-key.alias_name
}

output "kms_key_alias_arn" {
  description = "Session manager log KMS key alias ARN"
  value       = module.kms-key.alias_arn
}

output "kms_policy_document" {
  description = "The kms policy JSON document"
  value       = data.aws_iam_policy_document.kms
}

output "cloudwatch_group_name" {
  description = "Session manager cloudwatch log group name"
  value       = element(concat(aws_cloudwatch_log_group.self.*.name, [""]), 0)
}

output "cloudwatch_group_arn" {
  description = "Session manager cloudwatch log group arn"
  value       = element(concat(aws_cloudwatch_log_group.self.*.arn, [""]), 0)
}

output "cloudwatch_group_retention_in_days" {
  description = "Session manager cloudwatch log group retention days"
  value       = element(concat(aws_cloudwatch_log_group.self.*.retention_in_days, [""]), 0)
}

output "cloudwatch_group_kms_key_id" {
  description = "Session manager cloudwatch log group kms key id"
  value       = element(concat(aws_cloudwatch_log_group.self.*.kms_key_id, [""]), 0)
}