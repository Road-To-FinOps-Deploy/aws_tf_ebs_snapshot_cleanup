data "aws_iam_policy_document" "assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "log_policy" {
  statement {
    actions = [
      "logs:*",
    ]

    resources = [
      "arn:aws:logs:*:*:*",
    ]
  }

  statement {
    actions = [
      "ec2:Describe*",
    ]

    resources = [
      "*",
    ]
  }

  statement {
    actions = [
      "ec2:CreateSnapshot",
      "ec2:ModifySnapshotAttribute",
      "ec2:DeleteSnapshot",
      "ec2:ResetSnapshotAttribute",
    ]

    resources = [
      "*",
    ]
  }
}

resource "aws_iam_policy" "log_policy" {
  name   = "ebs_lambda_role"
  path   = "/"
  policy = data.aws_iam_policy_document.log_policy.json
}

resource "aws_iam_role" "ebs_lambda_role" {
  name               = "ebs_lambda_role"
  assume_role_policy = data.aws_iam_policy_document.assume_role_policy.json
}

resource "aws_iam_policy_attachment" "log_policy_attachment" {
  name       = "cloudwatch-policy-attachment"
  policy_arn = aws_iam_policy.log_policy.arn
  roles      = [aws_iam_role.ebs_lambda_role.name]
}

resource "aws_iam_instance_profile" "lambda_profile" {
  name = "ebs_lambda_role"
  role = aws_iam_role.ebs_lambda_role.name
}

