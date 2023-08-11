resource "aws_eip" "apex" {
  count  = length(var.eip_allocation_ids) > 0 ? 0 : length(var.subnet_ids)
  domain = "vpc"
  tags = {
    Name = var.service_name
  }
}
