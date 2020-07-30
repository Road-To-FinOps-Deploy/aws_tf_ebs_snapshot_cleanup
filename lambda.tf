resource "aws_lambda_function" "build_lambda" {
  filename         = "${path.module}/source/ebs_snapshot_cleanup.zip"
  function_name    = "${var.function_prefix}ebs_clean_weekly"
  role             = aws_iam_role.ebs_lambda_role.arn
  handler          = "ebs_snapshot_cleanup.lambda_handler"
  source_code_hash = data.archive_file.ebs_clean_zip.output_base64sha256
  runtime          = "python2.7"
  timeout          = "30"

  environment {
    variables = {
      ACCOUNT_ID = data.aws_caller_identity.current.id
    }
  }
}

data "archive_file" "ebs_clean_zip" {
  type        = "zip"
  source_file = "${path.module}/source/ebs_snapshot_cleanup.py"
  output_path = "${path.module}/source/ebs_snapshot_cleanup.zip"
}

resource "aws_lambda_permission" "allow_cloudwatch_ebs_clean" {
  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.build_lambda.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.ebs_clean_cloudwatch_rule.arn

  depends_on = [aws_lambda_function.build_lambda]
}

resource "aws_cloudwatch_event_rule" "ebs_clean_cloudwatch_rule" {
  name                = "ebs_clean_lambda_trigger"
  schedule_expression = var.snapshot_cleanup_cron
}

resource "aws_cloudwatch_event_target" "ebs_clean_lambda" {
  rule      = aws_cloudwatch_event_rule.ebs_clean_cloudwatch_rule.name
  target_id = "lambda_target"
  arn       = aws_lambda_function.build_lambda.arn
}

