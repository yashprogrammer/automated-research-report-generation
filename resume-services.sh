#!/bin/bash

# Resume services after they've been paused
# This will restart Jenkins and scale the app back up

set -e

echo "▶️  Resuming services..."
echo ""

# Redeploy Jenkins
echo "🚀 Redeploying Jenkins..."
./azure-deploy-jenkins.sh

# Scale app back up
echo "📈 Scaling app back up..."
if az containerapp show \
  -n research-report-app \
  -g research-report-app-rg > /dev/null 2>&1; then
    az containerapp update \
      --name research-report-app \
      --resource-group research-report-app-rg \
      --min-replicas 1 \
      --max-replicas 3
    echo "✅ App scaled back up"
else
    echo "⚠️  App not found. You may need to run the Jenkins pipeline to deploy it."
fi

echo ""
echo "╔════════════════════════════════════════════════════════╗"
echo "║         Services Resumed Successfully!                 ║"
echo "╚════════════════════════════════════════════════════════╝"
echo ""

