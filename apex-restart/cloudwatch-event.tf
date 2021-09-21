data "archive_file" "apex_restart" {
  type        = "zip"
  source_dir  = "../../apex-restart/functions/"
  output_path = "../../apex-restart/functions/apex_restart.zip"
}

resource "aws_lambda_function" "apex_restart" {
  filename      = "../../apex-restart/functions/apex_restart.zip"
  function_name = var.service_name
  role          = aws_iam_role.apex_restart.arn
  handler       = "apex-restart.lambda_handler"
  runtime       = "python3.9"
  timeout       = 10

  source_code_hash = data.archive_file.apex_restart.output_base64sha256

  environment {
    variables = {
      CLUSTER       = "${var.cluster_name}"
      SERVICE       = "${var.service_name}"
    }
  }
}

resource "aws_iam_role" "apex_restart" {
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
  name   = var.service_name
  path   = "/"
  policy = data.aws_iam_policy_document.apex_restart.json
}

resource "aws_iam_role_policy_attachment" "apex_restart" {
  role       = aws_iam_role.apex_restart.name
  policy_arn = aws_iam_policy.apex_restart.arn
}

resource "aws_cloudwatch_event_rule" "apex_restart" {
  name                = var.service_name
  description         = "triggers lambda that forces a new deployment of ${var.service_name}"
  schedule_expression = "cron(0 5 1,15 * ? *)"
  is_enabled          = true
}

resource "aws_cloudwatch_event_target" "apex_restart" {
  rule      = aws_cloudwatch_event_rule.apex_restart.name
  target_id = aws_lambda_function.apex_restart.id
  arn       = aws_lambda_function.apex_restart.arn
}

resource "aws_lambda_permission" "apex_restart" {
  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.apex_restart.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.apex_restart.arn
}
