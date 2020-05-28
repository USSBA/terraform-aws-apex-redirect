data "aws_region" "current" {}

data "aws_caller_identity" "current" {}

data "aws_subnet" "target" {
  count = length(var.subnet_ids)
  id    = var.subnet_ids[count.index]
}

locals {
  region     = data.aws_region.current.name
  account_id = data.aws_caller_identity.current.account_id
}
