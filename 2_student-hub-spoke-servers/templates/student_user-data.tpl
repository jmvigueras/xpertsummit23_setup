#!/bin/bash
# Install neccesary packages
yum update -y
yum -y install docker

# Set timezone
timedatectl set-timezone Europe/Madrid

# Start Docker
service docker start
chkconfig docker on
usermod -a -G docker ec2-user

# Run containers
docker pull ${docker_image}
docker run -d --rm ${docker_env} -p ${docker_port_external}:${docker_port_internal} ${docker_image}