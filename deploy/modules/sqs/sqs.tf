resource "aws_sqs_queue" "sqs" {
  name                      = "${var.name}"
  visibility_timeout_seconds = 150
  redrive_policy = <<EOF
  {
    "maxReceiveCount": "3",
    "deadLetterTargetArn": "${aws_sqs_queue.sqs_dead_letter_queue.arn}"
  }
  EOF
}

resource "aws_sqs_queue" "sqs_dead_letter_queue" {
  name                      = "${var.name}-dead-letter-queue"
  visibility_timeout_seconds = 150
}

