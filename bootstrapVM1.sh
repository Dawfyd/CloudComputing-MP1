#!/bin/bash

# BEGIN 
echo -e "-- ------------- --\n"
echo -e "-- BEGIN HAPROXY --\n"
echo -e "-- ------------- --\n"

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
echo "lxc launch ubuntu:20.04 LXD1"
lxc launch ubuntu:20.04 LXD1

# HAPROXY 
echo -e "-- Installing HAProxy\n"
lxc exec LXD1 -- apt-get install -y haproxy > /dev/null 2>&1
echo -e "-- Enabling HAProxy as a start-up deamon\n"
lxc exec LXD1 -- cat > /etc/default/haproxy <<EOF
ENABLED=1
EOF

echo -e "-- Configuring HAProxy\n"
lxc exec haproxy -- cat > /etc/haproxy/haproxy.cfg <<EOF
global
        log /dev/log    local0
        log /dev/log    local1 notice
        chroot /var/lib/haproxy
        stats socket /run/haproxy/admin.sock mode 660 level admin expose-fd listeners
        stats timeout 30s
        user haproxy
        group haproxy
        daemon

        # Default SSL material locations
        ca-base /etc/ssl/certs
        crt-base /etc/ssl/private

        # Default ciphers to use on SSL-enabled listening sockets.
        # For more information, see ciphers(1SSL). This list is from:
        #  https://hynek.me/articles/hardening-your-web-servers-ssl-ciphers/
        # An alternative list with additional directives can be obtained from
        #  https://mozilla.github.io/server-side-tls/ssl-config-generator/?server=haproxy
        ssl-default-bind-ciphers ECDH+AESGCM:DH+AESGCM:ECDH+AES256:DH+AES256:ECDH+AES128:DH+AES:RSA+AESGCM:RSA+AES:!aNULL:!MD5:!DSS
        ssl-default-bind-options no-sslv3
defaults
    log global
    mode http
    option httplog
    option dontlognull
    timeout connect 5000
    timeout client 50000
    timeout server 50000
    errorfile 400 /etc/haproxy/errors/400.http
    errorfile 403 /etc/haproxy/errors/403.http
    errorfile 408 /etc/haproxy/errors/408.http
    errorfile 500 /etc/haproxy/errors/500.http
    errorfile 502 /etc/haproxy/errors/502.http
    errorfile 503 /etc/haproxy/errors/503.http
    errorfile 504 /etc/haproxy/errors/504.http
frontend http
    bind *:80
    default_backend bk_app_main

backend bk_app_main
    balance roundrobin
    stats enable
    stats auth admin:admin
    stats uri /haproxy?stats
    option allbackups
    server servidorVM2 192.168.0.3:80 check
    server servidorVM3 192.168.0.4:80 check
EOF

echo -e "-- Validating HAProxy configuration\n"
lxc exec LXD1 -- systemctl start haproxy

# END
echo -e "-- ----------- --"
echo -e "-- END HAPROXY --"
echo -e "-- ----------- --"