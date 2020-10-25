SELF := $(patsubst %/,%,$(dir $(abspath $(firstword $(MAKEFILE_LIST)))))

INVENTORY ?= $(SELF)/kubelo.ini
NAME      := $(shell grep -oP '^cluster_name\s*=\s*\K\w+$$' $(INVENTORY))

EXTRAS_TARGETS := \
metrics \
reboot \
reset \
reset-node \
timesync

export

.PHONY: all

all: kubelo

.PHONY: kubelo

kubelo:
	ansible-playbook -v -i $(INVENTORY) kubelo.yml

.PHONY: $(EXTRAS_TARGETS)

$(EXTRAS_TARGETS):
	ansible-playbook -v -i $(INVENTORY) extras/$@.yml

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
