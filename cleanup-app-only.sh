#!/bin/bash

# Cleanup application deployment only (keeps Jenkins infrastructure)
# Useful if you want to keep Jenkins but remove the deployed app

set -e

echo "⚠️  WARNING: This will delete the application deployment!"
echo "Jenkins infrastructure will be kept."
echo ""
read -p "Are you sure? (yes/no): " confirm

if [ "$confirm" != "yes" ]; then
    echo "Cancelled."
    exit 0
fi

echo ""
echo "🗑️  Deleting application deployment..."

# Delete Container App
if az containerapp show \
  -n research-report-app \
  -g research-report-app-rg > /dev/null 2>&1; then
    echo "Deleting Container App..."
    az containerapp delete \
      -n research-report-app \
      -g research-report-app-rg \
      --yes
    echo "✅ Container App deleted"
else
    echo "ℹ️  Container App not found"
fi

echo ""
echo "╔════════════════════════════════════════════════════════╗"
echo "║      Application Deployment Cleaned Up!               ║"
echo "╚════════════════════════════════════════════════════════╝"
echo ""
echo "ℹ️  Application infrastructure (ACR, storage, etc.) is still present."
echo "ℹ️  Jenkins infrastructure is still present."
echo ""
echo "To completely remove everything, run: ./complete-cleanup.sh"

