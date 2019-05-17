#!/bin/bash
env=$1

terragrunt destroy --terragrunt-working-dir "./deploy/environments/$env/"
