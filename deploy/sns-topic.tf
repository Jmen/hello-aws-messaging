resource "aws_sns_topic" "hello-sns" {
  name = "hello-sns-${var.environment}"
}

resource "aws_sns_topic_subscription" "lambda" {
  topic_arn = "${aws_sns_topic.hello-sns.arn}"
  protocol  = "lambda"
  endpoint  = "${module.hello_messaging_sns_to_kinesis_lambda.arn}"
}

resource "aws_lambda_permission" "sns" {
  statement_id  = "AllowExecutionFromSNS"
  action        = "lambda:InvokeFunction"
  function_name = "${module.hello_messaging_sns_to_kinesis_lambda.name}"
  principal     = "sns.amazonaws.com"
  source_arn = "${aws_sns_topic.hello-sns.arn}"
}