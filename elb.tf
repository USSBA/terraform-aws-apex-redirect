resource "aws_lb" "apex" {
  name                             = var.service_name
  internal                         = false
  load_balancer_type               = "network"
  enable_cross_zone_load_balancing = true

  dynamic "subnet_mapping" {
    for_each = zipmap(var.subnet_ids, length(var.eip_allocation_ids) > 0 ? var.eip_allocation_ids : aws_eip.apex[*].id)
    content {
      subnet_id     = subnet_mapping.key
      allocation_id = subnet_mapping.value
    }
  }
}
resource "aws_lb_target_group" "apex" {
  name                 = var.service_name
  port                 = 80
  protocol             = "TCP"
  target_type          = "ip"
  vpc_id               = data.aws_subnet.target[0].vpc_id
  deregistration_delay = 20
}
resource "aws_lb_target_group" "apex_ssl" {
  name                 = "${var.service_name}-ssl"
  port                 = 443
  protocol             = "TCP"
  target_type          = "ip"
  vpc_id               = data.aws_subnet.target[0].vpc_id
  deregistration_delay = 20

  # If var.is_certificate_valid is set to false, then this will set the health_check port to 80
  dynamic "health_check" {
    for_each = var.is_certificate_valid != true ? [80] : []
    content {
      port     = health_check.value
      protocol = "TCP"
    }
  }
}
resource "aws_lb_listener" "apex" {
  load_balancer_arn = aws_lb.apex.arn
  port              = 80
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.apex.arn
  }
}
resource "aws_lb_listener" "apex_ssl" {
  load_balancer_arn = aws_lb.apex.arn
  port              = 443
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.apex_ssl.arn
  }
}
