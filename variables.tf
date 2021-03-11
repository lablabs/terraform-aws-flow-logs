variable "namespace" {
  description = "Namespace, which could be your organization name or abbreviation, e.g. 'eg' or 'cp'"
  type        = string
  default     = ""
}

variable "environment" {
  description = "Environment, e.g. 'prod', 'staging', 'dev', 'pre-prod', 'UAT'"
  type        = string
  default     = ""
}

variable "name" {
  description = "Solution name, e.g. 'app' or 'jenkins'"
  type        = string
  default     = ""
}

variable "attributes" {
  type        = list(string)
  default     = []
  description = "Additional attributes (e.g. `1`)"
}

variable "tags" {
  description = "Additional tags (e.g. `map('BusinessUnit','XYZ')`"
  type        = map(string)
  default     = {}
}

variable "enabled" {
  description = "Set to false to prevent the module from creating any resources"
  type        = bool
  default     = false
}

variable "log_destination_type" {
  description = "The list of the logging destination types. Valid values: cloud-watch-logs, s3"
  type        = list(string)
  default     = []
}

variable "log_traffic_type" {
  description = "The type of traffic to capture. Valid values: ACCEPT,REJECT, ALL"
  type        = string
  default     = "ALL"
}

variable "log_max_aggregation_interval" {
  description = "The maximum interval of time during which a flow of packets is captured and aggregated into a flow log record. Valid Values: 60 seconds (1 minute) or 600 seconds (10 minutes)"
  type        = string
  default     = "600"
}

variable "log_format" {
  description = "The fields to include in the flow log record, in the order in which they should appear"
  type        = string
  default     = "$${version} $${account-id} $${interface-id} $${srcaddr} $${dstaddr} $${srcport} $${dstport} $${protocol} $${packets} $${bytes} $${start} $${end} $${action} $${log-status}"
}

variable "log_format_additional_fields" {
  description = "Append additional fields to the default format (useful for v3)"
  type        = string
  default     = ""
  # Version 3 additional fields:
  #   $${vpc-id} - The ID of the VPC that contains the network interface for which the traffic is recorded
  #   $${subnet-id} - The ID of the subnet that contains the network interface for which the traffic is recorded
  #   $${instance-id} - The ID of the instance that's associated with network interface for which the traffic is recorded
  #   $${tcp-flags} - The bitmask value for the following TCP flags: SYN: 2 SYN-ACK: 18 FIN: 1 RST: 4
  #   $${type} - The type of traffic: IPv4, IPv6, or EFA
  #   $${pkt-srcaddr} - The packet-level (original) source IP address of the traffic
  #   $${pkt-dstaddr} - The packet-level (original) destination IP address for the traffic
}

variable "log_vpc_id" {
  description = "VPC ID to attach flow logs. Only one of log_vpc_id or log_subnet"
  type        = string
  default     = ""
}

variable "log_subnet_ids" {
  description = "List of Subnet ID to attach flow logs"
  type        = list(string)
  default     = []
}

variable "log_eni_ids" {
  description = "List of Elastic Network Interface ID to attach flow logs"
  type        = list(string)
  default     = []
}

variable "bucket_generated" {
  description = "Set to `true` to use auto generated bucket for log destination"
  type        = bool
  default     = false
}

variable "bucket_arn" {
  description = "The bucket ARN of the logging destination"
  type        = string
  default     = ""
}

variable "bucket_force_destroy" {
  type        = bool
  description = "(Optional, Default:false ) A boolean that indicates all objects should be deleted from the bucket so that the bucket can be destroyed without error. These objects are not recoverable"
  default     = false
}

variable "bucket_versioning_enabled" {
  type        = bool
  default     = false
  description = "A state of versioning. Versioning is a means of keeping multiple variants of an object in the same bucket"
}
variable "bucket_acl" {
  description = "The canned ACL to apply. We recommend log-delivery-write for compatibility with AWS services"
  type        = string
  default     = "log-delivery-write"
}

variable "bucket_lifecycle_rule_enabled" {
  description = "Enable lifecycle events on this bucket"
  type        = bool
  default     = false
}

variable "bucket_expiration_days" {
  description = "Number of days after which to expunge the objects"
  default     = 90
}

variable "bucket_lifecycle_prefix" {
  type        = string
  description = "Prefix filter. Used to manage object lifecycle events"
  default     = ""
}

variable "bucket_lifecycle_tags" {
  description = "Tags filter. Used to manage object lifecycle events"
  type        = map(string)
  default     = {}
}

variable "bucket_standard_transition_days" {
  description = "Number of days to persist in the standard storage tier before moving to the infrequent access tier"
  default     = 30
}

variable "bucket_enable_glacier_transition" {
  description = "Glacier transition might just increase your bill. Set to false to disable lifecycle transitions to AWS Glacier."
  type        = bool
  default     = false
}

variable "bucket_glacier_transition_days" {
  description = "Number of days after which to move the data to the glacier storage tier"
  default     = 60
}

variable "bucket_kms_master_key_arn" {
  description = "The AWS KMS master key ARN used for the SSE-KMS encryption. This can only be used when you set the value of sse_algorithm as aws:kms. The default aws/s3 AWS KMS master key is used if this element is absent while the sse_algorithm is aws:kms"
  type        = string
  default     = ""
}

variable "bucket_kms_generated" {
  description = "Set to `true` to use auto generated KMS CMK key for bucket encryption"
  type        = bool
  default     = false
}

variable "cloudwatch_generated" {
  description = "Set to `true` to use auto generated CloudWatch log group"
  type        = bool
  default     = false
}

variable "cloudwatch_group_arn" {
  description = "The CloudWatch log group ARN"
  type        = string
  default     = ""
}

variable "cloudwatch_retention_in_days" {
  description = "Number of days you want to retain log events in the log group"
  default     = 30
}


variable "cloudwatch_kms_master_key_arn" {
  description = "The AWS KMS master key ARN used for the CloudWatch encryption"
  type        = string
  default     = ""
}

variable "cloudwatch_kms_generated" {
  description = "Set to `true` to use auto generated KMS CMK key for CloudWatch encryption"
  type        = bool
  default     = false
}

variable "kms_description" {
  description = "The description of the key as viewed in AWS console"
  type        = string
  default     = "KMS key to encrypt the logs delivered by vpc flow logs"
}

variable "kms_alias" {
  description = "The display name of the alias. The name must start with the word `alias` followed by a forward slash, leave default for auto generated alias"
  type        = string
  default     = ""
}

variable "kms_enable_key_rotation" {
  description = "Specifies whether key rotation is enabled"
  type        = bool
  default     = false
}
