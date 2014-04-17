#!/bin/bash
set -e

sudo apt-get update;
sudo apt-get install puppet-common;
sudo apt-get install git;

git clone http://github.com/ratajczak/pi.git ~/puppet 
puppet module install adrien-network;

puppet_base='./'
to_provision='./manifests/pi.pp'

sudo /usr/bin/puppet apply --verbose \
  --manifestdir=${puppet_base}/manifests \
  --modulepath=${puppet_base}/modules \
  ${to_provision}
