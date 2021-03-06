SHELL := /bin/bash -euo pipefail
.PHONY: test

## ----------------------------------------------------------------------
## Makefile to run terragrunt commands to setup nodes for polkadot
## ----------------------------------------------------------------------

help: ## Show this help.
	@sed -ne '/@sed/!s/## //p' $(MAKEFILE_LIST)

install-deps-ubuntu:				## Install basics to run node on mac - developers should do it manually
	./scripts/install-deps-ubuntu.sh

install-deps-mac: 					## Install basics to run node on ubuntu - developers should do it manually
	./scripts/install-deps-brew.sh

configs-prompt:						## Prompt user to enter values into configs
	cookiecutter .

configs:				        ## No input generation of config files from config.yaml
	@cookiecutter . --config-file=config.yaml --no-input && echo made configs

clear-cache:	                ## Clear the cache of files left by terragrunt
	@find . -type d -name ".terragrunt-cache" -prune -exec rm -rf {} \; && \
	find . -type d -name ".terraform" -prune -exec rm -rf {} \; && echo 'cleared cache'

clear-configs:	                ## Clear the cache of files left by terragrunt
	@find . -type f -name "*.tfvars" -prune -exec rm {} \; && \
    find . -type f -name "global.yaml" -prune -exec rm {} \; && \
    find . -type f -name "secrets.yaml" -prune -exec rm {} \; && echo 'cleared configs'

#####################
# terragrunt commands
#####################
tg_cmd = terragrunt $(1) --terragrunt-source-update --auto-approve --terragrunt-non-interactive --terragrunt-working-dir $(2)
apply-all-aws:
	$(call tg_cmd,apply-all,polkadot/aws)

destroy-all-aws:
	$(call tg_cmd,destroy-all,polkadot/aws)

test-aws:
	go test ./polkadot/aws/test -v -timeout 45m

##################
# meta git actions
##################
clone-all:	## Clones all the sub repos
	meta git clone .; \
	python scripts/subdir_cmd.py clone_all
