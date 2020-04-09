
SELF := $(patsubst %/,%,$(dir $(abspath $(lastword $(MAKEFILE_LIST)))))

CLUSTER_NAME := $(shell grep -oP '^cluster_name\s*=\s*\K\w+$$' $(SELF)/kubelo.ini)

export

.PHONY: all

all: kubelo

.PHONY: kubelo

kubelo:
	ansible-playbook -v kubelo.yml

.PHONY: proxy

proxy:
	ssh -F $(SELF)/.ssh/config.d/$(CLUSTER_NAME) $(CLUSTER_NAME)-proxy -N

.PHONY: kubeconfig

kubeconfig:
	@echo export KUBECONFIG=$(SELF)/.tmp/$(CLUSTER_NAME)/kubeconfig

# vim:ts=4:sw=4:noet:syn=make:
