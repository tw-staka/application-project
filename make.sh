#!/usr/bin/env bash
# This file is a symbolic link
function terraform_validate() {
  echo "Running terraform validate"
  terraform validate -var-file $1.tfvars
}

function terraform_init() {
  echo "Running terraform validate before init"
  terraform_validate $1
  echo "Running terraform init"
  PROJECT_ID=`extract_project_id $1`
  terraform init -backend-config=bucket=$PROJECT_ID -reconfigure
}

function terraform_plan() {
  echo "Running terraform plan as a developer"
  # We use -lock=false to run terraform plan locally, this is to test your terraform code
  terraform plan -var-file $1.tfvars -lock=false
}

function extract_project_id() {
	grep project_id $1.tfvars | grep -o \".\*\" | tr -d \"
}

function terraform_apply() {
  echo "Running terraform apply"
  terraform apply -var-file $1.tfvars
}
function terraform_apply_ci() {
  echo "Running terraform apply"
  terraform apply -auto-approve -input=false -var-file $1.tfvars
}
function terraform_destroy() {
  echo "Running terraform destroy"
  terraform destroy -var-file $1.tfvars
}
