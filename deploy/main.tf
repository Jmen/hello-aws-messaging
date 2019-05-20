terraform {
  backend "s3" {}
}

provider "aws" {
  access_key = "${var.aws_access_key}"
  secret_key = "${var.aws_secret_key}"
  region     = "us-east-1"
}

variable "environment" {}

module "hello_messaging_api_gateway" {
  source            = "./modules/api-gateway"

  name              = "hello-messaging-${var.environment}"
  lambda_arn        = "${module.hello_messaging_api_gateway_lambda.arn}"
  lambda_invoke_arn = "${module.hello_messaging_api_gateway_lambda.invoke_arn}"
}

module "hello_messaging_api_gateway_lambda" {
  source            = "./modules/lambda"
  
  name              = "hello-messaging-apigateway-${var.environment}"
  runtime           = "dotnetcore2.1"
  handler           = "HelloAwsMessaging.ApiGateway::HelloAwsMessaging.ApiGateway.Function::FunctionHandler"
  filename          = "../../../../../../output/apigateway-lambda.zip"
  source_code_hash  = "${base64sha256(file("../../../../../../output/apigateway-lambda.zip"))}"
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
                "logs:CreateLogGroup",
                "logs:CreateLogStream",
                "logs:PutLogEvents"
            ],
            "Resource": "arn:aws:logs:*:*:log-group:/aws/lambda/hello-messaging-apigateway-${var.environment}:*"
        },
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

module "hello_sqs" {
  source = "./modules/sqs"

  name = "hello-sqs-${var.environment}"
}

resource "aws_lambda_event_source_mapping" "sqs_event_source_mapping" {
  batch_size        = 10
  event_source_arn  = "${module.hello_sqs.arn}"
  function_name     = "${module.hello_messaging_sqs_to_sns_lambda.arn}"
  enabled           = true
}

module "hello_messaging_sqs_to_sns_lambda" {
  source            = "./modules/lambda"

  name              = "hello-messaging-sqs-to-sns-${var.environment}"
  runtime           = "dotnetcore2.1"
  handler           = "HelloAwsMessaging.SqsToSns::HelloAwsMessaging.SqsToSns.Function::FunctionHandler"
  filename          = "../../../../../../output/sqs-to-sns-lambda.zip"
  source_code_hash  = "${base64sha256(file("../../../../../../output/sqs-to-sns-lambda.zip"))}"
  policy_arn = "${aws_iam_policy.sqs_to_sns_lambda_policy.arn}"

  environment_variables = {
    "SQS_Queue_Name" = "${module.hello_sqs.name}"
  }
}

resource "aws_iam_policy" "sqs_to_sns_lambda_policy" {
  name = "hello-messaging-sqs-to-sns-${var.environment}-policy"
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
            "Resource": "arn:aws:logs:*:*:log-group:/aws/lambda/hello-messaging-sqs-to-sns-${var.environment}:*"
        },
        {
            "Effect": "Allow",
            "Action": [
              "sqs:ReceiveMessage",
              "sqs:DeleteMessage",
              "sqs:GetQueueAttributes",
              "sqs:ChangeMessageVisibility"
            ],
            "Resource": "${module.hello_sqs.arn}"
        }
    ]
}
EOF
}