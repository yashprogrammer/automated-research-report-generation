#!/bin/bash

# Pause services to minimize costs
# This will stop Jenkins and scale the app to 0 replicas

set -e

echo "⏸️  Pausing services to minimize costs..."
echo ""

# Stop Jenkins container
echo "🛑 Stopping Jenkins container..."
if az container show \
  -g research-report-jenkins-rg \
  -n jenkins-research-report > /dev/null 2>&1; then
    az container delete \
      -g research-report-jenkins-rg \
      -n jenkins-research-report \
      --yes
    echo "✅ Jenkins stopped"
else
    echo "ℹ️  Jenkins container not found"
fi

# Scale app to 0
echo "📉 Scaling app to 0 replicas..."
if az containerapp show \
  -n research-report-app \
  -g research-report-app-rg > /dev/null 2>&1; then
    az containerapp update \
      --name research-report-app \
      --resource-group research-report-app-rg \
      --min-replicas 0 \
      --max-replicas 0
    echo "✅ App scaled to 0"
else
    echo "ℹ️  App not found"
fi

echo ""
echo "╔════════════════════════════════════════════════════════╗"
echo "║         Services Paused Successfully!                  ║"
echo "╚════════════════════════════════════════════════════════╝"
echo ""
echo "💰 Cost reduced to ~\$11/month (storage + ACRs only)"
echo ""
echo "To resume services, run: ./resume-services.sh"




