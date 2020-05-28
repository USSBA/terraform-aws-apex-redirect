output "network_lb" {
  value = aws_lb.apex
}

output "ip" {
  value = length(var.eip_allocation_ids) == 0 ? aws_eip.apex : []
}
