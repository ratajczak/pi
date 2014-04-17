#!/bin/bash
set -e

puppet_base='/home/pi/puppet'

#sudo apt-get update
#sudo apt-get install puppet-common
#sudo apt-get install git

git clone http://github.com/ratajczak/pi.git $puppet_base
mkdir $puppet_base/modules
puppet module install adrien-network --modulepath=$puppet_base/modules --version=0.4.1

sudo /usr/bin/puppet apply --verbose \
  --manifestdir=${puppet_base}/manifests \
  --modulepath=${puppet_base}/modules \
  ${puppet_base}/manifests/pi.pp
