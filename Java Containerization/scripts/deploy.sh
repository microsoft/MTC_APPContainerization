#!/bin/sh

REGION=$1
RG_NAME=$2

az group create --name $RG_NAME --location $REGION
az group deployment create --name "azuredeploy" --resource-group $RG_NAME --template-file "./azuredeploy.json" --parameters "./azuredeploy.parameters.json" --verbose

