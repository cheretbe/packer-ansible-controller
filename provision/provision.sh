#!/bin/bash

set -euo pipefail

if [ "$UID" != "0" ]; then
  echo "Re-running the script with sudo"
  echo sudo su - root $0 $*
  sudo su - root $0 $*
  exit
fi

# A fix for occasional "Release file is not yet valid" error
# due to invalid time on Windows Virtualbox hosts
timedatectl set-ntp off
timedatectl set-ntp on
sleep 4s

echo "Updating package cache"
apt-get update -y -qq
echo "Installing apt packages"
DEBIAN_FRONTEND=noninteractive apt-get install -y -qq python3-pip sshpass

echo "Upgrading pip3"
# Temporary solution to suppress messages like this:
# WARNING: Value for scheme.scripts does not match ...
# https://github.com/pypa/pip/issues/9617
# https://stackoverflow.com/questions/67244301/warning-messages-when-i-update-pip-or-install-packages/67250419#67250419
python3 -m pip install --disable-pip-version-check pip==21.0.1

echo "Installing Ansible packages using pip3"
pip3 --disable-pip-version-check install ansible pywinrm

# echo "Installing Ansible Galaxy package 'community.windows'"
# ansible-galaxy collection install community.windows

echo "Cleaning up apt cache"
apt-get clean
