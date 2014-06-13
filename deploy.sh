#!/bin/bash

# Usage: ./deploy.sh [host]

host="${1:-kbarrett@rack1.metrixmatrix.com}"

# Changed the host keys already from the template lime-noapache
# (they will not need to be changed again)
#ssh-keygen -R "${host#*@}" 2> /dev/null

tar cj . | ssh -o 'StrictHostKeyChecking no' "$host" '
sudo rm -rf ~/chef &&
mkdir ~/chef &&
cd ~/chef &&
tar xj &&
sudo bash install.sh'
