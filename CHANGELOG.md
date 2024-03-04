# Releases

## v7.0.2
- Redefined examples
- Terraform min version is now 1.6

## v7.0.1
- When the module is used to provision EIPs the name tag will now append a count.index.
- The aws_lambda_permission resource now uses the ARN of the lambda function.

## v7.0.0
- Provider version 5.0 support with a minimal Terraform version of 1.5.

## v6.0.1
- Identified an issue with Terraform and how it records the NLB `subnet_mapping` in state as a result we have added a life-cycle that will ignore `subnet_mapping` changes.
- See the README for clarification.

## v6.0.0
- Access Logging can now be configured.
- Dualstack mode can now be enabled by providing a list of [{ id = $subnet-id, address = $ipv6-address }].

## v5.0.2
- The containers start `command` is now an input variable, but the default value is exactly the same as found in previous versions
- Update Terraform and AWS Provider version capabilities
- Adding variable `desired_count` that will allow you to directly override the default desired count equal to the number of subnets provided
- Adding variable `log_group_name` so that YOU have more control over the log group naming convention

## v4.3.0
- Feature: Add container-level healthchecks to help with self-termination on a wonky SSL state
- Feature: Add Route53 HealthChecks
- Feature: New variable 'healthcheck_sns_arn' to be notified of a failed Route53 HealthCheck

## v4.2.2

- Bugfix: Corrected hardcoded service_name value
- Changed 'monthly_restart_enabled' to be 'apex_restart_enabled' as this happens twice a month.

## v4.2.1

- Adding variable 'monthly_restart_enabled'. This will create a cloudwatch event & lambda function to update the apex redirect service with new containers.

## v4.1.1

- Adding variable 'enable_execute_command'
- Adding variable 'wait_for_steady_state'

## v4.0.1

- Bugfix: Added {uri} to redir directive

## v4.0.0

- *BREAKING:* Switching underlying webserver from nginx to caddy
- *BREAKING:* Caddy will handle issuance of certificates, so S3 configuration is no longer needed
- Certificates will be stored in an EFS drive
- EFS Drive will be created
- You will no longer need to Bring Your Own certificates, in a bucket or otherwise, so consider cleaning up any cert creation/renewal

## v3.1.1

- Image will now be pushed and pulled from an AWS public ECR repository

## v3.1.0

- Support for Terraform versions 0.13 and above to (but not including) 1.0

## v3.0.0

- Removes workaround we had in place [long-standing bug](https://github.com/terraform-providers/terraform-provider-aws/issues/10494) in aws provider.
- Pins aws provider to a minimum of 3.11 (and less than v4).

## v2.0.1

- Bugfix: Terraform fixed a workaround we had in place for a [long-standing bug](https://github.com/terraform-providers/terraform-provider-aws/issues/10494) in aws provider.
  The workaround breaks in aws provider v3.10+, so we are pinning v2.x of this module to aws <3.10

## v2.0.0

- **Terraform 0.13**

## v1.1.0

- Adding variable `log_retention_in_days`

## v1.0.0

- Initial Release
