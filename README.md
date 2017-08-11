# nfs-vagrant

Some scripting to repeatedly set up NFS test environments.  Three machines are
set up: a KDC (standalone), an NFS server, and an NFS client.  Both the NFS
client and NFS server are set up with gssproxy.

## Prerequisites

Fedora:

    dnf install vagrant-sshfs ansible

Debian:

    aptitude install ansible vagrant{,-libvirt,-sshfs}

## Running

To mimimize the potential for synchronization problems:

    vagrant up --no-provision
    vagrant provision
