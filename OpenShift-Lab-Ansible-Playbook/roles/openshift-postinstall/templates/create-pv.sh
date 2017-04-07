#!/bin/sh

mkdir -p "$HOME/pvs/"

for size in 1Gi 5Gi 10Gi; do
  for volume in pv{1..25} ; do
    cat << EOF > $HOME/pvs/pv-${size}-${volume}.json
{
  "apiVersion": "v1",
  "kind": "PersistentVolume",
  "metadata": {
    "name": "${volume}"
  },
  "spec": {
    "capacity": {
        "storage": "${size}"
    },
    "accessModes": [ "ReadWriteOnce" ],
    "nfs": {
        "path": "/openshift-storage/pv-${size}-${volume}",
        "server": "{{ hostvars[groups['admin'][0]]['ansible_default_ipv4']['address'] }}"
    },
    "persistentVolumeReclaimPolicy": "Recycle"
  }
}
EOF
  done
done
