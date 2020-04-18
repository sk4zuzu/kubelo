
SELF := $(patsubst %/,%,$(dir $(abspath $(lastword $(MAKEFILE_LIST)))))
NAME ?= $(shell grep -oP '^cluster_name\s*=\s*\K\w+$$' $(SELF)/kubelo.ini)

EXTRAS_TARGETS := \
metrics \
reboot \
reset \
timesync

export

.PHONY: all

all: kubelo

.PHONY: kubelo

kubelo:
	ansible-playbook -v kubelo.yml

.PHONY: $(EXTRAS_TARGETS)

$(EXTRAS_TARGETS):
	ansible-playbook -v extras/$@.yml

.PHONY: proxy

proxy:
	ssh -F $(SELF)/.ssh/config $(NAME)-proxy -N

.PHONY: kubeconfig

kubeconfig:
	@echo export KUBECONFIG=$(SELF)/.tmp/$(NAME)/kubeconfig

.PHONY: become

become:
	@: $(eval BECOME_ROOT := -t sudo -i)

ssh-%:
	@echo NOTICE: if you have complex hostnames use "\"ssh -F .ssh/config <tab>\"" auto-completion instead
	@ssh -F $(SELF)/.ssh/config $* $(BECOME_ROOT)

# vim:ts=4:sw=4:noet:syn=make:
