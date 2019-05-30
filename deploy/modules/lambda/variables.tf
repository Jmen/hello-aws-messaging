variable "name" {}

variable "filename" {}

variable "source_code_hash" {}

variable "runtime" {}

variable "handler" {}

variable "timeout" {
    default = 60
}

variable "attach_optional_policy" {
    default = false
}

variable "policy_arn" {
    default = ""
}

variable "environment_variables" { type = "map" }