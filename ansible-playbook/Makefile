ANSIBLE_LOG_PATH ?= ./logs/ansible-$$(date +%Y%m%d-%H%M%S).log

export ANSIBLE_CONFIG := ./ansible.cfg

define _printhelp
	@echo '--------------------------------------------------'; \
	echo '  $(1) tools'; \
	echo '--------------------------------------------------'; \
	grep -hE '^[a-zA-Z_-]+:.*?## \[.*$(1).*\] .*$$' $(MAKEFILE_LIST) | sed -E 's/ \[.*$(1).*\]//g' |awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m: %s\n", $$1, $$2}'
endef

define _run_Playbook
	@mkdir -p $(shell dirname $(ANSIBLE_LOG_PATH)); \
	ANSIBLE_LOG_PATH=$(ANSIBLE_LOG_PATH) \
	ansible-playbook -i ./hosts.yml "./$(1)" $(2) $(ANSIBLE_EXTRA_OPTIONS)
endef

.PHONY : help
help: ## [common] show list
	@$(call _printhelp,common)
	@$(call _printhelp,install)
	@$(call _printhelp,development)

.PHONY : install-server
install-server: ## [install] install minecraft server from ECS
	@$(call _run_Playbook,install/playbook_install_server.yml,)

.PHONY : build
build: ## [development] build docker image
	@docker build --tag ansible-test --target installed .

.PHONY : run-local
run-local: build ## [development] run ansible playbook in docker container
	@docker run --rm -it ansible-test bash

.PHONY : syntax-check
syntax-check: ## [development] syntax check all playbooks
	ansible-playbook -i hosts.yml --syntax-check $(shell find . -name 'playbook_*.yml')

.PHONY : generate-ansible-requirements
generate-ansible-requirements: ## [development] generate ansible collection requirements
	@echo "# Generated Ansible Collection Requirements" > requirements.yml; \
	echo "---" >> requirements.yml; \
	find install/roles -path '*/tasks/*.yml' | xargs cat | \
	yq -sy '{"collections":[.[].[] | keys[] | split(".")[0:2] | select(length > 1) | join(".") | select(. != "ansible.builtin")] | unique}' | \
	tee -a requirements.yml
