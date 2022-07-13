resource "aws_cloudwatch_log_group" "apex" {
  name              = var.log_group_name
  retention_in_days = var.log_retention_in_days
}
