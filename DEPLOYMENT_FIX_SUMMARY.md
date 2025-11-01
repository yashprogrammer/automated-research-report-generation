# Jenkins Deployment Fix - Summary

## Problem
The Jenkins pipeline was failing with Git safe.directory errors when trying to checkout the repository:
```
warning: safe.directory ''*'' not absolute
fatal: not in a git directory
ERROR: Error fetching remote repo 'origin'
```

## Root Cause
Git security feature requires directories to be marked as "safe" before it can operate in them. The Jenkins container didn't have Git installed or properly configured.

## Solution Implemented

### 1. Custom Jenkins Dockerfile (`Dockerfile.jenkins`)
Created a custom Jenkins Docker image that:
- Installs Git, Python 3.11, Azure CLI, and Docker CLI
- Pre-configures Git safe.directory settings at build time
- Uses system-wide and global Git configuration to allow all workspace directories

**Key Configuration:**
```dockerfile
RUN git config --system --add safe.directory "*" && \
    git config --global --add safe.directory "*"
```

### 2. Updated Deployment Script (`azure-deploy-jenkins.sh`)
Modified to:
- Build the custom Jenkins Docker image locally
- Push the image to Azure Container Registry (ACR)
- Deploy Jenkins container using the custom image from ACR

**New Deployment Flow:**
1. Create ACR
2. Build `Dockerfile.jenkins` → custom Jenkins image
3. Push image to ACR
4. Deploy container from ACR with pre-configured Git settings

### 3. Updated Documentation (`docs/AZURE_DEPLOYMENT_GUIDE.md`)
- Added Step 2: Create Custom Jenkins Dockerfile
- Updated all subsequent step numbers
- Added comprehensive troubleshooting section
- Included container accessibility troubleshooting

## Files Changed

1. **NEW:** `Dockerfile.jenkins` - Custom Jenkins image definition
2. **MODIFIED:** `azure-deploy-jenkins.sh` - Builds and uses custom image
3. **MODIFIED:** `docs/AZURE_DEPLOYMENT_GUIDE.md` - Updated guide with new approach

## Benefits

✅ **Persistent Fix:** Configuration is baked into the Docker image
✅ **No Manual Commands:** Everything automated in deployment script
✅ **Reproducible:** Same setup every time you deploy
✅ **Version Controlled:** Dockerfile is in your repository
✅ **Complete Tooling:** Jenkins has all required tools (Git, Python, Azure CLI, Docker)

## How to Deploy

### Fresh Deployment
```bash
./azure-deploy-jenkins.sh
```

### If Jenkins Already Exists
```bash
# Delete old container
az container delete -g research-report-jenkins-rg -n jenkins-research-report --yes

# Deploy with new configuration
./azure-deploy-jenkins.sh
```

## Verification

After deployment, verify Git is configured:

```bash
# Check Jenkins logs
az container logs -g research-report-jenkins-rg -n jenkins-research-report --tail 50

# Exec into container to verify Git config
az container exec \
  --resource-group research-report-jenkins-rg \
  --name jenkins-research-report \
  --exec-command "git config --list | grep safe.directory"
```

Expected output:
```
safe.directory=*
```

## Testing the Pipeline

1. Access Jenkins at the URL provided by deployment script
2. Configure credentials (follow guide Step 7)
3. Create pipeline job (follow guide Step 11)
4. Run "Build Now"
5. Checkout stage should succeed without Git errors

## Troubleshooting

### Cannot Access Jenkins URL
- Wait 3-5 minutes after deployment
- Check container logs: `az container logs -g research-report-jenkins-rg -n jenkins-research-report`
- Verify container is running: `az container show -g research-report-jenkins-rg -n jenkins-research-report --query instanceView.state`

### Git Errors Persist
- Ensure you're using the latest deployment script
- Delete and redeploy Jenkins container
- Verify `Dockerfile.jenkins` exists in project root

### Docker Build Fails
- Ensure Docker Desktop is running
- Check you have sufficient disk space
- Verify network connectivity to download base images

## Next Steps

1. Delete old Jenkins container (if exists)
2. Run `./azure-deploy-jenkins.sh`
3. Wait for deployment to complete (~7-10 minutes)
4. Access Jenkins and complete setup
5. Run your pipeline - Git checkout should work!

---

**Date Fixed:** October 30, 2025
**Approach:** Custom Docker image with pre-configured Git settings
**Result:** Permanent, reproducible fix with no manual intervention required

