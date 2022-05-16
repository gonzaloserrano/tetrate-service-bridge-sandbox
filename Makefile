# Copyright (c) Tetrate, Inc 2021 All Rights Reserved.
# 
# Default variables
cluster_id = 1
# Functions
azure_jumpbox:
	terraform init
	terraform apply -auto-approve -target=module.azure_base
	terraform apply -auto-approve -target=module.azure_jumpbox
azure_k8s:
	terraform init
	terraform apply -auto-approve -target=module.azure_base
	terraform apply -auto-approve -target=module.azure_jumpbox
	terraform apply -auto-approve -target=module.azure_k8s
tsb_deps:
	terraform init
	terraform apply -auto-approve -target=module.cert-manager
	terraform apply -auto-approve -target=module.es
	terraform apply -auto-approve -target=module.argocd
tsb_mp:
	terraform init
	terraform apply -auto-approve -target=module.tsb_mp
	terraform apply -auto-approve -target=module.aws_dns
tsb_fqdn:
	terraform apply -auto-approve -target=module.aws_dns
tsb_cp:
	@echo cluster_id is ${cluster_id}
	terraform init
	terraform taint "module.tsb_cp.null_resource.jumpbox_tctl"
	terraform apply -auto-approve -target=module.tsb_cp -var=cluster_id=${cluster_id}
app_bookinfo:
	@echo cluster_id is ${cluster_id}
	terraform init
	terraform apply -auto-approve -target=module.app_bookinfo
azure_oidc:
	terraform init
	terraform apply -auto-approve -target=module.azure_oidc
destroy:
	terraform destroy -auto-approve -target=module.aws_dns
	terraform destroy -auto-approve -target=module.azure_k8s
	terraform destroy -auto-approve -target=module.azure_base
	terraform destroy -auto-approve -target=module.azure_jumpbox
	terraform destroy -auto-approve
	terraform destroy 