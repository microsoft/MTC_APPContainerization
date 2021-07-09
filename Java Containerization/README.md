# Airsonic deployment 
Ubuntu/Tomcat/Java/mySQL environment for Azure airsonic app deployment


Ported from https://github.com/selvasingh/tomcat-on-virtual-machine

Fully automated deployment via arm templates and custom scripts

### Port Notes:

* Does not install Tomcat as a service
* Does not configure transcoding, i.e. sudo snap install ffmpeg
* Binding of airsonic app to mysql fisrt requires the app be started to create a .properties file, stopped, then the .properties needs to be updated with jndi binding.  At the end of the airsonic install, the app is started then stopped to create this file using a 30 second wait period between operations.  The properties file is updated with binding during the mysql binding setup.
* When this repo is cloned the base path to repo where the vm install scripts needs to be updated in azuredeploy.parameters.json to the **raw** path of new repo as show below.
    ```
    "_artifactsLocation": {
      "value": "https://raw.githubusercontent.com/Lantern-Cloud-Services/AzureMigrateJava/main/scripts/vm/"
    }
    ```

## Deployment

    git clone https://github.com/Lantern-Cloud-Services/AzureMigrateJava.git
    cd AzureMigrateJava
    chmod +x scripts/deploy.sh
    ./scripts/deploy.sh '<REGION NAME>' '<RESOURCE GROUP>'

Total deployment will take ~5 minutes.  When complete navigate to the resource group in the azure portal.  Find the created vm named TomcatServer click on its name.  

![Tomcat VM.](https://raw.githubusercontent.com/microsoft/MTC_APPContainerization/main/media/server.jpg)

Identify the public IP address provisioned for the VM.

![Public IP.](https://raw.githubusercontent.com/microsoft/MTC_APPContainerization/main/media/ip.jpg)

Use the IP address to access the Airsonic app at http://{ip}/airsonic
![Airsonic App.](https://raw.githubusercontent.com/microsoft/MTC_APPContainerization/main/media/app.jpg)
