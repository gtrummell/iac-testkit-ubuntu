.PHONY: help
.DEFAULT_GOAL := help

# Self-documenting makefile compliments of François Zaninotto http://bit.ly/2PYuVj1

help:
	@echo "Make targets for IAC TestKit on Ubuntu:"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

build-image: test-image ## Build the IAC TestKit for Ubuntu from Dockerfile.
	@docker build . -t gtrummell/iac-testkit-$(shell cat ./DISTRO):$(shell cat ./VERSION) -t gtrummell/iac-testkit-$(shell cat ./DISTRO):latest

global-clean: ## Sanitize the workspace.
	-docker rmi -f gtrummell/iac-testkit-$(shell cat ./DISTRO):latest
	-docker rmi -f gtrummell/iac-testkit-$(shell cat ./DISTRO):$(shell cat ./VERSION)

global-getdeps: ## Retrieve dependencies.
	@docker pull $(shell cat ./DISTRO):$(shell cat ./VERSION)

push-image: ## Push the IAC TestKit for Ubuntu to Dockerhub.
	@docker push gtrummell/iac-testkit-$(shell cat ./DISTRO):latest
	@docker push gtrummell/iac-testkit-$(shell cat ./DISTRO):$(shell cat ./VERSION)

test-dockerfile: global-getdeps ## Test the IAC TestKit for Ubuntu Dockerfile
	@echo "Testing ./Dockerfile with Hadolint (no news is good news)..."
	@docker run -i --rm hadolint/hadolint < ./Dockerfile
