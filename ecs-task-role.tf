data "aws_iam_policy_document" "ecs_task_principal" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}
resource "aws_iam_role" "ecs_task" {
  name               = "fargate-${var.service_name}-task"
  assume_role_policy = data.aws_iam_policy_document.ecs_task_principal.json
}
resource "aws_iam_role_policy" "ecs_exec" {
  count  = var.enable_execute_command ? 1 : 0
  name   = "${var.service_name}-task-ecs-exec"
  role   = aws_iam_role.ecs_task.id
  policy = data.aws_iam_policy_document.ecs_exec[0].json
}
data "aws_iam_policy_document" "ecs_exec" {
  count = var.enable_execute_command ? 1 : 0

  statement {
    actions = [
      "ssmmessages:CreateControlChannel",
      "ssmmessages:CreateDataChannel",
      "ssmmessages:OpenControlChannel",
      "ssmmessages:OpenDataChannel",
      "logs:DescribeLogGroups",
    ]
    resources = ["*"]
  }
  statement {
    actions = [
      "logs:CreateLogStream",
      "logs:DescribeLogStreams",
      "logs:PutLogEvents"
    ]
    resources = ["${aws_cloudwatch_log_group.apex.arn}:*"]
  }
}
