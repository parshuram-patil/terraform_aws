#!/bin/bash

# sleep until instance is ready
until [[ -f /var/lib/cloud/instance/boot-finished ]]; do
  sleep 1
done

# install nginx
sudo yum update -y
sudo amazon-linux-extras install nginx1.12 -y

# make sure nginx is started
sudo service nginx start