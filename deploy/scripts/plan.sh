#!/bin/bash
env=$1

terragrunt plan -out="$PWD/deploy/environments/$env/terraform.tfplan" --terragrunt-working-dir "./deploy/environments/$env/"
