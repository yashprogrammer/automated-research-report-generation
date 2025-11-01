# 🚀 Azure Deployment Guide - Autonomous Research Report Generation System

## 📋 Table of Contents
- [Overview](#overview)
- [Prerequisites](#prerequisites)
- [Architecture Overview](#architecture-overview)
- [Deployment Steps](#deployment-steps)
- [Configuration](#configuration)
- [Monitoring & Maintenance](#monitoring--maintenance)
- [Cost Management](#cost-management)
- [Troubleshooting](#troubleshooting)

---
## 🧰 Troubleshooting

### Jenkins: Git safe.directory warning or checkout failure

**Symptom:** Pipeline fails early with messages like:
- `warning: safe.directory ''*'' not absolute`
- `fatal: not in a git directory`
- `ERROR: Error fetching remote repo 'origin'`

**Root Cause:** Git refuses to operate in directories it does not own unless the path is marked as safe.

**Solution:** The custom Jenkins Docker image (`Dockerfile.jenkins`) pre-configures Git with safe.directory settings during the image build process:

```dockerfile
# Configure Git safe.directory globally (system-wide)
RUN git config --system --add safe.directory "*" && \
    git config --global --add safe.directory "*"
```

**This is automatically handled by:**
1. `Dockerfile.jenkins` - Builds a custom Jenkins image with Git pre-configured
2. `azure-deploy-jenkins.sh` - Builds and pushes this custom image to ACR, then deploys it

**No manual commands needed!** Simply run `./azure-deploy-jenkins.sh` and the Jenkins container will be deployed with Git properly configured.

**If you still see this error:**
1. Verify you're using the latest deployment script
2. Delete the old Jenkins container: `az container delete -g research-report-jenkins-rg -n jenkins-research-report --yes`
3. Re-run: `./azure-deploy-jenkins.sh`

### Jenkins Container Not Accessible

**Symptom:** Cannot access Jenkins URL after deployment

**Possible Causes & Solutions:**

1. **Container Still Starting**
   - Wait 3-5 minutes after deployment completes
   - Jenkins takes time to initialize, especially on first start
   - Check container logs:
   ```bash
   az container logs -g research-report-jenkins-rg -n jenkins-research-report --tail 100
   ```

2. **Port 8080 Blocked**
   - Ensure you're accessing via HTTP (not HTTPS): `http://<jenkins-url>:8080`
   - Check if your firewall/network allows outbound connections to port 8080

3. **Container Failed to Start**
   - Check container status:
   ```bash
   az container show -g research-report-jenkins-rg -n jenkins-research-report --query instanceView.state -o tsv
   ```
   - View error logs:
   ```bash
   az container logs -g research-report-jenkins-rg -n jenkins-research-report
   ```

4. **Docker Image Build Failed**
   - Ensure Docker Desktop is running locally
   - Verify you have the `Dockerfile.jenkins` file in your project root
   - Check if ACR login succeeded during deployment


## 🎯 Overview

This guide walks you through deploying the **Autonomous Research Report Generation System** to Azure using a Jenkins CI/CD pipeline. The deployment includes:

- **FastAPI Web Application** with user authentication
- **LangGraph Multi-Agent Workflows** for report generation
- **Multiple LLM Provider Support** (OpenAI, Google Gemini, Groq)
- **Persistent Storage** for generated reports and SQLite database
- **Automated CI/CD** with GitHub webhooks

### Deployment Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                     GitHub Repository                        │
│                (Your Source Code)                            │
└────────────────────────┬────────────────────────────────────┘
                         │ webhook trigger
                         ▼
┌─────────────────────────────────────────────────────────────┐
│              Jenkins on Azure Container Instance             │
│   • Runs tests                                               │
│   • Builds Docker image                                      │
│   • Pushes to ACR                                           │
│   • Deploys to Container Apps                               │
└────────────────────────┬────────────────────────────────────┘
                         │
                         ▼
┌─────────────────────────────────────────────────────────────┐
│            Azure Container Registry (ACR)                    │
│              (Stores Docker Images)                          │
└────────────────────────┬────────────────────────────────────┘
                         │
                         ▼
┌─────────────────────────────────────────────────────────────┐
│         Azure Container Apps (Production Environment)        │
│   ┌─────────────────────────────────────────────┐          │
│   │  FastAPI App                                │          │
│   │  • Report generation workflows              │          │
│   │  • User authentication                      │          │
│   │  • Web dashboard                            │          │
│   └─────────────────────────────────────────────┘          │
└────────────────────────┬────────────────────────────────────┘
                         │
                         ▼
┌─────────────────────────────────────────────────────────────┐
│              Azure File Share (Persistent Storage)           │
│   • Generated reports (DOCX/PDF)                            │
│   • SQLite database (users.db)                              │
│   • Application logs                                         │
└─────────────────────────────────────────────────────────────┘
```

---

## 📋 Prerequisites Checklist

Before starting, ensure you have:

- [ ] Azure CLI installed (`az --version`)
- [ ] Azure account with active subscription
- [ ] Docker Desktop installed and running
- [ ] Git repository set up on GitHub
- [ ] API keys ready:
  - [ ] OPENAI_API_KEY (or GOOGLE_API_KEY or GROQ_API_KEY)
  - [ ] TAVILY_API_KEY (required for web search)
- [ ] Python 3.11+ installed locally (for testing)

### Installing Azure CLI

**macOS:**
```bash
brew update && brew install azure-cli
```

**Linux:**
```bash
curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash
```

**Windows:**
Download and run the [Azure CLI MSI installer](https://aka.ms/installazurecliwindows)

Or using PowerShell:
```powershell
Invoke-WebRequest -Uri https://aka.ms/installazurecliwindows -OutFile .\AzureCLI.msi; Start-Process msiexec.exe -Wait -ArgumentList '/I AzureCLI.msi /quiet'; rm .\AzureCLI.msi
```

---

## 🏗️ Architecture Overview

### Key Components

1. **Jenkins Infrastructure** (CI/CD Server)
   - Runs in Azure Container Instance
   - Persistent storage via Azure File Share
   - Automatically triggered by GitHub webhooks

2. **Application Infrastructure**
   - Azure Container Apps (scalable hosting)
   - Azure Container Registry (Docker image storage)
   - Azure File Share (persistent data)

3. **External Dependencies**
   - LLM Provider APIs (OpenAI/Google/Groq)
   - Tavily API (web search)
   - GitHub (source code)

### Data Flow

```
User Request → FastAPI → LangGraph Workflow → LLM APIs
                ↓                              ↓
         User Auth (SQLite)           Web Search (Tavily)
                ↓                              ↓
         Generate Report ← ← ← ← ← ← ← ← ← ← ←
                ↓
    Save to Azure File Share (DOCX + PDF)
```

---

## 🎯 Deployment Steps

### Step 1: Login to Azure & Set Environment Variables

```bash
# Login to Azure
az login

# Set your subscription (if you have multiple)
az account set --subscription "<your-subscription-id>"

# Set API keys as environment variables
export OPENAI_API_KEY="your-openai-api-key-here"
export GOOGLE_API_KEY="your-google-api-key-here"
export GROQ_API_KEY="your-groq-api-key-here"
export TAVILY_API_KEY="your-tavily-api-key-here"
export LLM_PROVIDER="openai"  # or "google" or "groq"

# Verify they're set
echo "OPENAI_API_KEY: $OPENAI_API_KEY"
echo "TAVILY_API_KEY: $TAVILY_API_KEY"
echo "LLM_PROVIDER: $LLM_PROVIDER"
```

⚠️ **Important**: Store these in a secure location. You'll need them for Jenkins configuration.

### Step 2: Create Custom Jenkins Dockerfile

Create a `Dockerfile.jenkins` in your project root to build a custom Jenkins image with Git pre-configured:

```dockerfile
# Custom Jenkins Dockerfile with Git and Safe Directory Configuration
# For Research Report Generation CI/CD Pipeline

FROM jenkins/jenkins:lts-jdk17

# Switch to root to install packages
USER root

# Install Git, Python 3.11, Azure CLI, and Docker
RUN apt-get update && \
    apt-get install -y \
    git \
    python3 \
    python3-pip \
    python3-venv \
    curl \
    apt-transport-https \
    ca-certificates \
    gnupg \
    lsb-release && \
    # Install Azure CLI
    curl -sL https://aka.ms/InstallAzureCLIDeb | bash && \
    # Install Docker CLI
    install -m 0755 -d /etc/apt/keyrings && \
    curl -fsSL https://download.docker.com/linux/debian/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg && \
    chmod a+r /etc/apt/keyrings/docker.gpg && \
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/debian $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null && \
    apt-get update && \
    apt-get install -y docker-ce-cli && \
    # Clean up
    rm -rf /var/lib/apt/lists/*

# Configure Git safe.directory globally (system-wide)
# This allows Jenkins to checkout repositories in any workspace directory
RUN git config --system --add safe.directory "*" && \
    git config --global --add safe.directory "*"

# Verify installations
RUN git --version && \
    python3 --version && \
    az --version && \
    docker --version

# Switch back to jenkins user
USER jenkins

# Set environment variables
ENV JAVA_OPTS="-Djenkins.install.runSetupWizard=true"

# Expose Jenkins port
EXPOSE 8080

# Jenkins will use the default entrypoint from the base image
```

### Step 3: Create Deployment Scripts

Create the following scripts in your project root:

#### 3.1. Create `azure-deploy-jenkins.sh`

```bash
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
JENKINS_IMAGE_NAME="custom-jenkins"
JENKINS_IMAGE_TAG="lts-git-configured"

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

# Login to ACR
echo "🔐 Logging in to Azure Container Registry..."
az acr login --name $ACR_NAME

# Build custom Jenkins image with Git and safe.directory configuration
echo "🔨 Building custom Jenkins Docker image..."
docker build -f Dockerfile.jenkins -t ${ACR_NAME}.azurecr.io/${JENKINS_IMAGE_NAME}:${JENKINS_IMAGE_TAG} .

# Push Jenkins image to ACR
echo "📤 Pushing Jenkins image to ACR..."
docker push ${ACR_NAME}.azurecr.io/${JENKINS_IMAGE_NAME}:${JENKINS_IMAGE_TAG}

# Get ACR credentials for container deployment
echo "🔑 Retrieving ACR credentials..."
ACR_USERNAME=$(az acr credential show \
  --name $ACR_NAME \
  --query username -o tsv)

ACR_PASSWORD=$(az acr credential show \
  --name $ACR_NAME \
  --query passwords[0].value -o tsv)

# Deploy Jenkins Container using custom image
echo "🚀 Deploying Jenkins Container..."
az container create \
  --resource-group $RESOURCE_GROUP \
  --name $CONTAINER_NAME \
  --image ${ACR_NAME}.azurecr.io/${JENKINS_IMAGE_NAME}:${JENKINS_IMAGE_TAG} \
  --registry-login-server ${ACR_NAME}.azurecr.io \
  --registry-username $ACR_USERNAME \
  --registry-password $ACR_PASSWORD \
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
```

#### 3.2. Create `setup-app-infrastructure.sh`

```bash
#!/bin/bash

# Setup Application Infrastructure for Research Report Generation System
# Creates: Resource Group, ACR, Container Apps Environment, File Share

set -e

# Configuration
APP_RESOURCE_GROUP="research-report-app-rg"
LOCATION="eastus"
APP_ACR_NAME="researchreportacr"
CONTAINER_ENV="research-report-env"
STORAGE_ACCOUNT="reportappstorage"
FILE_SHARE="generated-reports"

echo "╔════════════════════════════════════════════════════════╗"
echo "║  Setting up Application Infrastructure                 ║"
echo "╚════════════════════════════════════════════════════════╝"
echo ""

# Create Resource Group
echo "📦 Creating App Resource Group: $APP_RESOURCE_GROUP..."
az group create --name $APP_RESOURCE_GROUP --location $LOCATION

# Create Storage Account for Reports
echo "💾 Creating Storage Account: $STORAGE_ACCOUNT..."
az storage account create \
  --resource-group $APP_RESOURCE_GROUP \
  --name $STORAGE_ACCOUNT \
  --location $LOCATION \
  --sku Standard_LRS

# Get Storage Account Key
STORAGE_KEY=$(az storage account keys list \
  --resource-group $APP_RESOURCE_GROUP \
  --account-name $STORAGE_ACCOUNT \
  --query '[0].value' -o tsv)

# Create File Share for Reports
echo "📁 Creating File Share: $FILE_SHARE..."
az storage share create \
  --name $FILE_SHARE \
  --account-name $STORAGE_ACCOUNT \
  --account-key $STORAGE_KEY

# Create Azure Container Registry
echo "🐳 Creating Container Registry: $APP_ACR_NAME..."
az acr create \
  --resource-group $APP_RESOURCE_GROUP \
  --name $APP_ACR_NAME \
  --sku Basic \
  --admin-enabled true

# Get ACR credentials
ACR_USERNAME=$(az acr credential show \
  --name $APP_ACR_NAME \
  --query username -o tsv)

ACR_PASSWORD=$(az acr credential show \
  --name $APP_ACR_NAME \
  --query passwords[0].value -o tsv)

# Create Container Apps Environment
echo "🌍 Creating Container Apps Environment: $CONTAINER_ENV..."
az containerapp env create \
  --name $CONTAINER_ENV \
  --resource-group $APP_RESOURCE_GROUP \
  --location $LOCATION

echo ""
echo "╔════════════════════════════════════════════════════════╗"
echo "║           Setup Complete!                              ║"
echo "╚════════════════════════════════════════════════════════╝"
echo ""
echo "⚠️  IMPORTANT: Add these credentials to Jenkins:"
echo ""
echo "┌─────────────────────────────────────────────────────────┐"
echo "│ Credential ID: acr-username                             │"
echo "│ Value: $ACR_USERNAME"
echo "└─────────────────────────────────────────────────────────┘"
echo ""
echo "┌─────────────────────────────────────────────────────────┐"
echo "│ Credential ID: acr-password                             │"
echo "│ Value: $ACR_PASSWORD"
echo "└─────────────────────────────────────────────────────────┘"
echo ""
echo "┌─────────────────────────────────────────────────────────┐"
echo "│ Credential ID: storage-account-name                     │"
echo "│ Value: $STORAGE_ACCOUNT"
echo "└─────────────────────────────────────────────────────────┘"
echo ""
echo "┌─────────────────────────────────────────────────────────┐"
echo "│ Credential ID: storage-account-key                      │"
echo "│ Value: $STORAGE_KEY"
echo "└─────────────────────────────────────────────────────────┘"
echo ""
```

#### 3.3. Create `build-and-push-docker-image.sh`

```bash
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
```

Make all scripts executable:

```bash
chmod +x azure-deploy-jenkins.sh
chmod +x setup-app-infrastructure.sh
chmod +x build-and-push-docker-image.sh
```

### Step 4: Create Application Dockerfile

Create a `Dockerfile` in your project root:

```dockerfile
# Multi-stage build for Research Report Generation System
FROM python:3.11-slim as builder

WORKDIR /app

# Install system dependencies
RUN apt-get update && apt-get install -y \
    gcc \
    g++ \
    && rm -rf /var/lib/apt/lists/*

# Copy requirements
COPY requirements.txt .

# Install Python dependencies
RUN pip install --no-cache-dir --user -r requirements.txt

# Final stage
FROM python:3.11-slim

WORKDIR /app

# Install runtime dependencies
RUN apt-get update && apt-get install -y \
    libmagic1 \
    && rm -rf /var/lib/apt/lists/*

# Copy Python packages from builder
COPY --from=builder /root/.local /root/.local

# Copy application code
COPY . .

# Create directories for generated reports and logs
RUN mkdir -p /app/generated_report /app/logs

# Set environment variables
ENV PATH=/root/.local/bin:$PATH
ENV PYTHONUNBUFFERED=1
ENV PORT=8000

# Expose port
EXPOSE 8000

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=40s --retries=3 \
  CMD python -c "import requests; requests.get('http://localhost:8000/health', timeout=5)" || exit 1

# Run the application
CMD ["uvicorn", "research_and_analyst.api.main:app", "--host", "0.0.0.0", "--port", "8000"]
```

### Step 5: Create Jenkinsfile

Create a `Jenkinsfile` in your project root:

```groovy
pipeline {
    agent any
    
    environment {
        // Azure credentials from Jenkins
        AZURE_CLIENT_ID = credentials('azure-client-id')
        AZURE_CLIENT_SECRET = credentials('azure-client-secret')
        AZURE_TENANT_ID = credentials('azure-tenant-id')
        AZURE_SUBSCRIPTION_ID = credentials('azure-subscription-id')
        
        // ACR credentials
        ACR_USERNAME = credentials('acr-username')
        ACR_PASSWORD = credentials('acr-password')
        
        // Storage credentials
        STORAGE_ACCOUNT_NAME = credentials('storage-account-name')
        STORAGE_ACCOUNT_KEY = credentials('storage-account-key')
        
        // API Keys (add these to Jenkins)
        OPENAI_API_KEY = credentials('openai-api-key')
        GOOGLE_API_KEY = credentials('google-api-key')
        GROQ_API_KEY = credentials('groq-api-key')
        TAVILY_API_KEY = credentials('tavily-api-key')
        LLM_PROVIDER = credentials('llm-provider')
        
        // App configuration
        APP_RESOURCE_GROUP = 'research-report-app-rg'
        APP_NAME = 'research-report-app'
        ACR_NAME = 'researchreportacr'
        IMAGE_NAME = 'research-report-app'
        CONTAINER_ENV = 'research-report-env'
    }
    
    stages {
        stage('Checkout') {
            steps {
                echo '📥 Checking out code from Git...'
                checkout scm
            }
        }
        
        stage('Setup Python Environment') {
            steps {
                echo '🐍 Setting up Python environment...'
                sh '''
                    python3 --version
                    python3 -m pip install --upgrade pip
                '''
            }
        }
        
        stage('Install Dependencies') {
            steps {
                echo '📦 Installing Python dependencies...'
                sh '''
                    pip install -r requirements.txt
                '''
            }
        }
        
        stage('Run Tests') {
            steps {
                echo '🧪 Running tests...'
                sh '''
                    # Add your test commands here
                    # For now, just verify imports work
                    python3 -c "from research_and_analyst.api.main import app; print('✅ Imports successful')"
                '''
            }
        }
        
        stage('Login to Azure') {
            steps {
                echo '🔐 Logging in to Azure...'
                sh '''
                    az login --service-principal \
                      -u $AZURE_CLIENT_ID \
                      -p $AZURE_CLIENT_SECRET \
                      --tenant $AZURE_TENANT_ID
                    
                    az account set --subscription $AZURE_SUBSCRIPTION_ID
                '''
            }
        }
        
        stage('Verify Docker Image in ACR') {
            steps {
                echo '🔍 Verifying Docker image exists in ACR...'
                sh '''
                    # Login to ACR
                    az acr login --name $ACR_NAME
                    
                    # Check if image exists
                    if az acr repository show --name $ACR_NAME --repository $IMAGE_NAME > /dev/null 2>&1; then
                        echo "✅ Image found in ACR"
                        az acr repository show-tags --name $ACR_NAME --repository $IMAGE_NAME --output table
                    else
                        echo "❌ Image not found in ACR"
                        echo "Please run: ./build-and-push-docker-image.sh"
                        exit 1
                    fi
                '''
            }
        }
        
        stage('Deploy to Azure Container Apps') {
            steps {
                echo '🚀 Deploying to Azure Container Apps...'
                sh '''
                    # Check if Container App exists
                    if az containerapp show \
                      --name $APP_NAME \
                      --resource-group $APP_RESOURCE_GROUP > /dev/null 2>&1; then
                        echo "📝 Updating existing Container App..."
                        az containerapp update \
                          --name $APP_NAME \
                          --resource-group $APP_RESOURCE_GROUP \
                          --image ${ACR_NAME}.azurecr.io/${IMAGE_NAME}:latest
                    else
                        echo "🆕 Creating new Container App..."
                        az containerapp create \
                          --name $APP_NAME \
                          --resource-group $APP_RESOURCE_GROUP \
                          --environment $CONTAINER_ENV \
                          --image ${ACR_NAME}.azurecr.io/${IMAGE_NAME}:latest \
                          --registry-server ${ACR_NAME}.azurecr.io \
                          --registry-username $ACR_USERNAME \
                          --registry-password $ACR_PASSWORD \
                          --target-port 8000 \
                          --ingress external \
                          --min-replicas 1 \
                          --max-replicas 3 \
                          --cpu 1.0 \
                          --memory 2.0Gi \
                          --env-vars \
                            OPENAI_API_KEY=secretref:openai-api-key \
                            GOOGLE_API_KEY=secretref:google-api-key \
                            GROQ_API_KEY=secretref:groq-api-key \
                            TAVILY_API_KEY=secretref:tavily-api-key \
                            LLM_PROVIDER=$LLM_PROVIDER
                        
                        # Set secrets
                        az containerapp secret set \
                          --name $APP_NAME \
                          --resource-group $APP_RESOURCE_GROUP \
                          --secrets \
                            openai-api-key=$OPENAI_API_KEY \
                            google-api-key=$GOOGLE_API_KEY \
                            groq-api-key=$GROQ_API_KEY \
                            tavily-api-key=$TAVILY_API_KEY
                    fi
                '''
            }
        }
        
        stage('Verify Deployment') {
            steps {
                echo '✅ Verifying deployment...'
                sh '''
                    # Get app URL
                    APP_URL=$(az containerapp show \
                      --name $APP_NAME \
                      --resource-group $APP_RESOURCE_GROUP \
                      --query properties.configuration.ingress.fqdn -o tsv)
                    
                    echo "🌐 Application URL: https://$APP_URL"
                    
                    # Wait for app to be ready
                    echo "⏳ Waiting for application to be ready..."
                    sleep 30
                    
                    # Health check
                    if curl -f -s https://$APP_URL > /dev/null; then
                        echo "✅ Application is responding!"
                    else
                        echo "⚠️  Application may still be starting up..."
                    fi
                '''
            }
        }
    }
    
    post {
        success {
            echo '✅ Pipeline completed successfully!'
        }
        failure {
            echo '❌ Pipeline failed!'
        }
        always {
            echo '🧹 Cleaning up workspace...'
            cleanWs()
        }
    }
}
```

### Step 6: Deploy Jenkins Infrastructure

```bash
./azure-deploy-jenkins.sh
```

**Wait time:** ~7-10 minutes (includes Docker image build and push)

**Expected output:**
```
╔════════════════════════════════════════════════════════╗
║           Deployment Complete!                         ║
╚════════════════════════════════════════════════════════╝

🌐 Jenkins URL: http://jenkins-research-12345.eastus.azurecontainer.io:8080
```

### Step 7: Configure Jenkins

#### 7.1. Access Jenkins
- Open the Jenkins URL from Step 6
- Wait 2-3 minutes for Jenkins to fully start

#### 7.2. Get Initial Admin Password
```bash
az container exec \
  --resource-group research-report-jenkins-rg \
  --name jenkins-research-report \
  --exec-command "cat /var/jenkins_home/secrets/initialAdminPassword"
```

#### 7.3. Complete Jenkins Setup
1. Enter the admin password
2. Click "Install suggested plugins"
3. **IMPORTANT:** Ensure "GitHub Plugin" is installed
4. Create your admin user account
5. Confirm Jenkins URL

#### 7.4. Create Azure Service Principal

```bash
# Create service principal
az ad sp create-for-rbac \
  --name "jenkins-research-report-sp" \
  --role Contributor \
  --scopes /subscriptions/$(az account show --query id -o tsv)

# Save the output! You'll need:
# - appId
# - password
# - tenant
```

#### 7.5. Add Credentials to Jenkins

**⚠️ IMPORTANT:** The Jenkinsfile references these credentials by their exact IDs. You MUST use the exact credential IDs shown below!

**Step-by-Step Navigation:**

1. Open Jenkins in your browser: `http://<jenkins-url>:8080`
2. Click **"Manage Jenkins"** in the left sidebar
3. Click **"Manage Credentials"** (under Security section)
4. Click **"System"** (the link, not the arrow)
5. Click **"Global credentials (unrestricted)"**
6. Click **"Add Credentials"** button (top right)

**For Each Credential Below:**

Configure these settings:
- **Kind**: Select `Secret text`
- **Scope**: Leave as `Global (Jenkins, nodes, items, all child items, etc)`
- **Secret**: Paste the actual value (API key, password, etc.)
- **ID**: Enter the exact credential ID from the table below
- **Description**: Optional (e.g., "Azure Service Principal App ID")

Then click **"Create"** or **"OK"**

---

**Credentials to Add:**

**Azure Credentials (4 credentials):**

| # | Credential ID | Where to Get Value | Example |
|---|--------------|-------------------|---------|
| 1 | `azure-client-id` | The `appId` from service principal output | `12345678-1234-1234-1234-123456789abc` |
| 2 | `azure-client-secret` | The `password` from service principal output | `abc123def456...` |
| 3 | `azure-tenant-id` | The `tenant` from service principal output | `87654321-4321-4321-4321-cba987654321` |
| 4 | `azure-subscription-id` | Run: `az account show --query id -o tsv` | `b6b92283-b02e-44ff-aacf-0d08ed9e5bf4` |

**LLM Provider API Keys (4 credentials):**

| # | Credential ID | Where to Get Value | Required? |
|---|--------------|-------------------|-----------|
| 5 | `openai-api-key` | Your OpenAI API key from https://platform.openai.com/api-keys | If using OpenAI |
| 6 | `google-api-key` | Your Google API key from Google AI Studio | If using Google Gemini |
| 7 | `groq-api-key` | Your Groq API key from https://console.groq.com | If using Groq |
| 8 | `tavily-api-key` | Your Tavily API key from https://tavily.com | **✅ REQUIRED!** |

**LLM Provider Selection (1 credential):**

| # | Credential ID | Value Options | Your Choice |
|---|--------------|---------------|-------------|
| 9 | `llm-provider` | Type exactly: `openai` OR `google` OR `groq` | Example: `openai` |

**✅ Checklist:** After adding all 9 credentials above, you should have:
- [ ] 4 Azure credentials
- [ ] 3-4 LLM API keys (at least 1 + Tavily)
- [ ] 1 LLM provider selection

**⚠️ Note:** You'll add 4 more credentials (ACR and storage) in Step 8 after running `setup-app-infrastructure.sh`

### Step 8: Setup Application Infrastructure

```bash
./setup-app-infrastructure.sh
```

**Expected output** will include important credentials. **SAVE THESE!**

The script will display something like:

```
┌─────────────────────────────────────────────────────────┐
│ Credential ID: acr-username                             │
│ Value: researchreportacr                                │
└─────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────┐
│ Credential ID: acr-password                             │
│ Value: xyz123abc456def789...                            │
└─────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────┐
│ Credential ID: storage-account-name                     │
│ Value: reportapp1234567                                 │
└─────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────┐
│ Credential ID: storage-account-key                      │
│ Value: abcdefgh123456789...                             │
└─────────────────────────────────────────────────────────┘
```

**Now add these 4 credentials to Jenkins:**

Go back to Jenkins credentials page (same navigation as Step 7.5) and add:

| # | Credential ID | Value | From Where |
|---|--------------|-------|------------|
| 10 | `acr-username` | From script output above | ACR username |
| 11 | `acr-password` | From script output above | ACR password |
| 12 | `storage-account-name` | From script output above | Storage account name |
| 13 | `storage-account-key` | From script output above | Storage account key |

**✅ Total Credentials Check:** You should now have **13 credentials** in Jenkins:
- [ ] 4 Azure credentials (client-id, client-secret, tenant-id, subscription-id)
- [ ] 4 LLM credentials (openai/google/groq keys + tavily)
- [ ] 1 LLM provider selection
- [ ] 4 Infrastructure credentials (ACR + Storage)

**Verify:** In Jenkins, go to **Manage Jenkins → Manage Credentials → System → Global credentials** and count them!

### Step 9: Add Health Check Endpoint

Before building the Docker image, add a health check endpoint to your FastAPI app.

Edit `research_and_analyst/api/main.py` and add:

```python
@app.get("/health")
async def health_check():
    """Health check endpoint for container orchestration"""
    return {
        "status": "healthy",
        "service": "research-report-generation",
        "timestamp": datetime.now().isoformat()
    }
```

### Step 10: Build and Push Docker Image

```bash
# Build and push with latest tag
./build-and-push-docker-image.sh

# Or with a specific version
./build-and-push-docker-image.sh v1.0.0
```

### Step 11: Create Jenkins Pipeline Job

#### 11.1. Create New Pipeline
1. In Jenkins, click **"New Item"**
2. Enter name: `Research-Report-Pipeline`
3. Select **"Pipeline"**
4. Click **OK**

#### 11.2. Configure Pipeline

**General Section:**
- ✅ Check "GitHub project"
- Project url: `https://github.com/YOUR-USERNAME/YOUR-REPO/`

**Build Triggers:**
- ✅ Check "GitHub hook trigger for GITScm polling"

**Pipeline Section:**
- Definition: **"Pipeline script from SCM"**
- SCM: **Git**
- Repository URL: `https://github.com/YOUR-USERNAME/YOUR-REPO.git`
- Credentials: None (for public repos)
- Branch Specifier: `*/main` (or your branch name)
- Script Path: `Jenkinsfile`

Click **Save**

### Step 12: Configure GitHub Webhook

#### 12.1. Get Jenkins URL
```bash
az container show \
  -g research-report-jenkins-rg \
  -n jenkins-research-report \
  --query "ipAddress.fqdn" -o tsv
```

#### 12.2. Add Webhook in GitHub
1. Go to your GitHub repository
2. Click **Settings** → **Webhooks** → **Add webhook**
3. Configure:
   - **Payload URL:** `http://<jenkins-url>:8080/github-webhook/`
   - **Content type:** `application/json`
   - **Which events:** Just the push event
   - **Active:** ✅ Checked
4. Click **Add webhook**

### Step 13: Run the Pipeline

#### 13.1. Manual Build (First Time)
1. Go to `Research-Report-Pipeline`
2. Click **"Build Now"**
3. Watch progress in **"Console Output"**

#### 13.2. Get Application URL

```bash
az containerapp show \
  --name research-report-app \
  --resource-group research-report-app-rg \
  --query properties.configuration.ingress.fqdn -o tsv
```

#### 13.3. Test Your Application

```bash
# Get the URL
APP_URL=$(az containerapp show \
  --name research-report-app \
  --resource-group research-report-app-rg \
  --query properties.configuration.ingress.fqdn -o tsv)

# Test it
echo "🌐 Application URL: https://$APP_URL"
curl -I https://$APP_URL

# Open in browser
open https://$APP_URL  # macOS
# or
xdg-open https://$APP_URL  # Linux
# or navigate manually on Windows
```

---

## ⚙️ Configuration

### Environment Variables

The application requires the following environment variables:

| Variable | Required | Description |
|----------|----------|-------------|
| `OPENAI_API_KEY` | Optional* | OpenAI API key |
| `GOOGLE_API_KEY` | Optional* | Google Gemini API key |
| `GROQ_API_KEY` | Optional* | Groq API key |
| `TAVILY_API_KEY` | **Required** | Tavily web search API key |
| `LLM_PROVIDER` | **Required** | Choose: `openai`, `google`, or `groq` |

*At least one LLM provider API key is required

### Persistent Storage

The deployment uses Azure File Share for persistent storage:

- **Generated Reports**: `/app/generated_report` (mounted from Azure File Share)
- **SQLite Database**: `/app/users.db` (persisted)
- **Application Logs**: `/app/logs` (persisted)

---

## 📊 Monitoring & Maintenance

### Monitor Application Logs

```bash
# Real-time logs
az containerapp logs show \
  -n research-report-app \
  -g research-report-app-rg \
  --follow

# Last 100 lines
az containerapp logs show \
  -n research-report-app \
  -g research-report-app-rg \
  --tail 100
```

### Monitor Jenkins Logs

```bash
# Jenkins container logs
az container logs \
  -g research-report-jenkins-rg \
  -n jenkins-research-report \
  --tail 100
```

### Check Application Status

```bash
az containerapp show \
  -n research-report-app \
  -g research-report-app-rg \
  --query "{Name:name, Status:properties.runningStatus, URL:properties.configuration.ingress.fqdn}" \
  -o table
```

### Check Metrics

```bash
# Get application metrics
az monitor metrics list \
  --resource $(az containerapp show \
    -n research-report-app \
    -g research-report-app-rg \
    --query id -o tsv) \
  --metric "Requests" \
  --interval PT1M
```

### Scale Application

```bash
# Scale up
az containerapp update \
  --name research-report-app \
  --resource-group research-report-app-rg \
  --min-replicas 2 \
  --max-replicas 5

# Scale down
az containerapp update \
  --name research-report-app \
  --resource-group research-report-app-rg \
  --min-replicas 0 \
  --max-replicas 1
```

### Update Application

```bash
# 1. Make code changes
# 2. Build new Docker image
./build-and-push-docker-image.sh v1.1.0

# 3. Push to Git (triggers Jenkins)
git add .
git commit -m "Update: new feature"
git push

# Jenkins will automatically deploy!
```

---
