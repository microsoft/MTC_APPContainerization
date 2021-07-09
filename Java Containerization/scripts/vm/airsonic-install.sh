#!/bin/sh

AIRSONIC_PACKAGE=$1

echo "installing airsonic app"
### install airsonic app ###
cd /tmp 
mkdir airsonic
cd airsonic

# Download airsonic WAR package 
wget $AIRSONIC_PACKAGE

# Move the downloaded WAR file in the $TOMCAT_HOME/webapps  
# folder and assign ownership to the Tomcat system user: 
mkdir /opt/tomcat9/webapps/airsonic

jar -xvf airsonic.war
rm -rf airsonic.war 
mv * /opt/tomcat9/webapps/airsonic

mkdir -p /datadrive/airsonic/

# create music, media, podcasts and playlists folders
cd /datadrive/airsonic/
mkdir music
mkdir media
mkdir podcasts
mkdir playlists

chown -R tomcat9:tomcat9 /datadrive/airsonic/
chmod 777 /datadrive/airsonic/music

# setup env vars
echo "Setting env vars"
echo "CATALINA_OPTS='-Xms512M -Xmx1024M -server -XX:+UseParallelGC'" >> /opt/tomcat9/bin/setenv.sh
echo "JAVA_OPTS='-Djava.awt.headless=true -Djava.security.egd=file:/dev/./urandom -Dairsonic.home=/datadrive/airsonic'" >> /opt/tomcat9/bin/setenv.sh
echo "Setting env vars complete"

# Start/Stop tomcat to generate airsonic properties file
echo "Starting tomcat"
/opt/tomcat9/bin/startup.sh
sleep 30
echo "Stopping tomcat"
/opt/tomcat9/bin/shutdown.sh
sleep 30