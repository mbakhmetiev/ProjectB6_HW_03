#!/usr/bin/bash

# install terraform
sudo snap install terraform --classic

# install ansible
sudo apt-add-repository ppa:ansible/ansible
sudo apt update
sudo apt install ansible

# create ansible config file
cat <<eof>> ansible.cfg
[defaults]
remote_user = ansible
host_key_checking = False
inventory = ./inventory
deprectation_warnings = False
gather_facts = False

[privilege_escalation]
become = True
become_method = sudo
become_user = root
become_ask_pass = False
eof
sudo mv ansible.cfg /etc/ansible/ansible.cfg
