resource "aws_lb" "apex" {
  name_prefix = var.name_prefix
  internal = false
  load_balancer_type = "network"
  subnets = var.vpc_subnet_ids
  dynamic "subnet_mapping" {
    for_each = zipmap(var.vpc_subnet_ids, length(var.vpc_eip_allocation_ids) > 0 ? var.vpc_eip_allocation_ids : aws_eip.apex[*].id)
    content {
      subnet_id     = subnet_mapping.key
      allocation_id = subnet_mapping.value
    }
  }
}

