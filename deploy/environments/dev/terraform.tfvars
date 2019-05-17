terragrunt = {
    terraform {
        source = "../.."

        extra_arguments "custom_vars" {
        commands = [
            "apply",
            "plan",
            "import",
            "push",
            "refresh",
            "destroy",
        ]
        }
    }
    remote_state {
        backend = "s3"

        config {
            bucket         = "hello-messaging-dev-tfstate"
            key            = "terraform.tfstate"
            region         = "us-east-1"
            encrypt        = true
            dynamodb_table = "terraform-locks"
        }
    }
}

environment = "dev"
count = 2
