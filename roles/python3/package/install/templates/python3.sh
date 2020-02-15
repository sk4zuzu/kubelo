#!/usr/bin/env bash

set -o errexit -o nounset -o pipefail
set -x

apt-get -q update
apt-get -q install -y python3{,-pip}
apt-get -q clean

# vim:ts=4:sw=4:et:syn=sh:
