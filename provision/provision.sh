#!/bin/bash
# ------------------------------------------------------------------------------
# Provisioning script for the docker-laravel web server stack
# ------------------------------------------------------------------------------

apt-get update

# ------------------------------------------------------------------------------
# curl
# ------------------------------------------------------------------------------

apt-get -y install curl libcurl3 libcurl3-dev

# ------------------------------------------------------------------------------
# Supervisor
# ------------------------------------------------------------------------------

apt-get -y install python # Install python (required for Supervisor)

mkdir -p /etc/supervisord/
mkdir /var/log/supervisord

# copy all conf files
cp /provision/conf/supervisor.conf /etc/supervisord.conf
cp /provision/service/* /etc/supervisord/

curl https://bootstrap.pypa.io/ez_setup.py -o - | python

easy_install supervisor

# ------------------------------------------------------------------------------
# SSH
# ------------------------------------------------------------------------------

apt-get -y install openssh-server
mkdir /var/run/sshd
sed -i "s/#PasswordAuthentication yes/PasswordAuthentication no/" /etc/ssh/sshd_config

#keys
mkdir -p /root/.ssh
chmod 700 /root/.ssh
chown root:root /root/.ssh
cp /provision/keys/insecure_key.pub /root/.ssh/authorized_keys
chmod 600 /root/.ssh/authorized_keys

# ------------------------------------------------------------------------------
# cron
# ------------------------------------------------------------------------------

apt-get -y install cron

# ------------------------------------------------------------------------------
# nano
# ------------------------------------------------------------------------------

apt-get -y install nano

# ------------------------------------------------------------------------------
# vim
# ------------------------------------------------------------------------------

apt-get -y install vim

# ------------------------------------------------------------------------------
# Git version control
# ------------------------------------------------------------------------------

# install git
apt-get -y install git

# ------------------------------------------------------------------------------
# Java
# ------------------------------------------------------------------------------

apt-get install -y default-jre

# ------------------------------------------------------------------------------
# Unzip
# ------------------------------------------------------------------------------

apt-get -y install unzip

# ------------------------------------------------------------------------------
# MariaDB server
# ------------------------------------------------------------------------------

# install MariaDB client and server
apt-get -y install mariadb-client
apt-get -y install mariadb-server pwgen

# copy MariaDB configuration
cp /provision/conf/my.cnf /etc/mysql/my.cnf

# MariaDB seems to have problems starting if these permissions are not set:
mkdir /var/run/mysqld
chmod 777 /var/run/mysqld

# ------------------------------------------------------------------------------
# SymmetricDS
# ------------------------------------------------------------------------------

cd ~/
wget --output-document=symmetric.zip https://sourceforge.net/projects/symmetricds/files/symmetricds/symmetricds-3.7/symmetric-server-3.7.36.zip/download
unzip symmetric.zip
mv symmetric-server-3.7.36 symmetric-server
mv symmetric-server/ /usr/local/bin/

# ------------------------------------------------------------------------------
# Clean up
# ------------------------------------------------------------------------------
rm -rf /provision
