resource "aws_ecs_task_definition" "apex" {
  family = var.service_name
  container_definitions = jsonencode(
    [
      {
        name      = var.service_name
        image     = "public.ecr.aws/ussba/apex-redirect:v1.1.0"
        essential = true
        cpu       = var.task_cpu
        memory    = var.task_memory
        environment = [
          {
            name  = "REDIRECT_FQDN"
            value = var.redirect_fqdn
          },
          {
            name  = "HSTS_HEADER_VALUE"
            value = var.hsts_header_value
          },
          {
            name  = "AWS_S3_BUCKET_NAME"
            value = var.aws_s3_bucket_name
          },
          {
            name  = "AWS_S3_KEY_FULLCHAIN_PEM"
            value = var.aws_s3_key_fullchain_pem
          },
          {
            name  = "AWS_S3_KEY_PRIVATEKEY_PEM"
            value = var.aws_s3_key_privatekey_pem
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
          {
            containerPort : 443
          },
        ]
      }
  ])
  execution_role_arn       = aws_iam_role.ecs_execution.arn
  task_role_arn            = aws_iam_role.ecs_task.arn
  network_mode             = "awsvpc"
  cpu                      = var.task_cpu
  memory                   = var.task_memory
  requires_compatibilities = ["FARGATE"]
}
