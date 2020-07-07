# terraform-aws-flow-logs
# AWS flow logs Terraform module

[![Labyrinth Labs logo](ll-logo.png)](https://www.lablabs.io)

We help companies build, run, deploy and scale software and infrastructure by embracing the right technologies and principles. Check out our website at https://lablabs.io/

---

![Terraform validation](https://github.com/lablabs/terraform-aws-flow-logs/workflows/Terraform%20validation/badge.svg?branch=master)
[![pre-commit](https://img.shields.io/badge/pre--commit-enabled-success?logo=pre-commit&logoColor=white)](https://github.com/pre-commit/pre-commit)

## Description

A terraform module to create AWS Flow log resources.

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| terraform | ~> 0.12 |
| aws | ~> 2.53 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| attributes | Additional attributes (e.g. `1`) | `list(string)` | `[]` | no |
| bucket\_acl | The canned ACL to apply. We recommend log-delivery-write for compatibility with AWS services | `string` | `"log-delivery-write"` | no |
| bucket\_arn | The bucket ARN of the logging destination | `string` | `""` | no |
| bucket\_enable\_glacier\_transition | Glacier transition might just increase your bill. Set to false to disable lifecycle transitions to AWS Glacier. | `bool` | `false` | no |
| bucket\_enable\_standard\_transition | Enables the transition to AWS STANDARD IA | `bool` | `false` | no |
| bucket\_expiration\_days | Number of days after which to expunge the objects | `number` | `90` | no |
| bucket\_force\_destroy | (Optional, Default:false ) A boolean that indicates all objects should be deleted from the bucket so that the bucket can be destroyed without error. These objects are not recoverable | `bool` | `false` | no |
| bucket\_generated | Set to `true` to use auto generated bucket for log destination | `bool` | `false` | no |
| bucket\_glacier\_transition\_days | Number of days after which to move the data to the glacier storage tier | `number` | `60` | no |
| bucket\_kms\_generated | Set to `true` to use auto generated KMS CMK key for bucket encryption | `bool` | `false` | no |
| bucket\_kms\_master\_key\_arn | The AWS KMS master key ARN used for the SSE-KMS encryption. This can only be used when you set the value of sse\_algorithm as aws:kms. The default aws/s3 AWS KMS master key is used if this element is absent while the sse\_algorithm is aws:kms | `string` | `""` | no |
| bucket\_lifecycle\_prefix | Prefix filter. Used to manage object lifecycle events | `string` | `""` | no |
| bucket\_lifecycle\_rule\_enabled | Enable lifecycle events on this bucket | `bool` | `false` | no |
| bucket\_lifecycle\_tags | Tags filter. Used to manage object lifecycle events | `map(string)` | `{}` | no |
| bucket\_standard\_transition\_days | Number of days to persist in the standard storage tier before moving to the infrequent access tier | `number` | `30` | no |
| cloudwatch\_generated | Set to `true` to use auto generated CloudWatch log group | `bool` | `false` | no |
| cloudwatch\_group\_arn | The CloudWatch log group ARN | `string` | `""` | no |
| cloudwatch\_kms\_generated | Set to `true` to use auto generated KMS CMK key for CloudWatch encryption | `bool` | `false` | no |
| cloudwatch\_kms\_master\_key\_arn | The AWS KMS master key ARN used for the CloudWatch encryption | `string` | `""` | no |
| cloudwatch\_retention\_in\_days | Number of days you want to retain log events in the log group | `number` | `30` | no |
| enabled | Set to false to prevent the module from creating any resources | `bool` | `false` | no |
| environment | Environment, e.g. 'prod', 'staging', 'dev', 'pre-prod', 'UAT' | `string` | `""` | no |
| kms\_alias | The display name of the alias. The name must start with the word `alias` followed by a forward slash, leave default for auto generated alias | `string` | `""` | no |
| kms\_description | The description of the key as viewed in AWS console | `string` | `"KMS key to encrypt the logs delivered by vpc flow logs"` | no |
| kms\_enable\_key\_rotation | Specifies whether key rotation is enabled | `bool` | `false` | no |
| log\_destination\_type | The list of the logging destination types. Valid values: cloud-watch-logs, s3 | `list(string)` | `[]` | no |
| log\_eni\_ids | List of Elastic Network Interface ID to attach flow logs | `list(string)` | `[]` | no |
| log\_format | The fields to include in the flow log record, in the order in which they should appear | `string` | `"${version} ${account-id} ${interface-id} ${srcaddr} ${dstaddr} ${srcport} ${dstport} ${protocol} ${packets} ${bytes} ${start} ${end} ${action} ${log-status}"` | no |
| log\_format\_additional\_fields | Append additional fields to the default format (useful for v3) | `string` | `""` | no |
| log\_max\_aggregation\_interval | The maximum interval of time during which a flow of packets is captured and aggregated into a flow log record. Valid Values: 60 seconds (1 minute) or 600 seconds (10 minutes) | `string` | `"600"` | no |
| log\_subnet\_ids | List of Subnet ID to attach flow logs | `list(string)` | `[]` | no |
| log\_traffic\_type | The type of traffic to capture. Valid values: ACCEPT,REJECT, ALL | `string` | `"ALL"` | no |
| log\_vpc\_id | VPC ID to attach flow logs. Only one of log\_vpc\_id or log\_subnet | `string` | `""` | no |
| name | Solution name, e.g. 'app' or 'jenkins' | `string` | `""` | no |
| namespace | Namespace, which could be your organization name or abbreviation, e.g. 'eg' or 'cp' | `string` | `""` | no |
| tags | Additional tags (e.g. `map('BusinessUnit','XYZ')` | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| bucket\_arn | Session manager log bucket ARN |
| bucket\_domain\_name | Session manager log bucket FQDN |
| bucket\_id | Session manager log bucket ID |
| bucket\_policy\_document | The bucket policy JSON document |
| cloudwatch\_group\_arn | Session manager CloudWatch log group arn |
| cloudwatch\_group\_kms\_key\_id | Session manager CloudWatch log group kms key id |
| cloudwatch\_group\_name | Session manager CloudWatch log group name |
| cloudwatch\_group\_retention\_in\_days | Session manager CloudWatch log group retention days |
| flow\_log\_bucket\_ids | List of the bucket flow logs ID |
| flow\_log\_cloudwatch\_ids | List of the CloudWatch flow logs ID |
| flow\_log\_cloudwatch\_role\_id | The flow log CloudWatch role ID |
| kms\_key\_alias\_arn | Session manager log KMS key alias ARN |
| kms\_key\_alias\_name | Session manager log KMS key alias name |
| kms\_key\_arn | Session manager log KMS key ARN |
| kms\_key\_id | Session manager log KMS key ID |
| kms\_policy\_document | The kms policy JSON document |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

## Contributing and reporting issues

Feel free to create an issue in this repository if you have questions, suggestions or feature requests.

### Validation, linters and pull-requests

We want to provide high quality code and modules. For this reason we are using
several [pre-commit hooks](.pre-commit-config.yaml) and
[GitHub Actions workflow](.github/workflows/main.yml). A pull-request to the
master branch will trigger these validations and lints automatically. Please
check your code before you will create pull-requests. See
[pre-commit documentation](https://pre-commit.com/) and
[GitHub Actions documentation](https://docs.github.com/en/actions) for further
details.


## License

[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)

See [LICENSE](LICENSE) for full details.

    Licensed to the Apache Software Foundation (ASF) under one
    or more contributor license agreements.  See the NOTICE file
    distributed with this work for additional information
    regarding copyright ownership.  The ASF licenses this file
    to you under the Apache License, Version 2.0 (the
    "License"); you may not use this file except in compliance
    with the License.  You may obtain a copy of the License at

      https://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing,
    software distributed under the License is distributed on an
    "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
    KIND, either express or implied.  See the License for the
    specific language governing permissions and limitations
    under the License.
