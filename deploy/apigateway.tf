module "hello_messaging_api_gateway" {
  source            = "./modules/api-gateway"

  name              = "hello-messaging-${var.environment}"
  lambda_arn        = "${module.hello_messaging_api_gateway_lambda.arn}"
  lambda_invoke_arn = "${module.hello_messaging_api_gateway_lambda.invoke_arn}"
}