#!/bin/bash

# Complete cleanup - deletes ALL Azure resources
# WARNING: This is irreversible! All data will be lost!

set -e

echo "╔════════════════════════════════════════════════════════╗"
echo "║               ⚠️  COMPLETE CLEANUP  ⚠️                 ║"
echo "╚════════════════════════════════════════════════════════╝"
echo ""
echo "⚠️  WARNING: This will delete ALL resources!"
echo ""
echo "This includes:"
echo "  • Jenkins infrastructure and configuration"
echo "  • Application deployment and infrastructure"
echo "  • All storage (reports, database, logs)"
echo "  • All container registries and images"
echo ""
echo "💀 This action is IRREVERSIBLE!"
echo ""
read -p "Are you ABSOLUTELY sure? Type 'DELETE' to confirm: " confirm

if [ "$confirm" != "DELETE" ]; then
    echo "Cancelled."
    exit 0
fi

echo ""
echo "🗑️  Deleting all resources..."

# Delete Jenkins Resource Group
echo ""
echo "📦 Deleting Jenkins resource group..."
if az group show --name research-report-jenkins-rg > /dev/null 2>&1; then
    az group delete --name research-report-jenkins-rg --yes --no-wait
    echo "✅ Jenkins resource group deletion initiated"
else
    echo "ℹ️  Jenkins resource group not found"
fi

# Delete App Resource Group
echo ""
echo "📦 Deleting App resource group..."
if az group show --name research-report-app-rg > /dev/null 2>&1; then
    az group delete --name research-report-app-rg --yes --no-wait
    echo "✅ App resource group deletion initiated"
else
    echo "ℹ️  App resource group not found"
fi

echo ""
echo "╔════════════════════════════════════════════════════════╗"
echo "║           Cleanup Initiated Successfully!              ║"
echo "╚════════════════════════════════════════════════════════╝"
echo ""
echo "🕐 Resource deletion is running in the background."
echo "⏱️  This may take 5-10 minutes to complete."
echo ""
echo "Check status with:"
echo "  az group show --name research-report-jenkins-rg"
echo "  az group show --name research-report-app-rg"
echo ""
echo "💰 All charges will stop once deletion is complete."

