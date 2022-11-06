#!/bin/bash

# Install ansible on ec2.
sudo yum update -y

sudo amazon-linux-extras install ansible2 -y

sudo mkdir /home/ec2-user/project

# Mounts nfs.
sudo mount -t nfs4 -o nfsvers=4.1,rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2,noresvport nfs-dns:/ /home/ec2-user/project
