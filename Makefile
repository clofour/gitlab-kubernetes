.PHONY: init plan deploy destroy

TERRAFORM_DIR := terraform

init:
	cd $(TERRAFORM_DIR) && terraform init

plan:
	cd $(TERRAFORM_DIR) && terraform plan

deploy:
	cd $(TERRAFORM_DIR) && terraform apply

destroy:
	cd $(TERRAFORM_DIR) && terraform destroy
