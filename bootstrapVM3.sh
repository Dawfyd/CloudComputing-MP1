#!/usr/bin/env bash

# BEGIN
echo -e "-- ----------------- --\n"
echo -e "-- BEGIN ${HOSTNAME} --\n"
echo -e "-- ----------------- --\n"

# LOGIN AS SUPERUSER

sudo -i

# BOX 
echo -e "-- Updating packages list\n"
apt-get update -y -qq


# INSTALL LINUX CONTAINER
echo -e "-- Installing LXD\n"
sudo snap install lxd --channel=4.0/stable
echo "newgrp lxd"
newgrp lxd
echo "lxd init --auto"
lxd init --auto
echo "lxc launch ubuntu:20.04 web2"
lxc launch ubuntu:20.04 LXD3
lxc exec LXD3 /bin/bash

# APACHE 
echo -e "-- Installing Apache web server\n"
lxc exec LXD3 -- apt-get install -y apache2 

echo -e "-- lxc file push\n"
lxc file push /vagrant/index.html web/var/www/index.html
echo -e "-- Restarting Apache web server\n"
lxc exec LXD3 -- systemctl restart apache2
echo -e "-- lxc config device\n"
lxc config device add LXD3 myport80 proxy listen=tcp:0.0.0.0:80 connect=tcp:127.0.0.1:80

# END
echo -e "-- -------------- --"
echo -e "-- END ${HOSTNAME} --"
echo -e "-- -------------- --"