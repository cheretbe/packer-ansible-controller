#!/bin/bash

set -euo pipefail

# A fix for occasional "Release file is not yet valid" error
# due to invalid time on Windows Virtualbox hosts
echo "Forcing time sync"
/usr/bin/sudo -n -- sh -c "timedatectl set-ntp off"
/usr/bin/sudo -n -- sh -c "timedatectl set-ntp on"
sleep 4s

echo "Updating package cache"
/usr/bin/sudo -n -- sh -c "DEBIAN_FRONTEND=noninteractive /usr/bin/apt-get -qq update"
echo "Installing sshpass package"
/usr/bin/sudo -n -- sh -c "DEBIAN_FRONTEND=noninteractive apt-get install -y -qq sshpass"

# Temporary fix for this:
# https://bugs.launchpad.net/ubuntu/+source/virtualbox/+bug/1939168
if [[ $(dpkg-query -W -f='${Version}' virtualbox-guest-utils) = "6.1.22-dfsg-2~ubuntu1.20.04.1" ]]; then
  echo "Downgrading 'virtualbox-guest-utils' package"
  /usr/bin/sudo -n -- sh -c "DEBIAN_FRONTEND=noninteractive apt-get install -y -qq --allow-downgrades virtualbox-guest-utils=6.1.16-dfsg-6~ubuntu1.20.04.2"
  /usr/bin/sudo -n -- sh -c "DEBIAN_FRONTEND=noninteractive apt-mark hold virtualbox-guest-utils"
fi

if [ ! -d ${HOME}/.cache/venv/ansible ]; then
  echo "Creating venv"
  /usr/bin/curl -s https://raw.githubusercontent.com/cheretbe/bootstrap/master/setup_venv.py?flush_cache=True \
    | /usr/bin/python3 - ansible --batch-mode
fi

echo "Installing pip packages"
(
  . ${HOME}/.cache/venv/ansible/bin/activate
  pip3 install ansible pywinrm
  pip3 cache purge
)
# # echo "Installing Ansible Galaxy package 'community.windows'"
# # ansible-galaxy collection install community.windows

echo "Cleaning up apt cache"
/usr/bin/sudo -n -- sh -c "apt-get clean"

grep -qxF 'PATH="$HOME/.cache/venv/ansible/bin:$PATH"' /home/vagrant/.bashrc || echo -e '\nPATH="$HOME/.cache/venv/ansible/bin:$PATH"' >>/home/vagrant/.profile
