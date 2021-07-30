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

echo 'DatabaseConfigType=jndi' >> /var/airsonic/airsonic.properties
echo 'DatabaseConfigJNDIName=jdbc/airsonicDB' >> /var/airsonic/airsonic.properties
#echo 'DatabaseConfigType=jndi' >> /datadrive/airsonic/airsonic.properties
#echo 'DatabaseConfigJNDIName=jdbc/airsonicDB' >> /datadrive/airsonic/airsonic.properties

# replace setenv
rm -rf /opt/tomcat9/bin/setenv.sh
echo "MYSQL_SERVER_ADMIN_LOGIN_NAME='$MYSQL_ADMIN_USER'" >> /opt/tomcat9/bin/setenv.sh
echo "MYSQL_SERVER_ADMIN_PASSWORD='$MYSQL_ADMIN_PASS'" >> /opt/tomcat9/bin/setenv.sh
echo "MYSQL_DATABASE_NAME='$MYSQL_DBNAME'" >> /opt/tomcat9/bin/setenv.sh
echo "MYSQL_SERVER_FULL_NAME='$MYSQL_HOSTNAME'" >> /opt/tomcat9/bin/setenv.sh
echo "CATALINA_OPTS='-Xms8192M -Xmx8192M -server -XX:+UseParallelGC'" >> /opt/tomcat9/bin/setenv.sh
echo "JAVA_OPTS='-Djava.awt.headless=true -Djava.security.egd=file:/dev/./urandom -Dairsonic.home=/var/airsonic -DMYSQL_SERVER_FULL_NAME=\$MYSQL_SERVER_FULL_NAME -DMYSQL_DATABASE_NAME=\$MYSQL_DATABASE_NAME -DMYSQL_SERVER_ADMIN_LOGIN_NAME=\$MYSQL_SERVER_ADMIN_LOGIN_NAME -DMYSQL_SERVER_ADMIN_PASSWORD=\$MYSQL_SERVER_ADMIN_PASSWORD'" >> /opt/tomcat9/bin/setenv.sh


# Move to db creation
# Increase connection timeout
#az mysql server configuration set --name wait_timeout \
# --resource-group ${RESOURCE_GROUP} \
# --server ${MYSQL_SERVER_NAME} --value 2147483

