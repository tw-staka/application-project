# This file is a symbolic link

ENVIRONMENT?=staging

.PHONY: all
all: plan

.PHONY: validate
validate:
	@source make.sh && terraform_validate $(ENVIRONMENT)

.PHONY: init
init:
	@source make.sh && terraform_init $(ENVIRONMENT)

.PHONY: plan
plan: init
	@source make.sh && terraform_plan $(ENVIRONMENT)
