#!/bin/sh

LOG_HOME=/home/$1/vm-setup-logs

JAVA_PACKAGE=$2
TOMCAT_PACKAGE=$3

AIRSONIC_PACKAGE=$4
TOMCAT_CONTEXT=$5
MYSQL_DRIVER=$6

MYSQL_CLIENT_PACKAGE=$7
MYSQL_ADMIN_USER=$8
MYSQL_ADMIN_PASS=$9
MYSQL_SERVER_HOST=$10
MYSQL_DBNAME=$11

mkdir $LOG_HOME

sh java-tomcat-install.sh $JAVA_PACKAGE $TOMCAT_PACKAGE >> $LOG_HOME/java-tomcat-install.log
sh airsonic-install.sh $AIRSONIC_PACKAGE >> $LOG_HOME/airsonic-install.log
sh mysql-install.sh $MYSQL_CLIENT_PACKAGE $MYSQL_ADMIN_USER $MYSQL_SERVER_HOST $MYSQL_ADMIN_PASS >> $LOG_HOME/mysql-install.log
sh mysql-bind.sh $TOMCAT_CONTEXT $MYSQL_DRIVER $MYSQL_ADMIN_USER $MYSQL_ADMIN_PASS $MYSQL_DBNAME $MYSQL_SERVER_HOST >> $LOG_HOME/mysql-bind.log

echo "Starting tomcat"
/opt/tomcat9/bin/startup.sh
sleep 30
