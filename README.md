### Проектная работа: Управление конфигурациями (Ansible, Puppet)

1. Создать 3 ВМ в Я.Облаке (минимальная конфигурация: 2vCPU, 2GB RAM, 20 GB HDD): vm1 и vm2 (Ubuntu 20.04), vm3 (Centos 8).  

> будем работать в aws, yandex выдает ошибку `x509: certificate signed by unknown authority`  
> vm1 создадим локально с помощью терраформ, затем с vm1 тераформом создадим  
> vm2 и vm3 и будем работать с ansible оттуда, с машины vm1  
   
- aвторизоваться в aws `$ bash aws_auth.sh <aws_access_key.csv> # ключ нужно предварительно скачать из профиля aws`  
- cоздать vm1
  ```
  $ cd terraform_local
  $ terraform init && terraform apply --auto-approve
  $ terraform output
  node_fqdn = [ "ec2-44-202-17-110.compute-1.amazonaws.com", ]
  ```
- закомитить проект на github и склонировать его на vm1
- установить terraform и ansible - файл setup.sh
- настроить ansible /etc/ansible/ansible.cfg
  ```bash
  cat <<eof>> ansible.cfg
  [defaults]
  remote_user = ansible
  host_key_checking = False
  deprectation_warnings = False
  gather_facts = False

  [privilege_escalation]
  become = True
  become_method = sudo
  become_user = root
  become_ask_pass = False
  eof
  sudo mv ansible.cfg /etc/ansible/ansible.cfg
  ```  


