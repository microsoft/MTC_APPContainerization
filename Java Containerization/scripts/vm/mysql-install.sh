#!/bin/sh

MYSQL_CLIENT_PACKAGE=$1
MYSQL_ADMIN_USER=$2
MYSQL_SERVER_HOST=$3
MYSQL_ADMIN_PASS=$4

echo "pack: $MYSQL_CLIENT_PACKAGE"
echo "user: $MYSQL_ADMIN_USER"
echo "host: $MYSQL_SERVER_HOST"
echo "pass: $MYSQL_ADMIN_PASS"


### Install MySQL client ###
############################
echo "Installing $MYSQL_CLIENT_PACKAGE"
sudo apt-get -y update
sudo apt-get -y upgrade
sudo apt-get install -y $MYSQL_CLIENT_PACKAGE
sudo apt-get -y update --fix-missing
sudo apt-get install -y $MYSQL_CLIENT_PACKAGE
echo "Installing $MYSQL_CLIENT_PACKAGE complete"
echo ""


### Create root user ###
########################
echo "Creating root user on host $MYSQL_SERVER_HOST"
mysql -u $MYSQL_ADMIN_USER -h $MYSQL_SERVER_HOST -P 3306 -p$MYSQL_ADMIN_PASS -e "\
    CREATE USER 'root' IDENTIFIED BY 'airsonic'; 
    GRANT ALL PRIVILEGES ON airsonic.* TO 'root'; 
    CALL mysql.az_load_timezone();"
echo "Creating root user complete"