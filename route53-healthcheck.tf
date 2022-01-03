resource "aws_route53_health_check" "apex" {
  fqdn              = local.apex_fqdn
  port              = 443
  type              = "HTTPS"
  resource_path     = "/?route53_healthcheck"
  failure_threshold = "5"
  request_interval  = "30"
  regions = [
    "us-east-1",
    "us-west-1",
    "us-west-2",
  ]
  tags = {
    name = var.service_name
  }
}

resource "aws_cloudwatch_metric_alarm" "apex" {
  count               = var.healthcheck_sns_arn != null ? 1 : 0
  alarm_name          = var.service_name
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = 60
  metric_name         = "HealthCheckPercentageHealthy"
  namespace           = "AWS/Route53"
  period              = "60"
  statistic           = "Average"
  threshold           = "80"
  alarm_description   = "R53 health checks for apex-redirect ${var.service_name}"
  alarm_actions       = [var.healthcheck_sns_arn]
  ok_actions          = [var.healthcheck_sns_arn]
  dimensions = {
    HealthCheckId = aws_route53_health_check.apex.id
  }
}
