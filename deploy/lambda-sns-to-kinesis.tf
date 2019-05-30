module "hello_messaging_sns_to_kinesis_lambda" {
  source            = "./modules/lambda"

  name              = "hello-messaging-sns-to-kinesis-${var.environment}"
  runtime           = "dotnetcore2.1"
  handler           = "HelloAwsMessaging.SnsToKinesis::HelloAwsMessaging.SnsToKinesis.Function::FunctionHandler"
  filename          = "../../../../../../output/sns-to-kinesis-lambda.zip"
  source_code_hash  = "${base64sha256(file("../../../../../../output/sns-to-kinesis-lambda.zip"))}"

  environment_variables = {
    "SQS_Queue_Name" = "${module.hello_sqs.name}"
  }
}