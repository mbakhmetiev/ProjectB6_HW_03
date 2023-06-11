### Проектная работа: Управление конфигурациями (Ansible, Puppet)

1. Создать 3 ВМ в Я.Облаке (минимальная конфигурация: 2vCPU, 2GB RAM, 20 GB HDD): vm1 и vm2 (Ubuntu 20.04), vm3 (Centos 8).  
2. Установить на vm1 Ansible.
3. Создать на vm1 пользователя для Ansible.
4. Настроить авторизацию по ключу для этого пользователя с vm1 на vm2 и vm3.
5. Добавить в inventory информацию о созданных машинах. vm2 и vm3 должны быть в группе app, vm1 — в группе database и web.

> будем работать в aws, yandex выдает ошибку `x509: certificate signed by unknown authority`  
> vm1 создадим локально с помощью терраформ, затем с vm1 тераформом создадим  
> vm2 и vm3 и будем работать с ansible оттуда, с машины vm1  

- сначала с локальной машины создать vm1 в aws
- aвторизоваться в aws `$ bash aws_auth.sh <aws_access_key.csv> # ключ нужно предварительно скачать из профиля aws`
- cоздать vm1
  ```
  $ cd terraform_local
  $ terraform init && terraform apply --auto-approve
  $ terraform output
  node_fqdn = [ "ec2-44-202-17-110.compute-1.amazonaws.com", ]
  ```
- логин на vm1 и далее работаем там
- создадим юзера ansible, все операции выполняются из под этого юзера
  ```bash
  $ sudo useradd -m -s `which bash` ansible
  $ sudo usermod -aG sudo ansible
  $ sudo passwd ansible
  $ sudo -i
  # echo "ansible ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/ansible
  # visudo -cf !$
  $ exit
  $ ssh-keygen -b 2048 -t rsa -N "" -f ~/.ssh/id_rsa
  ```
- необходимо настроить passwordles ssh локально для ansible
  ```bash
  $ sudo sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/' /etc/ssh/sshd_config
  $ sudo systemctl restart sshd
  $ ssh-copy-id localhost
  ```
- закомитить проект на github и склонировать его на vm1
- установить terraform и ansible - файл setup.sh
- настроить ansible /etc/ansible/ansible.cfg
  ```bash
  cat <<eof>> ansible.cfg
  [defaults]
  #remote_user = ansible ### remote_user использовать не будем, создавая terrform создадим дефолтных  
  # юзеров настроив для них авторизацию по ключу  
  # необходимо учесть тот момент, что дефотные юзеры разные: ubuntu и ec2-user для ubuntu и aws образов
  # это настроим в hosts.tpl
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
- hosts.tpl файл для динамического создания инвентори
```terraform
[database]
localhost

[web]
localhost

[app]
${vm2} ansible_user=ubuntu
${vm3} ansible_user=ec2-user
```
- ansible ping ok
```bash
  ~/ProjectB6_HW_03/ansible$ ansible -i inventory -m ping all
34.205.129.46 | SUCCESS => {
    "ansible_facts": {
        "discovered_interpreter_python": "/usr/bin/python3"
    },
    "changed": false,
    "ping": "pong"
}
localhost | SUCCESS => {
    "ansible_facts": {
        "discovered_interpreter_python": "/usr/bin/python3"
    },
    "changed": false,
    "ping": "pong"
}
[WARNING]: Platform linux on host 52.91.80.170 is using the discovered Python interpreter at /usr/bin/python3.9, but future installation of another Python interpreter could change the meaning of that path. See https://docs.ansible.com/ansible- 
core/2.14/reference_appendices/interpreter_discovery.html for more information.
52.91.80.170 | SUCCESS => {
    "ansible_facts": {
        "discovered_interpreter_python": "/usr/bin/python3.9"
    },
    "changed": false,
    "ping": "pong"
}
```

