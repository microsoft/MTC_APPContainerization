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
AIRSONIC_BASEDIR=/var
mkdir -p $AIRSONIC_BASEDIR

# create music, media, podcasts and playlists folders
cd $AIRSONIC_BASEDIR
mkdir music
mkdir music/podcasts
mkdir media

chown -R tomcat9:tomcat9 $AIRSONIC_BASEDIR
chmod 777 $AIRSONIC_BASEDIR/music

# reload the systemd daemon so that it knows about our service file
sudo systemctl daemon-reload

# Enable the service file so that Tomcat automatically starts at boot:
sudo systemctl enable tomcat9

# Start/Stop tomcat to generate airsonic properties file
echo "Starting tomcat"
sudo systemctl start tomcat9
sleep 30
echo "Stopping tomcat"
sudo systemctl stop tomcat9
sleep 30