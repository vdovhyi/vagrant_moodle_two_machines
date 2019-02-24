#!/bin/bash
sudo yum update -y 
sudo yum install -y httpd
sudo systemctl start httpd.service
sudo systemctl enable httpd.service

#php
sudo yum install -y epel-release
sudo rpm -Uhv https://rpms.remirepo.net/enterprise/remi-release-7.rpm
sudo yum-config-manager --enable remi-php71
sudo yum install -y php php-common php-intl php-zip php-soap php-xmlrpc php-opcache php-mbstring php-gd php-curl php-mysql php-xml

#wget
sudo yum install -y wget.x86_64

#Moodle
wget https://download.moodle.org/stable36/moodle-latest-36.tgz
sudo mkdir /var/www/moodledata
sudo chmod -R 755 /var/www/moodledata
sudo chown -R apache:apache /var/www/moodledata
sudo tar xvzf moodle-latest-36.tgz -C /var/www/html/
sudo chown -R apache:apache /var/www/html/moodle
sudo chmod -R 755 /var/www/html/moodle
sudo setenforce 0

#Moodle_install
sudo /usr/bin/php /var/www/html/moodle/admin/cli/install.php --chmod=2770 \
 --lang=en \
 --wwwroot=http://192.168.56.20/moodle \
 --dataroot=/var/www/moodledata \
 --dbtype=mysqli \
 --dbhost=192.168.56.21 \
 --dbname=moodle_db \
 --dbuser=moodle \
 --dbpass=user_PA@@w0rd \
 --prefix=mdl_ \
 --fullname=Moodle \
 --shortname=moodle \
 --summary=Moodle \
 --adminuser=admin \
 --adminpass=user_PA##w0rd \
 --allow-unstable \
 --non-interactive \
 --agree-license

sudo chmod o+r /var/www/html/moodle/config.php
sudo chown apache:apache /var/www/html/moodle/config.php

sudo systemctl restart httpd.service
