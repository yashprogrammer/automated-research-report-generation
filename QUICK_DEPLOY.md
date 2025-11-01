# Quick Deployment Guide

## Prerequisites Check
```bash
# Verify installations
az --version
docker --version
git --version

# Login to Azure
az login
```

## Quick Deploy (5 Commands)

### 1. Deploy Jenkins Infrastructure
```bash
./azure-deploy-jenkins.sh
```
⏱️ **Wait:** 7-10 minutes

### 2. Get Jenkins Password
```bash
az container exec \
  --resource-group research-report-jenkins-rg \
  --name jenkins-research-report \
  --exec-command "cat /var/jenkins_home/secrets/initialAdminPassword"
```

### 3. Setup Application Infrastructure
```bash
./setup-app-infrastructure.sh
```
⏱️ **Wait:** 3-5 minutes

### 4. Build Application Image
```bash
./build-and-push-docker-image.sh
```
⏱️ **Wait:** 5-7 minutes

### 5. Get Jenkins URL
```bash
az container show \
  -g research-report-jenkins-rg \
  -n jenkins-research-report \
  --query "ipAddress.fqdn" -o tsv
```

## After Scripts Complete

### Configure Jenkins (Web UI)
1. Open Jenkins URL (from step 5)
2. Enter admin password (from step 2)
3. Install suggested plugins
4. Create admin user

### Add Jenkins Credentials
Navigate: **Manage Jenkins → Manage Credentials → System → Global**

Add these 13 credentials:

**Azure (4):**
- `azure-client-id`
- `azure-client-secret`
- `azure-tenant-id`
- `azure-subscription-id`

**LLM Keys (4):**
- `openai-api-key`
- `google-api-key` 
- `groq-api-key`
- `tavily-api-key` ⚠️ REQUIRED

**LLM Provider (1):**
- `llm-provider` → value: `openai` OR `google` OR `groq`

**Infrastructure (4):**
- `acr-username` (from step 3 output)
- `acr-password` (from step 3 output)
- `storage-account-name` (from step 3 output)
- `storage-account-key` (from step 3 output)

### Create Pipeline
1. New Item → Pipeline → Name: `Research-Report-Pipeline`
2. ✅ GitHub project: `https://github.com/YOUR-USERNAME/YOUR-REPO/`
3. ✅ GitHub hook trigger for GITScm polling
4. Pipeline → SCM: Git
5. Repository URL: `https://github.com/YOUR-USERNAME/YOUR-REPO.git`
6. Branch: `*/main`
7. Script Path: `Jenkinsfile`
8. Save

### Setup GitHub Webhook
1. GitHub Repo → Settings → Webhooks → Add webhook
2. Payload URL: `http://<jenkins-url>:8080/github-webhook/`
3. Content type: `application/json`
4. Events: Just push event
5. Add webhook

### Run Pipeline
1. Click "Build Now"
2. Watch "Console Output"
3. Get app URL:
```bash
az containerapp show \
  --name research-report-app \
  --resource-group research-report-app-rg \
  --query properties.configuration.ingress.fqdn -o tsv
```

## Troubleshooting

### Can't Access Jenkins?
```bash
# Wait 5 minutes, then check logs
az container logs -g research-report-jenkins-rg -n jenkins-research-report --tail 100
```

### Git Checkout Fails?
```bash
# Delete and redeploy
az container delete -g research-report-jenkins-rg -n jenkins-research-report --yes
./azure-deploy-jenkins.sh
```

### Pipeline Fails?
- Verify all 13 credentials are added
- Check credential IDs match exactly
- Ensure Docker image was pushed (step 4)

## Clean Up Everything
```bash
# Delete all resources
az group delete -n research-report-jenkins-rg --yes --no-wait
az group delete -n research-report-app-rg --yes --no-wait
```

## Cost Estimate
- Jenkins: ~$50/month (2 vCPU, 4GB RAM, always on)
- App: ~$30/month (1 vCPU, 2GB RAM, autoscale 1-3)
- Storage: ~$5/month
- ACR: ~$5/month

**Total: ~$90/month**

To reduce costs:
- Pause Jenkins when not deploying
- Scale app to 0-1 replicas
- Use B-tier resources

---

For full guide: See `docs/AZURE_DEPLOYMENT_GUIDE.md`

