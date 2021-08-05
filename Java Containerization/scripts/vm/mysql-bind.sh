#!/bin/sh

TOMCAT_CONTEXT=$1
MYSQL_DRIVER=$2
MYSQL_ADMIN_USER=$3
MYSQL_ADMIN_PASS=$4
MYSQL_DBNAME=$5
MYSQL_HOSTNAME=$6

# Download airsonic app contxt.xml
cd /tmp
wget $TOMCAT_CONTEXT
mv context.xml /opt/tomcat9/webapps/airsonic/META-INF/context.xml

# Download MySQL Driver
wget $MYSQL_DRIVER
tar xvzf mysql-connector-java-*tar.gz

# copy to Tomcat9/lib folder 
cp mysql-connector-java-*/mysql-connector-java-*.jar /opt/tomcat9/lib 

echo 'DatabaseConfigType=jndi' >> /var/airsonic.properties
echo 'DatabaseConfigJNDIName=jdbc/airsonicDB' >> /var/airsonic.properties

# write to tomcat9.service
sed -i "s%Environment=MYSQL_SERVER_ADMIN_LOGIN_NAME=%Environment=MYSQL_SERVER_ADMIN_LOGIN_NAME=$MYSQL_ADMIN_USER%" /etc/systemd/system/tomcat9.service
sed -i "s%Environment=MYSQL_SERVER_ADMIN_PASSWORD=%Environment=MYSQL_SERVER_ADMIN_PASSWORD=$MYSQL_ADMIN_PASS%" /etc/systemd/system/tomcat9.service
sed -i "s%Environment=MYSQL_DATABASE_NAME=%Environment=MYSQL_DATABASE_NAME=$MYSQL_DBNAME%" /etc/systemd/system/tomcat9.service
sed -i "s%Environment=MYSQL_SERVER_FULL_NAME=%Environment=MYSQL_SERVER_FULL_NAME=$MYSQL_HOSTNAME%" /etc/systemd/system/tomcat9.service
sed -i "s%-Djava.awt.headless=true -Djava.security.egd=file:/dev/./urandom -Dairsonic.home=/var%-Djava.awt.headless=true -Djava.security.egd=file:/dev/./urandom -Dairsonic.home=/var -DMYSQL_SERVER_FULL_NAME=$MYSQL_HOSTNAME -DMYSQL_DATABASE_NAME=$MYSQL_DBNAME -DMYSQL_SERVER_ADMIN_LOGIN_NAME=$MYSQL_ADMIN_USER -DMYSQL_SERVER_ADMIN_PASSWORD=$MYSQL_ADMIN_PASS%" /etc/systemd/system/tomcat9.service

# reload the systemd daemon so that it knows about our service file
sudo systemctl daemon-reload

echo "Starting tomcat"
sudo systemctl start tomcat9



# Move to db creation
# Increase connection timeout
#az mysql server configuration set --name wait_timeout \
# --resource-group ${RESOURCE_GROUP} \
# --server ${MYSQL_SERVER_NAME} --value 2147483

