# OneAccess-Ansible-Playbook
This project is the Ansible Playbook to install CA OneAccess

## Preparation work

1. Edit group_vars/sm and change all passwords and DNS names (search for "changeme")
2. Edit hosts-sm to target your Virtual Machine

## Installation

1. run {{./aw bootstrap your.vm.hostname}}
2. run {{./aw sm}}
