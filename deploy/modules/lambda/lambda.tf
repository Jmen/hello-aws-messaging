resource "aws_lambda_function" "lambda" {
  function_name = "${var.name}"

  filename         = "${var.filename}"
  source_code_hash = "${var.source_code_hash}"

  role    = "${aws_iam_role.lambda_role.arn}"
  handler = "${var.handler}"
  runtime = "${var.runtime}"
  timeout = "${var.timeout}"
}

resource "aws_iam_role_policy_attachment" "role_policy_attachment" {
    role       = "${aws_iam_role.lambda_role.name}"
    policy_arn = "${aws_iam_policy.lambda_policy.arn}"
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

resource "aws_iam_policy" "lambda_policy" {
    name = "${var.name}-policy"
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
            "Resource": "arn:aws:logs:*:*:log-group:/aws/lambda/${var.name}:*"
        }
    ]
}
EOF
}

