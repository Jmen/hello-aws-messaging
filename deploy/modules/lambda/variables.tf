variable "name" {}

variable "filename" {}

variable "source_code_hash" {}

variable "runtime" {}

variable "handler" {}

variable "timeout" {
    default = 60
}

variable "policy_arn" {}

variable "environment_variables" { type = "map" }