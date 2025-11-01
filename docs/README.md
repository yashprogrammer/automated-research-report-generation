# 📚 Documentation Index

Welcome to the documentation for the **Autonomous Research Report Generation System**.

---

## 🚀 Deployment Documentation

### Quick Start
- **[DEPLOYMENT_QUICK_START.md](DEPLOYMENT_QUICK_START.md)**  
  ⚡ TL;DR version - Deploy in 5 steps (~30 minutes)  
  Perfect for: Experienced DevOps engineers who want to get started quickly

### Complete Guide
- **[AZURE_DEPLOYMENT_GUIDE.md](AZURE_DEPLOYMENT_GUIDE.md)**  
  📖 Complete step-by-step deployment guide (~80 sections)  
  Perfect for: First-time deployers, detailed walkthrough of every step  
  Includes: Prerequisites, setup, configuration, troubleshooting, cost management

### Architecture
- **[DEPLOYMENT_ARCHITECTURE.md](DEPLOYMENT_ARCHITECTURE.md)**  
  🏗️ System architecture and design documentation  
  Perfect for: Understanding how everything works together  
  Includes: Architecture diagrams, data flow, security, scaling, monitoring

### Checklist
- **[DEPLOYMENT_CHECKLIST.md](DEPLOYMENT_CHECKLIST.md)**  
  ✅ Printable deployment checklist  
  Perfect for: Following along during deployment, tracking progress  
  **Recommended:** Print this before starting deployment

### Summary
- **[DEPLOYMENT_SUMMARY.md](DEPLOYMENT_SUMMARY.md)**  
  📝 Implementation summary and comparison  
  Perfect for: Understanding what was built, technical specifications  
  Includes: File inventory, adaptations made, metrics, future enhancements

---

## 📡 API Documentation

- **[API_DOCUMENTATION.md](API_DOCUMENTATION.md)**  
  API endpoints, request/response formats, authentication

---

## 🎯 Which Document Should I Read?

### I want to deploy to Azure (first time)
1. Start with: **[DEPLOYMENT_QUICK_START.md](DEPLOYMENT_QUICK_START.md)** - Get an overview
2. Print: **[DEPLOYMENT_CHECKLIST.md](DEPLOYMENT_CHECKLIST.md)** - Track your progress
3. Follow: **[AZURE_DEPLOYMENT_GUIDE.md](AZURE_DEPLOYMENT_GUIDE.md)** - Step-by-step guide
4. If issues: See troubleshooting section in the deployment guide

### I want to understand the system
1. Read: **[DEPLOYMENT_ARCHITECTURE.md](DEPLOYMENT_ARCHITECTURE.md)** - System design
2. Read: **[DEPLOYMENT_SUMMARY.md](DEPLOYMENT_SUMMARY.md)** - Technical specs
3. Read: **[API_DOCUMENTATION.md](API_DOCUMENTATION.md)** - API details

### I already deployed and want to maintain
1. Use: `./check-deployment-status.sh` - Check system health
2. Refer to: **[AZURE_DEPLOYMENT_GUIDE.md](AZURE_DEPLOYMENT_GUIDE.md)** - Monitoring & Maintenance section
3. For updates: See "Update Workflow" in **[DEPLOYMENT_CHECKLIST.md](DEPLOYMENT_CHECKLIST.md)**

### I want to understand costs
1. See: **[DEPLOYMENT_QUICK_START.md](DEPLOYMENT_QUICK_START.md)** - Cost overview
2. Detailed breakdown: **[AZURE_DEPLOYMENT_GUIDE.md](AZURE_DEPLOYMENT_GUIDE.md)** - Cost Management section
3. Scripts: `./pause-services.sh`, `./resume-services.sh`, `./complete-cleanup.sh`

---

## 📂 File Organization

```
docs/
├── README.md                           # This file (documentation index)
├── AZURE_DEPLOYMENT_GUIDE.md           # Complete deployment guide
├── DEPLOYMENT_QUICK_START.md           # Quick reference guide
├── DEPLOYMENT_ARCHITECTURE.md          # Architecture documentation
├── DEPLOYMENT_CHECKLIST.md             # Printable checklist
├── DEPLOYMENT_SUMMARY.md               # Implementation summary
└── API_DOCUMENTATION.md                # API reference
```

---

## 🔧 Deployment Scripts

