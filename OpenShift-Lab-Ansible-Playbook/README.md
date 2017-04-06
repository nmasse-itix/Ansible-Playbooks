# OpenShift-Lab-Ansible-Playbook
This project is the Ansible Playbook to install OpenShift in a Lab Environment.

## Preparation work

1. Edit group_vars/lab and change all passwords and DNS names (search for "changeme")
2. Edit hosts-lab to target your Virtual Machines

## Installation

‘‘‘
./ansible bootstrap master1.openshift.test node1.openshift.test node2.openshift.test nodeinfra1.openshift.test admin.openshift.test
./ansible play
./ansible run nodes "uptime -p"
’’’
