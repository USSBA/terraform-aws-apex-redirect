resource "aws_cloudwatch_log_group" "apex" {
  name = "/fargate/${var.service_name}"
}
