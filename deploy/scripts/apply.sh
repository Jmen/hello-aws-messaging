#!/bin/bash
env=$1
 
terragrunt apply --terragrunt-working-dir "./deploy/environments/$env/" "$PWD/deploy/environments/$env/terraform.tfplan"
