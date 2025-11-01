#!/bin/bash

# Check the status of all deployed resources

set -e

echo "╔════════════════════════════════════════════════════════╗"
echo "║           Deployment Status Check                      ║"
echo "╚════════════════════════════════════════════════════════╝"
echo ""

# Check Jenkins
echo "🔍 Checking Jenkins Infrastructure..."
if az container show \
  -g research-report-jenkins-rg \
  -n jenkins-research-report > /dev/null 2>&1; then
    
    JENKINS_URL=$(az container show \
      -g research-report-jenkins-rg \
      -n jenkins-research-report \
      --query ipAddress.fqdn -o tsv)
    
    JENKINS_STATE=$(az container show \
      -g research-report-jenkins-rg \
      -n jenkins-research-report \
      --query "containers[0].instanceView.currentState.state" -o tsv)
    
    echo "  ✅ Jenkins Status: $JENKINS_STATE"
    echo "  🌐 Jenkins URL: http://$JENKINS_URL:8080"
else
    echo "  ⚠️  Jenkins not deployed"
fi

echo ""
echo "🔍 Checking Application Deployment..."
if az containerapp show \
  -n research-report-app \
  -g research-report-app-rg > /dev/null 2>&1; then
    
    APP_URL=$(az containerapp show \
      -n research-report-app \
      -g research-report-app-rg \
      --query properties.configuration.ingress.fqdn -o tsv)
    
    APP_STATUS=$(az containerapp show \
      -n research-report-app \
      -g research-report-app-rg \
      --query properties.runningStatus -o tsv)
    
    APP_REPLICAS=$(az containerapp show \
      -n research-report-app \
      -g research-report-app-rg \
      --query properties.template.scale.minReplicas -o tsv)
    
    echo "  ✅ App Status: $APP_STATUS"
    echo "  🌐 App URL: https://$APP_URL"
    echo "  📊 Min Replicas: $APP_REPLICAS"
else
    echo "  ⚠️  Application not deployed"
fi

echo ""
echo "🔍 Checking Storage..."
if az storage account show \
  --name reportappstorage \
  --resource-group research-report-app-rg > /dev/null 2>&1; then
    
    STORAGE_STATUS=$(az storage account show \
      --name reportappstorage \
      --resource-group research-report-app-rg \
      --query provisioningState -o tsv)
    
    echo "  ✅ Storage Account: $STORAGE_STATUS"
else
    echo "  ⚠️  Storage Account not found"
fi

echo ""
echo "🔍 Checking Container Registries..."

# Jenkins ACR
if az acr show --name reportjenkinsacr --resource-group research-report-jenkins-rg > /dev/null 2>&1; then
    echo "  ✅ Jenkins ACR: Active"
else
    echo "  ⚠️  Jenkins ACR not found"
fi

# App ACR
if az acr show --name researchreportacr --resource-group research-report-app-rg > /dev/null 2>&1; then
    IMAGE_COUNT=$(az acr repository list --name researchreportacr --output tsv 2>/dev/null | wc -l)
    echo "  ✅ App ACR: Active ($IMAGE_COUNT images)"
else
    echo "  ⚠️  App ACR not found"
fi

echo ""
echo "╔════════════════════════════════════════════════════════╗"
echo "║              Status Check Complete                     ║"
echo "╚════════════════════════════════════════════════════════╝"




