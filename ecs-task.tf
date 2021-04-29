resource "aws_ecs_task_definition" "apex" {
  family = var.service_name
  container_definitions = jsonencode(
    [
      {
        name        = var.service_name
        image       = "caddy:latest"
        essential   = true
        cpu         = var.task_cpu
        memory      = var.task_memory
        stopTimeout = 5
        environment = [
          {
            name  = "APEX_DOMAIN"
            value = local.apex_fqdn
          },
          {
            name  = "REDIRECT_DOMAIN"
            value = var.redirect_fqdn
          },
          {
            name  = "HSTS_HEADER_VALUE"
            value = var.hsts_header_value
          },
          {
            name  = "XDG_DATA_HOME"
            value = local.container_storage_path
          },
        ]
        logConfiguration = {
          logDriver = "awslogs"
          options = {
            awslogs-group         = aws_cloudwatch_log_group.apex.name
            awslogs-region        = local.region
            awslogs-stream-prefix = "caddy"
          }
        }
        portMappings = [
          { containerPort : 80 },
          { containerPort : 443 },
        ]
        mountPoints = [{
          sourceVolume  = "efs"
          readOnly      = false
          containerPath = local.container_storage_path
        }]

        command = [
          "/bin/sh",
          "-c",
          <<COMMAND
            echo -e "$APEX_DOMAIN
              header Strict-Transport-Security $HSTS_HEADER_VALUE
              redir https://$REDIRECT_DOMAIN 301" > /etc/caddy/Caddyfile && \
            caddy run --config /etc/caddy/Caddyfile --adapter caddyfile
          COMMAND
        ]
      }
  ])
  execution_role_arn       = aws_iam_role.ecs_execution.arn
  task_role_arn            = aws_iam_role.ecs_task.arn
  network_mode             = "awsvpc"
  cpu                      = var.task_cpu
  memory                   = var.task_memory
  requires_compatibilities = ["FARGATE"]
  volume {
    name = "efs"
    efs_volume_configuration {
      file_system_id     = aws_efs_file_system.efs.id
      root_directory     = "/"
      transit_encryption = "ENABLED"
    }
  }
}
