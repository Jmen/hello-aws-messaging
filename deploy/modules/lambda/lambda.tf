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

resource "aws_iam_role_policy_attachment" "role_policy_attachment_external" {
    role       = "${aws_iam_role.lambda_role.name}"
    policy_arn = "${var.policy_arn}"
}

resource "aws_iam_role_policy_attachment" "role_policy_attachment_logging" {
  role       = "${aws_iam_role.lambda_role.name}"
  policy_arn = "${aws_iam_policy.lambda_logging_policy.arn}"
}

resource "aws_iam_role_policy_attachment" "role_policy_attachment_xray" {
  role       = "${aws_iam_role.lambda_role.name}"
  policy_arn = "${aws_iam_policy.lambda_xray_policy.arn}"
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

resource "aws_iam_policy" "lambda_logging_policy" {
name = "${aws_iam_role.lambda_role.name}-logging-policy"
path = "/"
policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "logs:CreateLogGroup",
                "logs:CreateLogStream",
                "logs:PutLogEvents"
            ],
            "Resource": "arn:aws:logs:*:*:log-group:/aws/lambda/${aws_iam_role.lambda_role.name}:*"
        }
    ]
}
EOF
}


resource "aws_iam_policy" "lambda_xray_policy" {
  name = "${aws_iam_role.lambda_role.name}-xray-policy"
  path = "/"
  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
              "xray:PutTraceSegments",
              "xray:PutTelemetryRecords"
            ],
            "Resource": "*"
        }
    ]
}
EOF
}