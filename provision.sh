#!/bin/bash
set -e

PUPPET_DIR='/home/pi/puppet'

#sudo apt-get update
#sudo apt-get install git
#sudo apt-get install puppet-common
#sudo apt-get install ruby-dev
#sudo gem install librarian-puppet

git clone http://github.com/ratajczak/pi.git ${PUPPET_DIR}

cd "${PUPPET_DIR}" && librarian-puppet install --clean

sudo /usr/bin/puppet apply --verbose \
  --manifestdir=${PUPPET_DIR}/manifests \
  --modulepath=${PUPPET_DIR}/modules \
  ${PUPPET_DIR}/manifests/pi.pp

