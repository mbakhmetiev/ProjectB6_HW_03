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

# create user ansible

sudo useradd -m -s `which bash` ansible
sudo usermod -aG sudo ansible
sudo passwd ansible
sudo -i
echo "ansible ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/ansible
visudo -cf !$
ssh-keygen -b 2048 -t rsa -N "" -f ~/.ssh/id_rsa


#