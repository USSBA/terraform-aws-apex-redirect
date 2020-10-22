# Releases

## v2.0.1

- Bugfix: Terraform fixed a workaround we had in place for a [long-standing bug](https://github.com/terraform-providers/terraform-provider-aws/issues/10494) in aws provider.
  The workaround breaks in aws provider v3.10+, so we are pinning v2.x of this module to aws <3.10

## v2.0.0

- **Terraform 0.13**

## v1.1.0

- Adding variable `log_retention_in_days`

## v1.0.0

- Initial Release
