resource "aws_sqs_queue" "sqs" {
  name                      = "${var.name}"
  delay_seconds             = 5
  max_message_size          = 2048
  message_retention_seconds = 86400
  receive_wait_time_seconds = 10
  visibility_timeout_seconds = 150
}