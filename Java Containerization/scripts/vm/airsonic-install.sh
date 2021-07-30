#!/bin/sh

AIRSONIC_PACKAGE=$1
TOMCAT_SERVICE=$2

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

#AIRSONIC_BASEDIR=/datadrive/airsonic
AIRSONIC_BASEDIR=/var/airsonic
mkdir -p $AIRSONIC_BASEDIR

# create music, media, podcasts and playlists folders
cd $AIRSONIC_BASEDIR
mkdir music
mkdir music/podcasts
mkdir media

chown -R tomcat9:tomcat9 $AIRSONIC_BASEDIR
chmod 777 $AIRSONIC_BASEDIR/music




# setup env vars
#echo "Setting env vars"
#echo "CATALINA_OPTS='-Xms512M -Xmx1024M -server -XX:+UseParallelGC'" >> /opt/tomcat9/bin/setenv.sh
#echo "JAVA_OPTS='-Djava.awt.headless=true -Djava.security.egd=file:/dev/./urandom -Dairsonic.home=$MEDIA_BASEDIR'" >> /opt/tomcat9/bin/setenv.sh
#echo "Setting env vars complete"

# Start/Stop tomcat to generate airsonic properties file
echo "Starting tomcat"
#/opt/tomcat9/bin/startup.sh
sudo systemctl start tomcat9
sleep 30
echo "Stopping tomcat"
#/opt/tomcat9/bin/shutdown.sh
sudo systemctl stop tomcat9
sleep 30