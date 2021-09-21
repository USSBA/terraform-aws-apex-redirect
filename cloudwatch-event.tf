data "archive_file" "apex_restart" {
  count       = var.monthly_restart_enabled ? 1 : 0
  type        = "zip"
  source_dir  = "../../functions/"
  output_path = "../../functions/apex_restart.zip"
}

resource "aws_lambda_function" "apex_restart" {
  count         = var.monthly_restart_enabled ? 1 : 0
  filename      = "../../functions/apex_restart.zip"
  function_name = var.service_name
  role          = aws_iam_role.apex_restart[count.index].arn
  handler       = "apex-restart.lambda_handler"
  runtime       = "python3.9"
  timeout       = 10

  source_code_hash = data.archive_file.apex_restart[count.index].output_base64sha256

  environment {
    variables = {
      CLUSTER       = "${var.cluster_name}"
      SERVICE       = "${var.service_name}"
      DESIRED_COUNT = length(var.subnet_ids)
    }
  }
}

resource "aws_iam_role" "apex_restart" {
  count = var.monthly_restart_enabled ? 1 : 0
  name  = var.service_name

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow"
    }
  ]
}
EOF
}

data "aws_iam_policy_document" "apex_restart" {
  count = var.monthly_restart_enabled ? 1 : 0
  statement {
    sid = "1"

    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]

    resources = [
      "arn:aws:logs:*:*:*",
    ]
  }
  statement {
    sid = "2"

    actions = [
      "ecs:*"
    ]

    resources = [
      "*"
    ]
  }
  statement {
    sid = "3"

    actions = [
      "iam:PassRole"
    ]

    resources = [
      "*"
    ]
  }
}

resource "aws_iam_policy" "apex_restart" {
  count  = var.monthly_restart_enabled ? 1 : 0
  name   = var.service_name
  path   = "/"
  policy = data.aws_iam_policy_document.apex_restart[count.index].json
}

resource "aws_iam_role_policy_attachment" "apex_restart" {
  count      = var.monthly_restart_enabled ? 1 : 0
  role       = aws_iam_role.apex_restart[count.index].name
  policy_arn = aws_iam_policy.apex_restart[count.index].arn
}

resource "aws_cloudwatch_event_rule" "apex_restart" {
  count               = var.monthly_restart_enabled ? 1 : 0
  name                = var.service_name
  description         = "triggers lambda that forces a new deployment of ${var.service_name}"
  schedule_expression = "cron(0 5 1 * ? *)"
  is_enabled          = true
}

resource "aws_cloudwatch_event_target" "apex_restart" {
  count     = var.monthly_restart_enabled ? 1 : 0
  rule      = aws_cloudwatch_event_rule.apex_restart[count.index].name
  target_id = aws_lambda_function.apex_restart[count.index].id
  arn       = aws_lambda_function.apex_restart[count.index].arn
}

resource "aws_lambda_permission" "apex_restart" {
  count         = var.monthly_restart_enabled ? 1 : 0
  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.apex_restart[count.index].function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.apex_restart[count.index].arn
}
