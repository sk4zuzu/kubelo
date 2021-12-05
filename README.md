SIMPLE KUBERNETES HA CLUSTER DEPLOYMENT (ANSIBLE)
=================================================

## 1. PURPOSE

Just a devops exercise.

Supported platforms:
- Existing on-premise Ubuntu Linux clusters
- Existing Ubuntu-based AWS EC2 instances (+ AWS cloud-provider)

Deploys in ~10 minutes.

## 2. REUSE CLUSTER NODE AS A BASTION

Let's say we want to reuse `k1a1` (10.30.2.10) as a bastion host `b1` (it cannot be `k1a1` used directly):

```dosini
[all:vars]
cluster_name=k1
ansible_user=ubuntu
cloud_provider=
extra_server_cert_sans=["localhost"]
ansible_python_interpreter=/usr/bin/python3

[bastion]
b1 ansible_host=10.30.2.10

[etcd]
k1a1
k1a2
k1a3

[master]
k1a1
k1a2
k1a3

[compute]
k1b1
k1b2
k1b3
```
