#!/bin/bash
sudo yum update -y
#expect, wget
sudo yum install -y expect wget
# MySQL
sudo wget http://dev.mysql.com/get/mysql57-community-release-el7-7.noarch.rpm
sudo yum -y install ./mysql57-community-release-el7-7.noarch.rpm
sudo yum -y install mysql-community-server
sudo systemctl start mysqld

MYSQL_SERVICE=mysqld
MYSQL_LOG_FILE=/var/log/${MYSQL_SERVICE}.log
MYSQL_PWD=$(grep -oP '(?<=A temporary password is generated for root@localhost: )[^ ]+' ${MYSQL_LOG_FILE})

MYSQL_UPDATE=$(expect -c "
set timeout 5
spawn mysql -u root -p
expect \"Enter password: \"
send \"${MYSQL_PWD}\r\"

expect \"mysql>\"
send \"ALTER USER 'root'@'localhost' IDENTIFIED BY 'r00t_PA@@';\r\"

expect \"mysql>\"
send \"CREATE USER 'moodle'@'%' IDENTIFIED BY 'user_PA@@w0rd';\r\"

expect \"mysql>\"
send \"CREATE DATABASE moodle_db;\r\"

expect \"mysql>\"
send \"GRANT ALL ON *.* TO 'moodle'@'%' IDENTIFIED BY 'user_PA@@w0rd';\r\"

expect \"mysql>\"
send \"FLUSH PRIVILEGES;\r\"

expect \"mysql>\"
send \"quit;\r\"
expect eof
")

echo "$MYSQL_UPDATE"

