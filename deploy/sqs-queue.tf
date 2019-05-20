module "hello_sqs" {
  source = "./modules/sqs"

  name = "hello-sqs-${var.environment}"
}