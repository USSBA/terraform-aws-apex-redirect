data "aws_region" "current" {}

data "aws_caller_identity" "current" {}

data "aws_subnet" "target" {
  count = length(var.subnet_ids)
  id    = var.subnet_ids[count.index]
}

locals {
  region                 = data.aws_region.current.name
  account_id             = data.aws_caller_identity.current.account_id
  container_storage_path = "/efs"
  apex_fqdn              = length(var.apex_fqdn) > 0 ? var.apex_fqdn : join(".", slice(split(".", var.redirect_fqdn), 1, length(split(".", var.redirect_fqdn))))
}
