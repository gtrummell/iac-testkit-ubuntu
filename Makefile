.PHONY: help
.DEFAULT_GOAL := help

# Self-documenting makefile compliments of François Zaninotto http://bit.ly/2PYuVj1

help:
	@echo "Make targets for IAC TestKit:"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

build-image: test-image ## Build the IAC TestKit for Ubuntu from Dockerfile.
	@docker build . -t gtrummell/iac-testkit-$(shell cat ./DISTRO):$(shell cat ./VERSION) -t gtrummell/iac-testkit-$(shell cat ./DISTRO):latest

get-dockerfile: ## Get the current buildable Dockerfile.
	-head -n2 ./Dockerfile
	-echo $(shell cat ./DISTRO)
	-echo $(shell cat ./VERSION)

global-clean: ## Sanitize the workspace.
	-docker rmi -f gtrummell/iac-testkit-$(shell cat ./DISTRO):latest:latest
	-docker rmi -f gtrummell/iac-testkit-$(shell cat ./DISTRO):$(shell cat ./VERSION)
	-rm -f ./DISTRO ./VERSION

global-getdeps: ## Retrieve dependencies.
	@docker pull $(shell cat ./DISTRO):$(shell cat ./VERSION)

push-image: ## Push the IAC TestKit for Ubuntu to Dockerhub.
	@docker push gtrummell/iac-testkit-$(shell cat ./DISTRO):latest
	@docker push gtrummell/iac-testkit-$(shell cat ./DISTRO):$(shell cat ./VERSION)

set-dockerfile-ubuntu: global-clean ## Set the current buildable dockerfile to Ubuntu.
	@cp -f Dockerfile-ubuntu Dockerfile
	@echo ubuntu > ./DISTRO
	@echo 18.04 > ./VERSION

test-image: global-getdeps ## Test the IAC TestKit for Ubuntu Dockerfile
	@echo "Testing ./Dockerfile with Haldolint (no news is good news)..."
	@docker run --rm -i hadolint/hadolint < ./Dockerfile
