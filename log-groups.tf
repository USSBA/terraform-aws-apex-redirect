resource "aws_cloudwatch_log_group" "apex" {
  name              = "/fargate/${var.service_name}"
  retention_in_days = var.log_retention_in_days
}
