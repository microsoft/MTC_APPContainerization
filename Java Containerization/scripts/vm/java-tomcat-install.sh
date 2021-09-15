#!/bin/sh

JAVA_PACKAGE=$1
TOMCAT_PACKAGE=$2
TOMCAT_SERVICE=$3
TOMCAT_USERS=$4
TOMCAT_SERVERCONF=$5
MANAGER_CONTEXT=$6
HOSTMANAGER_CONTEXT=$7


echo "java package: "$JAVA_PACKAGE
echo "tomcat package: "$TOMCAT_PACKAGE
echo "tomcat service file: "$TOMCAT_SERVICE
echo "tomcat users file: "$TOMCAT_USERS
echo "tomcat server.xml: "$TOMCAT_SERVERCONF
echo "tomcat manager file: "$TOMCAT_MANAGERCONTEXT
echo "tomcat hostmanager file: "$TOMCAT_HOSTMANAGERCONTEXT

echo "Intalling Java"
### Install Java ###
####################
sudo apt-get -y update
sudo apt-get -y upgrade
sudo apt-get install -y $JAVA_PACKAGE
sudo apt-get -y update --fix-missing
sudo apt-get install -y $JAVA_PACKAGE
echo "Intalling Java complete"
echo ""
echo ""

echo "Intalling Tomcat"
### Install Tomcat 9 ###
########################
# Create a tomcat9 group 
sudo groupadd tomcat9 

# Create a new tomcat9 user 
sudo useradd -s /bin/false -g tomcat9 -d /opt/tomcat9 tomcat9 
usermod -aG sudo tomcat9

# Download Apache Tomcat 
cd /tmp 
curl -O $TOMCAT_PACKAGE

# Install tomcat in /opt/tomcat9 directory 
sudo mkdir /opt/tomcat9 
sudo tar xzvf apache-tomcat-*tar.gz -C /opt/tomcat9 --strip-components=1 

# Download tomcat service file and move to systemd
wget $TOMCAT_SERVICE
mv ./tomcat9.service  /etc/systemd/system/

# Download and deploy tomcat-users.xml
wget $TOMCAT_USERS
mv ./tomcat-users.xml  /opt/tomcat9/conf/

# Download and deploy tomcat server.xml
wget $TOMCAT_SERVERCONF
mv ./server.xml  /opt/tomcat9/conf/

# Download and deploy manager context.xml
mkdir manager
cd manager
wget $MANAGER_CONTEXT
mv ./context.xml  /opt/tomcat9/webapps/manager/META-INF/

# Download and deploy host-manager context.xml
cd ..
mkdir hostmanager
cd hostmanager
wget $HOSTMANAGER_CONTEXT
mv ./context.xml  /opt/tomcat9/webapps/host-manager/META-INF/

# Update permissions for tomcat9 directory 
cd /opt/tomcat9 
sudo chgrp -R tomcat9 /opt/tomcat9 

# Give tomcat9 group read access 
sudo chmod -R g+r conf 
sudo chmod g+x conf 

# Make the tomcat user the owner of the Web apps, work, temp, and logs directories: 
sudo chown -R tomcat9 webapps/ work/ temp/ logs/ bin/

# add admin user to tomcat group
usermod -g tomcat9 adminUser

echo "Installing Tomcat complete"
echo ""
echo ""