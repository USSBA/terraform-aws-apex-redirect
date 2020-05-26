resource "aws_eip" "apex" {
  count = length(var.vpc_eip_allocation_ids) > 0 ? 0 : length(var.vpc_subnet_ids)
  vpc = true
  tags = {
    Name = "${var.name_prefix}-${count.index}"
  }
}

