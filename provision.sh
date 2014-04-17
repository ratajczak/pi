#!/bin/bash
set -e

sudo apt-get update;
sudo apt-get install puppet-common;
sudo apt-get install git;

git clone http://github.com/ratajczak/pi.git ~/puppet 
mkdir ${puppet_base}/modules;
puppet module install adrien-network --modulepath=${puppet_base}/modules --version=0.4.1;

puppet_base='./'
to_provision='./manifests/pi.pp'

sudo /usr/bin/puppet apply --verbose \
  --manifestdir=${puppet_base}/manifests \
  --modulepath=${puppet_base}/modules \
  ${to_provision}
