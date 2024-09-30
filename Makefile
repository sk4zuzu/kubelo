SHELL := $(shell which bash)
SELF  := $(patsubst %/,%,$(dir $(abspath $(firstword $(MAKEFILE_LIST)))))

INVENTORY ?= $(SELF)/kubelo.ini
NAME      := $(shell grep -oP '^cluster_name\s*=\s*\K\w+$$' $(INVENTORY))

export

.PHONY: all

all: kubelo

.PHONY: kubelo preinstall

kubelo:
	cd $(SELF)/ && ansible-playbook -v -i $(INVENTORY) kubelo.yml

preinstall:
	cd $(SELF)/ && ansible-playbook -v -i $(INVENTORY) -t preinstall kubelo.yml

.PHONY: kc kubeconfig

kc kubeconfig:
	@echo export KUBECONFIG=$(SELF)/.tmp/$(NAME)/kubeconfig

.PHONY: become

become:
	@: $(eval BECOME_ROOT := -t sudo -i)

ssh-%:
	@echo NOTICE: if you have complex hostnames use "\"ssh -F .ssh/config <tab>\"" auto-completion instead
	@ssh -F $(SELF)/.ssh/config $* $(BECOME_ROOT)
