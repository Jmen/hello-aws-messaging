resource "aws_lambda_function" "lambda" {
  function_name = "${var.name}"

  filename         = "${var.filename}"
  source_code_hash = "${var.source_code_hash}"

  role    = "${aws_iam_role.lambda_role.arn}"
  handler = "${var.handler}"
  runtime = "${var.runtime}"
  timeout = "${var.timeout}"
  
  tracing_config {
    mode = "Active"
  }
  
  environment {
    variables = "${var.environment_variables}"
  }
}

resource "aws_iam_role_policy_attachment" "role_policy_attachment" {
    role       = "${aws_iam_role.lambda_role.name}"
    policy_arn = "${var.policy_arn}"
}

resource "aws_iam_role" "lambda_role" {
        name = "${var.name}-role"
        assume_role_policy = <<EOF
{   
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

