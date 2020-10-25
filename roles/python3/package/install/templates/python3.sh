#!/usr/bin/env bash

set -o errexit -o nounset -o pipefail
set -x

apt-get -q update
apt-get -q install -y python3{,-pip}
apt-get -q clean
