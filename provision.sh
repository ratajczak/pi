#!/bin/bash
set -e

PUPPET_DIR='/home/pi/puppet'

echo "Installing dependencies"
sudo apt-get update
sudo apt-get install -y git
sudo apt-get install -y puppet-common
sudo apt-get install -y ruby-dev
echo "Installing librarian-puppet"
sudo gem install librarian-puppet

echo "Clonning puppet files"
git clone http://github.com/ratajczak/pi.git ${PUPPET_DIR}

echo "Istalling puppet modules"
cd "${PUPPET_DIR}" && librarian-puppet install --clean

echo "Running pi.pp"
sudo /usr/bin/puppet apply --verbose \
  --manifestdir=${PUPPET_DIR}/manifests \
  --modulepath=${PUPPET_DIR}/modules \
  ${PUPPET_DIR}/manifests/pi.pp

