#!/bin/bash
# Install neccesary packages
yum update -y
yum install -y docker
yum install -y git

# Set timezone
timedatectl set-timezone Europe/Madrid

# Clone git repo and copy to html folder
cd /tmp
git clone ${git_uri}
cp -r .${git_uri_app_path}docker /var

# Start Docker
service docker start
chkconfig docker on
usermod -a -G docker ec2-user

# Create docker-compose.yml
cd /var/docker
touch docker-compose.yml
cat > docker-compose.yml <<EOF
${docker_file}
EOF

# Create nginx.conf
cd /var/docker/proxy_init/config
touch default.conf
cat > default.conf <<EOF
${nginx_config}
EOF

# Create nginx.html
cd /var/docker/proxy_init/html
touch index.html
cat > index.html <<EOF
${nginx_html}
EOF

# Install Docker compose
cd /home/ec2-user
curl -L https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m) -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose
ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose

# Run containers
docker network create frontweb
docker-compose -f /var/docker/docker-compose.yml up -d

#--------------------------------------------------------------------------------------------------------------
# Export LAB data to local Redis DB
#--------------------------------------------------------------------------------------------------------------
# Install Redis and python dependencies
#amazon-linux-extras redis6
#yum install redis -y
#yum install -y gcc openssl-devel jemalloc-devel openssl-devel tcl tcl-devel
#wget http://download.redis.io/redis-stable.tar.gz && tar xvzf redis-stable.tar.gz && cd redis-stable && make
#systemctl start redis
#systemctl enable redis

# Redis DB: allow access from anywhere and set password
#sed -i 's/^bind 127.0.0.1/bind 0.0.0.0/' /etc/redis/redis.conf
#sh -c "echo 'requirepass ${db_pass}' >> /etc/redis/redis.conf"
#systemctl restart redis-server

# Install python dependencies
#yum install python3-pip
#pip3 install redis kubernetes

# Export the token and server certificate to AWS Parameter Store using Python
#cat << EOF > export-lab-info.py
#${redis_script}
#EOF

# Run script
#python3 export-lab-info.py