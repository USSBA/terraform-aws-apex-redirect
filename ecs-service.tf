resource "aws_ecs_service" "apex" {
  depends_on = [
    aws_lb.apex,
    aws_lb_target_group.apex,
    aws_lb_listener.apex
  ]
  name                               = var.service_name
  cluster                            = var.cluster_name
  task_definition                    = aws_ecs_task_definition.apex.arn
  desired_count                      = length(var.subnet_ids)
  launch_type                        = "FARGATE"
  health_check_grace_period_seconds  = 10
  force_new_deployment               = true
  deployment_minimum_healthy_percent = 100
  deployment_maximum_percent         = 200

  load_balancer {
    target_group_arn = aws_lb_target_group.apex.arn
    container_name   = var.service_name
    container_port   = 80
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.apex_ssl.arn
    container_name   = var.service_name
    container_port   = 443
  }

  network_configuration {
    subnets          = data.aws_subnet.target[*].id
    security_groups  = [aws_security_group.apex.id]
    assign_public_ip = true
  }
}
resource "aws_security_group" "apex" {
  name        = "fargate-${var.service_name}"
  description = "A fargate security group for service ${var.service_name}"
  vpc_id      = data.aws_subnet.target[0].vpc_id
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Allow task into EFS
resource "aws_security_group_rule" "allow_fargate_into_efs" {
  type                     = "ingress"
  from_port                = 2049
  to_port                  = 2049
  protocol                 = "tcp"
  security_group_id        = aws_security_group.efs.id
  source_security_group_id = aws_security_group.apex.id
}
