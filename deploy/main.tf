terraform {
  backend "s3" {}
}

provider "aws" {
  access_key = "${var.aws_access_key}"
  secret_key = "${var.aws_secret_key}"
  region     = "us-east-1"
}

variable "environment" {}

module "hello_messaging_api_gateway_lambda" {
  source            = "./modules/lambda"
  
  name              = "hello-messaging-${var.environment}"
  runtime           = "dotnetcore2.1"
  handler           = "HelloAwsMessaging::HelloAwsMessaging.ApiGateway.Function::FunctionHandler"
  filename          = "../../../../../../output/apigateway-lambda.zip"
  source_code_hash  = "${base64sha256(file("../../../../../../output/apigateway-lambda.zip"))}"
}

module "hello_messaging_api_gateway" {
  source            = "./modules/api-gateway"

  name              = "hello-messaging-${var.environment}"
  lambda_arn        = "${module.hello_messaging_api_gateway_lambda.lambda_arn}"
  lambda_invoke_arn = "${module.hello_messaging_api_gateway_lambda.lambda_invoke_arn}"
}