Located in project root:

| Script | Purpose | Documentation |
|--------|---------|---------------|
| `azure-deploy-jenkins.sh` | Deploy Jenkins infrastructure | See deployment guide Step 2 |
| `setup-app-infrastructure.sh` | Setup app resources | See deployment guide Step 4 |
| `build-and-push-docker-image.sh` | Build Docker image | See deployment guide Step 6 |
| `pause-services.sh` | Pause to save costs | See cost management section |
| `resume-services.sh` | Resume services | See cost management section |
| `check-deployment-status.sh` | Check system health | Use anytime |
| `cleanup-app-only.sh` | Remove app only | See cleanup section |
| `complete-cleanup.sh` | Remove everything | See cleanup section |

---

## 🎓 Learning Path

### Beginner (First Deployment)
```
1. Read DEPLOYMENT_QUICK_START.md (5 min)
2. Print DEPLOYMENT_CHECKLIST.md (1 min)
3. Follow AZURE_DEPLOYMENT_GUIDE.md (30-40 min)
4. Test and verify (5 min)
```

### Intermediate (Understanding the System)
```
1. Read DEPLOYMENT_ARCHITECTURE.md (15 min)
2. Review DEPLOYMENT_SUMMARY.md (10 min)
3. Explore API_DOCUMENTATION.md (10 min)
4. Experiment with management scripts (5 min)
```

### Advanced (Customization & Optimization)
```
1. Study architecture diagrams (20 min)
2. Review Jenkinsfile and Dockerfile (15 min)
3. Read "Advanced Configuration" section (15 min)
4. Implement enhancements from summary (varies)
```

---

## 📊 Documentation Statistics

| Document | Sections | Pages | Est. Reading Time |
|----------|----------|-------|-------------------|
| Quick Start | 10 | 3 | 5 minutes |
| Complete Guide | 80+ | 50+ | 2 hours |
| Architecture | 15 | 20 | 30 minutes |
| Checklist | 8 phases | 6 | N/A (reference) |
| Summary | 20 | 15 | 20 minutes |
| API Docs | Varies | 5 | 15 minutes |

---

## 🆘 Getting Help

### Documentation Issues
- Check the troubleshooting section in the deployment guide
- Review common issues in the quick start guide
- Check logs with `./check-deployment-status.sh`

### Azure Issues
- See [Azure Container Apps Documentation](https://learn.microsoft.com/en-us/azure/container-apps/)
- Check Azure Portal for service health
- Review Azure support resources

### Application Issues
- Check application logs: `az containerapp logs show ...`
- Review the architecture document for understanding
- Verify API keys and environment variables

---

## 🔄 Documentation Updates

This documentation was created on **October 30, 2025** for version **1.0.0** of the deployment system.

### Version History
- **v1.0.0** (Oct 2025) - Initial deployment documentation
  - Complete Azure deployment guide
  - CI/CD with Jenkins
  - Cost management scripts
  - Comprehensive architecture docs

---

## 📝 Contributing to Documentation

If you find errors or want to improve the documentation:

1. Document the issue or improvement
2. Update the relevant markdown file
3. Test the changes (if applicable)
4. Submit via pull request

---

## ✅ Documentation Checklist

Before deploying, ensure you have:

- [ ] Read the Quick Start guide
- [ ] Printed the Deployment Checklist
- [ ] Reviewed prerequisites
- [ ] Prepared all API keys
- [ ] Installed Azure CLI and Docker
- [ ] Have 40 minutes available for deployment

---

## 🎯 Quick Links

### Essential Reading
- [Quick Start](DEPLOYMENT_QUICK_START.md)
- [Deployment Guide](AZURE_DEPLOYMENT_GUIDE.md)
- [Checklist](DEPLOYMENT_CHECKLIST.md)

### Reference
- [Architecture](DEPLOYMENT_ARCHITECTURE.md)
- [API Docs](API_DOCUMENTATION.md)
- [Summary](DEPLOYMENT_SUMMARY.md)

### External Resources
- [Azure Portal](https://portal.azure.com)
- [LangGraph Docs](https://langchain-ai.github.io/langgraph/)
- [FastAPI Docs](https://fastapi.tiangolo.com/)

---

**Happy Deploying! 🚀**

---

*Last Updated: October 30, 2025*  
*Documentation Version: 1.0.0*
