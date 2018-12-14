.PHONY: help
.DEFAULT_GOAL := help

# Self-documenting makefile compliments of François Zaninotto http://bit.ly/2PYuVj1

distro  := ubuntu
version := $(shell grep VERSION Dockerfile | cut -d\  -f 3)

help:
	@echo "Make targets for IAC Test Kit:"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

build-image: ## Build the IAC Test Kit from Dockerfile
	@docker build . -t gtrummell/iac-testkit-$(distro):$(version) -t gtrummell/iac-testkit-$(distro):latest

clean: ## Sanitize the workspace
	-docker rmi -f gtrummell/iac-testkit-$(distro):latest
	-docker rmi -f gtrummell/iac-testkit-$(distro):$(version)

get-deps: ## Retrieve dependencies
	@docker pull centos:$(version)

push-image: ## Push the IAC Test Kit to Dockerhub
	docker push gtrummell/iac-testkit-$(distro):latest && \
	docker push gtrummell/iac-testkit-$(distro):$(version)

test-dockerfile: ## Test the IAC Test Kit Dockerfile
	@docker run -i --rm hadolint/hadolint < Dockerfile

ci: clean get-deps test-dockerfile build-image ## Run all tests and build an image without pushing it to Dockerhub

cd: ci push-image ## Push the IAC Test Kit to Dockerhub (alias of push-image)
