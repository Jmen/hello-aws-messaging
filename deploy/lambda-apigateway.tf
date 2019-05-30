module "hello_messaging_api_gateway_lambda" {
  source            = "./modules/lambda"

  name              = "hello-messaging-apigateway-${var.environment}"
  runtime           = "dotnetcore2.1"
  handler           = "HelloAwsMessaging.ApiGateway::HelloAwsMessaging.ApiGateway.Function::FunctionHandler"
  filename          = "../../../../../../output/apigateway-lambda.zip"
  source_code_hash  = "${base64sha256(file("../../../../../../output/apigateway-lambda.zip"))}"
  attach_optional_policy = true
  policy_arn = "${aws_iam_policy.api_gateway_lambda_policy.arn}"

  environment_variables = {
    "SQS_Queue_Name" = "${module.hello_sqs.name}"
  }
}

resource "aws_iam_policy" "api_gateway_lambda_policy" {
  name = "hello-messaging-apigateway-to-sns-${var.environment}-policy"
  path = "/"
  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "sqs:SendMessage",
                "sqs:GetQueueUrl"
            ],
            "Resource": "${module.hello_sqs.arn}"
        }
    ]
}
EOF
}