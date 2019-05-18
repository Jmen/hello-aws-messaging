output "arn" {
  value  = "${aws_sqs_queue.sqs.arn}"
}

output "name" {
  value  = "${aws_sqs_queue.sqs.name}"
}