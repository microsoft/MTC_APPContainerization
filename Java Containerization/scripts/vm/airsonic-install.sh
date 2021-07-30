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

MEDIA_BASEDIR=/var
#MEDIA_BASEDIR=/datadrive/airsonic
#mkdir -p $MEDIA_BASEDIR

# create music, media, podcasts and playlists folders
cd $MEDIA_BASEDIR
mkdir music
mkdir music/podcasts
mkdir media

chown -R tomcat9:tomcat9 $MEDIA_BASEDIR
chmod 777 $MEDIA_BASEDIR/music

# setup env vars
echo "Setting env vars"
echo "CATALINA_OPTS='-Xms512M -Xmx1024M -server -XX:+UseParallelGC'" >> /opt/tomcat9/bin/setenv.sh
echo "JAVA_OPTS='-Djava.awt.headless=true -Djava.security.egd=file:/dev/./urandom -Dairsonic.home=/var/airsonic'" >> /opt/tomcat9/bin/setenv.sh
echo "Setting env vars complete"

# Start/Stop tomcat to generate airsonic properties file
echo "Starting tomcat"
/opt/tomcat9/bin/startup.sh
sleep 30
echo "Stopping tomcat"
/opt/tomcat9/bin/shutdown.sh
sleep 30