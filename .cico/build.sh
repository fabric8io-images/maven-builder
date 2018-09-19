#!/bin/bash
set -xe

# Make sure we are in the right directory
cd $(dirname $(readlink -f $0))/../
source .cico/setup.sh

setup

build
