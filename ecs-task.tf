resource "aws_ecs_task_definition" "apex" {
  family = var.service_name
  container_definitions = jsonencode(
    [
      {
        name      = var.service_name
        image     = "ussba/apex-redirect:v1.0"
        essential = true
        cpu       = var.task_cpu
        memory    = var.task_memory
        environment = [
          {
            name  = "REDIRECT_FQDN"
            value = var.redirect_fqdn
          },
        ]
        logConfiguration = {
          logDriver = "awslogs"
          options = {
            awslogs-group         = aws_cloudwatch_log_group.apex.name
            awslogs-region        = local.region
            awslogs-stream-prefix = "nginx"
          }
        }
        portMappings = [
          {
            containerPort : 80
          },
        ]
      }
  ])
  execution_role_arn       = aws_iam_role.ecs_execution.arn
  network_mode             = "awsvpc"
  cpu                      = var.task_cpu
  memory                   = var.task_memory
  requires_compatibilities = ["FARGATE"]
}

