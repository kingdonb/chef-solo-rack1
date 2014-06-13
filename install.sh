#!/bin/bash

# This runs as root on the server

chef_binary=/usr/local/rvm/gems/ruby-2.1.2/bin/chef-solo
rvm_profile=/etc/profile.d/rvm.sh
if [ -f $rvm_profile ]; then
  . $rvm_profile
else
  echo "This script is intended for a system already bootstrapped with rvm"
  # Todo: investigate "omnibus"
  exit 1
fi

export rvmsudo_secure_path=1
# Are we on a vanilla system?
if ! test -f "$chef_binary"; then
  export DEBIAN_FRONTEND=noninteractive
  aptitude update && apt-get -o Dpkg::Options::="--force-confnew" \
    --force-yes -fuy dist-upgrade &&
  apt-get autoremove --purge -y ruby1.9.1 ruby1.9.1-dev &&
  apt-get autoremove --purge -y &&
  rvmsudo gem install --no-rdoc --no-ri chef --version 11.12.8
fi &&

"$chef_binary" -c solo.rb -j solo.json
