module "hello_messaging_sns_to_kinesis_lambda" {
  source            = "./modules/lambda"

  name              = "hello-messaging-sns-to-kinesis-${var.environment}"
  runtime           = "dotnetcore2.1"
  handler           = "HelloAwsMessaging.SnsToKinesis::HelloAwsMessaging.SnsToKinesis.Function::FunctionHandler"
  filename          = "../../../../../../output/sns-to-kinesis-lambda.zip"
  source_code_hash  = "${base64sha256(file("../../../../../../output/sns-to-kinesis-lambda.zip"))}"
  policy_arn = "${aws_iam_policy.sns_to_kinesis_lambda_policy.arn}"

  environment_variables = {
    "SQS_Queue_Name" = "${module.hello_sqs.name}"
  }
}

resource "aws_iam_policy" "sns_to_kinesis_lambda_policy" {
  name = "hello-messaging-sns-to-kinesis-${var.environment}-policy"
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
            "Resource": "arn:aws:logs:*:*:log-group:/aws/lambda/hello-messaging-sns-to-kinesis-${var.environment}:*"
        }
    ]
}
EOF
}