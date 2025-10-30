#!/bin/bash

# Azure Deployment Script for Jenkins
# Deploys Jenkins with Python 3.11 and Azure CLI for Research Report Generation CI/CD

set -e

# Configuration
RESOURCE_GROUP="research-report-jenkins-rg"
LOCATION="eastus"
STORAGE_ACCOUNT="reportjenkinsstore"
FILE_SHARE="jenkins-data"
ACR_NAME="reportjenkinsacr"
CONTAINER_NAME="jenkins-research-report"
DNS_NAME_LABEL="jenkins-research-$(date +%s | tail -c 6)"

echo "╔════════════════════════════════════════════════════════╗"
echo "║  Deploying Jenkins for Research Report Generation     ║"
echo "╚════════════════════════════════════════════════════════╝"
echo ""

# Create Resource Group
echo "📦 Creating Resource Group: $RESOURCE_GROUP..."
az group create --name $RESOURCE_GROUP --location $LOCATION

# Create Storage Account
echo "💾 Creating Storage Account: $STORAGE_ACCOUNT..."
az storage account create \
  --resource-group $RESOURCE_GROUP \
  --name $STORAGE_ACCOUNT \
  --location $LOCATION \
  --sku Standard_LRS

# Get Storage Account Key
STORAGE_KEY=$(az storage account keys list \
  --resource-group $RESOURCE_GROUP \
  --account-name $STORAGE_ACCOUNT \
  --query '[0].value' -o tsv)

# Create File Share
echo "📁 Creating File Share: $FILE_SHARE..."
az storage share create \
  --name $FILE_SHARE \
  --account-name $STORAGE_ACCOUNT \
  --account-key $STORAGE_KEY

# Create Azure Container Registry
echo "🐳 Creating Container Registry: $ACR_NAME..."
az acr create \
  --resource-group $RESOURCE_GROUP \
  --name $ACR_NAME \
  --sku Basic \
  --admin-enabled true

# Deploy Jenkins Container with Python 3.11
echo "🚀 Deploying Jenkins Container..."
az container create \
  --resource-group $RESOURCE_GROUP \
  --name $CONTAINER_NAME \
  --image jenkins/jenkins:lts-jdk17 \
  --os-type Linux \
  --dns-name-label $DNS_NAME_LABEL \
  --ports 8080 \
  --cpu 2 \
  --memory 4 \
  --azure-file-volume-account-name $STORAGE_ACCOUNT \
  --azure-file-volume-account-key $STORAGE_KEY \
  --azure-file-volume-share-name $FILE_SHARE \
  --azure-file-volume-mount-path /var/jenkins_home \
  --environment-variables \
    JAVA_OPTS="-Djenkins.install.runSetupWizard=true"

# Wait for deployment
echo "⏳ Waiting for Jenkins to deploy..."
sleep 10

# Get Jenkins URL
JENKINS_URL=$(az container show \
  --resource-group $RESOURCE_GROUP \
  --name $CONTAINER_NAME \
  --query ipAddress.fqdn -o tsv)

echo ""
echo "╔════════════════════════════════════════════════════════╗"
echo "║           Deployment Complete!                         ║"
echo "╚════════════════════════════════════════════════════════╝"
echo ""
echo "🌐 Jenkins URL: http://$JENKINS_URL:8080"
echo ""
echo "⏳ Wait 2-3 minutes for Jenkins to fully start, then run:"
echo ""
echo "az container exec \\"
echo "  --resource-group $RESOURCE_GROUP \\"
echo "  --name $CONTAINER_NAME \\"
echo "  --exec-command 'cat /var/jenkins_home/secrets/initialAdminPassword'"
echo ""
echo "Save this information for the next steps!"

