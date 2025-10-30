#!/bin/bash

# Build and Push Docker Image for Research Report Generation System

set -e

# Configuration
APP_ACR_NAME="researchreportacr"
IMAGE_NAME="research-report-app"
TAG="${1:-latest}"

echo "🐳 Building Docker image for Research Report Generation System..."
echo "📦 Tag: $TAG"
echo ""

# Login to ACR
echo "🔐 Logging in to Azure Container Registry..."
az acr login --name $APP_ACR_NAME

# Build image
echo "🔨 Building Docker image..."
docker build -t ${APP_ACR_NAME}.azurecr.io/${IMAGE_NAME}:${TAG} .

# Push to ACR
echo "📤 Pushing image to ACR..."
docker push ${APP_ACR_NAME}.azurecr.io/${IMAGE_NAME}:${TAG}

echo ""
echo "✅ Build and push complete!"
echo "📦 Image: ${APP_ACR_NAME}.azurecr.io/${IMAGE_NAME}:${TAG}"
echo ""
echo "Now run your Jenkins pipeline to deploy."

