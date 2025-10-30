# Autonomous Research Report Generation System

## 📋 Table of Contents
- [Overview](#overview)
- [Key Features](#key-features)
- [Architecture](#architecture)
- [Tech Stack](#tech-stack)
- [Installation](#installation)
- [Configuration](#configuration)
- [Usage](#usage)
- [API Documentation](#api-documentation)
- [Workflow Details](#workflow-details)
- [Project Structure](#project-structure)
- [Development Guide](#development-guide)
- [Contributing](#contributing)

---

## 🎯 Overview

The **Autonomous Research Report Generation System** is an AI-powered application that automatically generates comprehensive research reports on any given topic. The system uses multiple AI analyst personas to conduct research, gather information from the web, and compile professional reports in both DOCX and PDF formats.

### What It Does

1. **Creates AI Analyst Personas**: Generates specialized AI analysts based on the research topic
2. **Conducts Automated Research**: Each analyst performs web searches and gathers relevant information
3. **Interviews Experts**: Simulates expert interviews to extract detailed insights
4. **Generates Structured Reports**: Compiles findings into well-structured reports with introduction, sections, conclusion, and sources
5. **Human-in-the-Loop**: Allows users to provide feedback to refine analyst perspectives
6. **Multi-format Output**: Exports reports as DOCX and PDF files

---

## ✨ Key Features

### 🤖 Multi-Agent Research System
- **Dynamic Analyst Generation**: Creates specialized AI analysts tailored to your research topic
- **Parallel Processing**: Multiple analysts work simultaneously to cover different perspectives
- **Contextual Research**: Each analyst focuses on specific aspects based on their expertise

### 🔍 Intelligent Research Pipeline
- **Web Search Integration**: Uses Tavily API for real-time web searches
- **Interview-Based Methodology**: Simulates expert interviews to extract detailed insights
- **Citation Management**: Automatically tracks and includes source references

### 👤 Human-in-the-Loop
- **Feedback System**: Provide feedback on analyst selection before research begins
- **Iterative Refinement**: Adjust research direction based on user input
- **Interactive Web UI**: User-friendly dashboard for managing research projects

### 📄 Professional Report Generation
- **Structured Output**: Well-organized reports with introduction, body, and conclusion
- **Multiple Formats**: Generates both DOCX and PDF versions
- **Citation Tracking**: Includes all sources used in the research

### 🔐 User Management
- **Authentication System**: Secure user signup and login
- **Session Management**: Cookie-based session tracking
- **User-Specific Reports**: Each user can manage their own research projects

### 🎨 Modern Web Interface
- **Responsive Design**: Works on desktop and mobile devices
- **Real-time Progress**: Loading indicators during report generation
- **Download Management**: Easy access to generated reports

---

## 🏗️ Architecture

### High-Level Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                        FastAPI Web Server                    │
│  ┌────────────────┐  ┌─────────────────┐  ┌──────────────┐ │
│  │  Authentication │  │  Report Routes  │  │   Templates  │ │
│  │    (Login/Signup) │  │   (Dashboard)   │  │   (Jinja2)   │ │
│  └────────────────┘  └─────────────────┘  └──────────────┘ │
└─────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────┐
│                      Report Service Layer                    │
│  ┌──────────────────────────────────────────────────────┐  │
│  │          AutonomousReportGenerator (LangGraph)        │  │
│  │                                                        │  │
│  │  ┌──────────────┐         ┌──────────────────────┐  │  │
│  │  │   Create     │────────▶│  Human Feedback Node │  │  │
│  │  │   Analysts   │         └──────────────────────┘  │  │
│  │  └──────────────┘                    │               │  │
│  │         │                             ▼               │  │
│  │         │                  ┌──────────────────────┐  │  │
│  │         └─────────────────▶│  Conduct Interviews  │  │  │
│  │                            │   (Parallel Agents)   │  │  │
│  │                            └──────────────────────┘  │  │
│  │                                      │               │  │
│  │         ┌────────────────────────────┴───────┐      │  │
│  │         ▼                ▼                    ▼      │  │
│  │  ┌────────────┐  ┌─────────────┐  ┌──────────────┐│  │
│  │  │   Write    │  │    Write    │  │    Write     ││  │
│  │  │Introduction│  │   Report    │  │  Conclusion  ││  │
│  │  └────────────┘  └─────────────┘  └──────────────┘│  │
│  │         │                ▼                    │      │  │
│  │         └───────────────▶┌────────────────┐◀─┘      │  │
│  │                          │ Finalize Report│          │  │
│  │                          └────────────────┘          │  │
│  └──────────────────────────────────────────────────────┘  │
└─────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────┐
│                    Interview Workflow (Per Analyst)          │
│                                                              │
│  Ask Question → Web Search → Generate Answer                │
│       ↓             ↓              ↓                         │
│  Save Interview → Write Section                             │
└─────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────┐
│                    External Services                         │
│  ┌─────────────┐  ┌─────────────┐  ┌──────────────────┐   │
│  │ LLM Provider│  │ Tavily API  │  │  SQLite Database │   │
│  │(OpenAI/Groq │  │(Web Search) │  │  (User Auth)     │   │
│  │ /Gemini)    │  │             │  │                  │   │
│  └─────────────┘  └─────────────┘  └──────────────────┘   │
└─────────────────────────────────────────────────────────────┘
```

### Workflow Diagram

```
1. User submits research topic
        ↓
2. System creates specialized analyst personas
        ↓
3. User provides feedback (optional)
        ↓
4. Each analyst:
   • Formulates questions
   • Searches the web
   • Gathers information
   • Writes a report section
        ↓
5. System compiles:
   • Introduction
   • All analyst sections
   • Conclusion
   • Source citations
        ↓
6. Report saved as DOCX + PDF
        ↓
7. User downloads reports
```

---

## 🛠️ Tech Stack

### Backend
- **FastAPI** - Modern Python web framework for building APIs
- **LangGraph** - Framework for building stateful, multi-agent workflows
- **LangChain** - LLM orchestration and integration
- **SQLAlchemy** - SQL toolkit and ORM
- **SQLite** - Lightweight database for user management

### AI/ML
- **LLM Providers**:
  - OpenAI (GPT-4o)
  - Google Gemini (2.0 Flash)
  - Groq (DeepSeek R1 Distill Llama 70B)
- **Tavily API** - Web search and information retrieval
- **LangChain Community** - Additional integrations

### Frontend
- **Jinja2** - Server-side templating engine
- **HTML/CSS/JavaScript** - Modern responsive UI
- **Bootstrap-style CSS** - Clean, professional design

### Document Generation
- **python-docx** - DOCX file generation
- **ReportLab** - PDF file generation

### Logging & Monitoring
- **structlog** - Structured logging with JSON output
- **Custom Logger** - Timestamped log files

### Authentication
- **Passlib** - Password hashing and verification
- **bcrypt** - Secure password hashing algorithm

---

## 📦 Installation

### Prerequisites
- Python 3.11 or higher
- pip or uv package manager
- Git

### Step 1: Clone the Repository

```bash
git clone <repository-url>
cd automated-research-report-generation-1
```

### Step 2: Create Virtual Environment

```bash
# Using venv
python -m venv venv
source venv/bin/activate  # On Windows: venv\Scripts\activate

# Or using uv
uv venv
source .venv/bin/activate
```

### Step 3: Install Dependencies

```bash
# Using pip
pip install -r requirements.txt

# Or using uv
uv pip install -r requirements.txt
```

### Step 4: Set Up Environment Variables

Create a `.env` file in the root directory:

```bash
# LLM Provider (choose one: openai, google, groq)
LLM_PROVIDER=openai

# API Keys
OPENAI_API_KEY=your_openai_api_key_here
GOOGLE_API_KEY=your_google_api_key_here
GROQ_API_KEY=your_groq_api_key_here

# Tavily API (for web search)
TAVILY_API_KEY=your_tavily_api_key_here
```

### Step 5: Initialize Database

The database will be automatically created on first run, but you can initialize it manually:

```python
from research_and_analyst.database.db_config import Base, engine
Base.metadata.create_all(bind=engine)
```

---

## ⚙️ Configuration

### LLM Configuration

Edit `research_and_analyst/config/configuration.yaml`:

```yaml
llm:
  groq:
    provider: "groq"
    model_name: "deepseek-r1-distill-llama-70b"
    temperature: 0
    max_output_tokens: 2048

  google:
    provider: "google"
    model_name: "gemini-2.0-flash"
    temperature: 0
    max_output_tokens: 2048

  openai:
    provider: "openai"
    model_name: "gpt-4o"
    temperature: 0
```

### Embedding Model Configuration

```yaml
embedding_model:
  provider: "google"
  model_name: "models/text-embedding-004"
```

### Retriever Settings

```yaml
retriever:
  top_k: 4
```

---

## 🚀 Usage

### Starting the Web Server

```bash
uvicorn research_and_analyst.api.main:app --reload
```

The server will start at `http://localhost:8000`

### Using the Web Interface

1. **Sign Up / Login**
   - Navigate to `http://localhost:8000`
   - Create a new account or login with existing credentials

2. **Generate a Report**
   - Enter your research topic in the dashboard
   - Click "Generate Report"
   - Wait for analyst personas to be created

3. **Provide Feedback (Optional)**
   - Review the generated analyst personas
   - Provide feedback to refine the research direction
   - Submit feedback to continue

4. **Download Reports**
   - Once generation is complete, download DOCX or PDF versions
   - Reports are organized in folders by topic and timestamp

### Programmatic Usage

```python
from research_and_analyst.utils.model_loader import ModelLoader
from research_and_analyst.workflows.report_generator_workflow import AutonomousReportGenerator

# Initialize
llm = ModelLoader().load_llm()
reporter = AutonomousReportGenerator(llm)
graph = reporter.build_graph()

# Generate report
topic = "Impact of AI on Healthcare"
thread = {"configurable": {"thread_id": "1"}}

# Start the workflow
for _ in graph.stream({"topic": topic, "max_analysts": 3}, thread, stream_mode="values"):
    pass

# Provide feedback (optional)
graph.update_state(thread, {"human_analyst_feedback": "Focus on clinical applications"}, as_node="human_feedback")

# Continue workflow
for _ in graph.stream(None, thread, stream_mode="values"):
    pass

# Get final report
final_state = graph.get_state(thread)
final_report = final_state.values.get("final_report")

# Save report
if final_report:
    reporter.save_report(final_report, topic, "docx")
    reporter.save_report(final_report, topic, "pdf")
```

---

## 📡 API Documentation

### Authentication Endpoints

#### GET `/`
**Description**: Login page  
**Returns**: HTML login form

#### POST `/login`
**Description**: Authenticate user  
**Parameters**:
- `username` (form): Username
- `password` (form): Password

**Returns**: Redirects to dashboard on success

#### GET `/signup`
**Description**: Signup page  
**Returns**: HTML signup form

#### POST `/signup`
**Description**: Create new user account  
**Parameters**:
- `username` (form): Desired username
- `password` (form): Password

**Returns**: Redirects to login on success

### Report Generation Endpoints

#### GET `/dashboard`
**Description**: User dashboard  
**Authentication**: Required (session cookie)  
**Returns**: HTML dashboard with report generation form

#### POST `/generate_report`
**Description**: Start autonomous report generation  
**Authentication**: Required  
**Parameters**:
- `topic` (form): Research topic

**Returns**: Report progress page with thread_id

#### POST `/submit_feedback`
**Description**: Submit human feedback to refine analysts  
**Authentication**: Required  
**Parameters**:
- `topic` (form): Research topic
- `feedback` (form): User feedback text
- `thread_id` (form): Workflow thread ID

**Returns**: Updated progress page or download links

#### GET `/download/{file_name}`
**Description**: Download generated report  
**Authentication**: Required  
**Parameters**:
- `file_name` (path): Name of the file to download

**Returns**: File download response

---

## 🔄 Workflow Details

### Report Generation Workflow

The system uses LangGraph to orchestrate a complex, stateful workflow:

#### 1. Create Analysts Node
```python
def create_analyst(state: GenerateAnalystsState):
    """
    Generates specialized AI analyst personas based on:
    - Research topic
    - Number of analysts requested (default: 3)
    - Human feedback (if provided)
    
    Returns:
    - List of Analyst objects with roles and personas
    """
```

**Analyst Structure**:
- `name`: Analyst's name
- `role`: Their role in the research
- `affiliation`: Organization/perspective
- `description`: Focus areas and objectives

#### 2. Human Feedback Node (Interrupt Point)
```python
def human_feedback():
    """
    Pause point for human-in-the-loop interaction.
    Allows users to:
    - Review generated analysts
    - Provide feedback for refinement
    - Continue with or without modifications
    """
```

#### 3. Conduct Interviews (Parallel Processing)
Each analyst goes through the **Interview Workflow**:

**Step 3a: Generate Question**
- Analyst formulates questions based on their persona
- Questions are specific to their area of expertise

**Step 3b: Search Web**
- Converts question to search query
- Uses Tavily API to fetch relevant web content
- Gathers context from multiple sources

**Step 3c: Generate Answer**
- Expert AI uses gathered context to answer
- Includes source citations
- Maintains conversation thread

**Step 3d: Save Interview**
- Stores complete conversation transcript
- Tracks all questions and answers

**Step 3e: Write Section**
- Compiles interview into a report section
- Structured with headers and citations
- Formatted in markdown

#### 4. Write Report Components (Parallel)

**Write Introduction**
- Creates compelling opening
- Previews report sections
- Sets context for the research

**Write Report Body**
- Consolidates all analyst sections
- Removes redundancies
- Maintains narrative flow
- Preserves all citations

**Write Conclusion**
- Summarizes key findings
- Ties together all insights
- Provides closure

#### 5. Finalize Report
```python
def finalize_report(state: ResearchGraphState):
    """
    Assembles final report structure:
    1. Introduction
    2. Main content (from all analysts)
    3. Conclusion
    4. Consolidated sources list
    
    Ensures proper formatting and citation management
    """
```

#### 6. Save Reports
- Generates DOCX version (formatted Word document)
- Generates PDF version (centered, professional layout)
- Organizes in topic-based folders with timestamps

### Interview Workflow (Per Analyst)

```
┌───────────────────────────────────────────┐
│  1. Ask Question                          │
│     • Analyst formulates research question│
│     • Based on persona and goals          │
└───────────────┬───────────────────────────┘
                ▼
┌───────────────────────────────────────────┐
│  2. Search Web                            │
│     • Generate search query               │
│     • Execute Tavily search               │
│     • Gather relevant documents           │
└───────────────┬───────────────────────────┘
                ▼
┌───────────────────────────────────────────┐
│  3. Generate Answer                       │
│     • Expert AI responds using context    │
│     • Includes citations                  │
│     • Maintains conversation flow         │
└───────────────┬───────────────────────────┘
                ▼
┌───────────────────────────────────────────┐
│  4. Save Interview                        │
│     • Store complete transcript           │
│     • Preserve context for report writing │
└───────────────┬───────────────────────────┘
                ▼
┌───────────────────────────────────────────┐
│  5. Write Section                         │
│     • Compile findings into report section│
│     • Format with headers and citations   │
│     • Create structured markdown          │
└───────────────────────────────────────────┘
```

### State Management

The system uses **MemorySaver** (LangGraph checkpointing) to:
- Track workflow progress
- Enable pause/resume functionality
- Support human-in-the-loop interactions
- Maintain conversation context across steps

---

## 📁 Project Structure

```
automated-research-report-generation-1/
├── research_and_analyst/          # Main application package
│   ├── __init__.py
│   │
│   ├── api/                        # FastAPI web application
│   │   ├── __init__.py
│   │   ├── main.py                 # FastAPI app initialization
│   │   ├── models/
│   │   │   └── request_models.py   # API request models
│   │   ├── routes/
│   │   │   └── report_routes.py    # Route handlers
│   │   ├── services/
│   │   │   └── report_service.py   # Business logic layer
│   │   └── templates/              # Jinja2 HTML templates
│   │       ├── dashboard.html      # Main dashboard
│   │       ├── login.html          # Login page
│   │       ├── signup.html         # Signup page
│   │       └── report_progress.html # Progress tracking
│   │
│   ├── config/                     # Configuration management
│   │   └── configuration.yaml      # LLM and model settings
│   │
│   ├── database/                   # Database layer
│   │   └── db_config.py            # SQLAlchemy setup and models
│   │
│   ├── exception/                  # Error handling
│   │   ├── __init__.py
│   │   └── custom_exception.py     # Custom exception classes
│   │
│   ├── logger/                     # Logging infrastructure
│   │   ├── __init__.py
│   │   └── custom_logger.py        # Structlog configuration
│   │
│   ├── prompt_lib/                 # Prompt templates
│   │   ├── __init__.py
│   │   └── prompt_locator.py       # Jinja2 prompt templates
│   │
│   ├── schemas/                    # Data models
│   │   ├── __init__.py
│   │   └── models.py               # Pydantic models for state
│   │
│   ├── utils/                      # Utility modules
│   │   ├── __init__.py
│   │   ├── config_loader.py        # YAML config loader
│   │   └── model_loader.py         # LLM and embedding loaders
│   │
│   └── workflows/                  # LangGraph workflows
│       ├── __init__.py
│       ├── interview_workflow.py   # Interview graph builder
│       └── report_generator_workflow.py # Main report workflow
│
├── static/                         # Static web assets
│   ├── css/
│   │   └── styles.css              # Application styles
│   └── js/
│       └── app.js                  # Frontend JavaScript
│
├── generated_report/               # Output directory
│   └── [topic]_[timestamp]/        # Reports organized by topic
│       ├── [report].docx           # Word document
│       └── [report].pdf            # PDF document
│
├── logs/                           # Application logs (generated)
│   └── [timestamp].log             # Timestamped log files
│
├── .env                            # Environment variables (not in repo)
├── requirements.txt                # Python dependencies
├── pyproject.toml                  # Project metadata
├── main.py                         # CLI entry point
├── users.db                        # SQLite database (generated)
├── uv.lock                         # UV lock file
└── README.md                       # This file
```

### Key Files Explained

#### Core Workflows
- **`report_generator_workflow.py`**: Main orchestration logic using LangGraph
- **`interview_workflow.py`**: Per-analyst research and interview process

#### API Layer
- **`main.py`**: FastAPI app setup, CORS, static files
- **`report_routes.py`**: All HTTP endpoints
- **`report_service.py`**: Business logic and graph execution

#### Configuration
- **`configuration.yaml`**: LLM settings, model selection
- **`model_loader.py`**: Dynamic model loading based on config

#### Data Models
- **`models.py`**: Pydantic schemas for type safety and validation
- **`db_config.py`**: SQLAlchemy models and authentication

#### Prompts
- **`prompt_locator.py`**: Jinja2 templates for all AI prompts

---

## 🔧 Development Guide

### Setting Up Development Environment

1. **Install development tools**:
```bash
pip install pytest black flake8 mypy
```

2. **Run in development mode**:
```bash
uvicorn research_and_analyst.api.main:app --reload --port 8000
```

### Code Style

- **Formatting**: Use `black` for code formatting
- **Linting**: Use `flake8` for linting
- **Type Checking**: Use `mypy` for type hints

### Project Standards

#### Logging
```python
from research_and_analyst.logger import GLOBAL_LOGGER

logger = GLOBAL_LOGGER.bind(module="YourModule")
logger.info("Action performed", param1=value1, param2=value2)
logger.error("Error occurred", error=str(e))
```

#### Exception Handling
```python
from research_and_analyst.exception.custom_exception import ResearchAnalystException

try:
    # Your code
    pass
except Exception as e:
    logger.error("Operation failed", error=str(e))
    raise ResearchAnalystException("User-friendly message", e)
```

#### Configuration Loading
```python
from research_and_analyst.utils.config_loader import load_config

config = load_config()
llm_settings = config["llm"]["openai"]
```

### Adding a New LLM Provider

1. **Update configuration.yaml**:
```yaml
llm:
  new_provider:
    provider: "new_provider"
    model_name: "model-name"
    temperature: 0
    max_output_tokens: 2048
```

2. **Update model_loader.py**:
```python
elif provider == "new_provider":
    llm = NewProviderChat(
        model=model_name,
        api_key=self.api_key_mgr.get("NEW_PROVIDER_API_KEY"),
        temperature=temperature,
    )
```

3. **Add to requirements.txt**:
```
langchain-new-provider==x.y.z
```

4. **Update .env template**:
```
NEW_PROVIDER_API_KEY=your_key_here
```

### Testing

#### Manual Testing
```bash
# Test workflow directly
python research_and_analyst/workflows/report_generator_workflow.py
```

#### Unit Tests
```bash
# Run tests (when implemented)
pytest tests/
```

### Debugging

#### Enable Debug Logging
```python
# In custom_logger.py, set level to DEBUG
logging.basicConfig(level=logging.DEBUG)
```

#### View LangGraph State
```python
state = graph.get_state(thread)
print(state.values)
```

#### Inspect Generated Reports
```bash
# Reports are saved in generated_report/
ls -la generated_report/
```

---

## 📊 Performance Considerations

### Optimization Tips

1. **Parallel Processing**: Analysts run in parallel automatically via LangGraph
2. **Caching**: Consider implementing LLM response caching for repeated queries
3. **Rate Limiting**: Implement rate limiting for API endpoints
4. **Database Indexing**: Add indexes on frequently queried columns

### Resource Usage

- **Memory**: ~500MB-1GB during report generation
- **LLM API Calls**: Approximately 20-30 calls per report (varies by complexity)
- **Web Searches**: 2-3 searches per analyst per interview turn

---

## 🐛 Troubleshooting

### Common Issues

#### Issue: "API Key not found"
**Solution**: Ensure `.env` file exists with all required API keys

#### Issue: "Database locked"
**Solution**: SQLite doesn't handle concurrent writes well. Consider PostgreSQL for production.

#### Issue: "Report generation stuck"
**Solution**: Check logs in `logs/` directory. Likely an API rate limit or network issue.

#### Issue: "Import errors"
**Solution**: Ensure all dependencies are installed and virtual environment is activated

#### Issue: "Template not found"
**Solution**: Run from project root directory, or update template paths in `main.py`

### Debug Mode

Enable detailed logging:
```bash
export LOG_LEVEL=DEBUG
uvicorn research_and_analyst.api.main:app --reload
```

---

## 🚀 Deployment

### Azure Deployment (Recommended)

We provide a complete Azure deployment solution with Jenkins CI/CD pipeline. This is the recommended way to deploy the application to production.

**Quick Start:**

```bash
# 1. Deploy Jenkins
./azure-deploy-jenkins.sh

# 2. Setup app infrastructure
./setup-app-infrastructure.sh

# 3. Build and push Docker image
./build-and-push-docker-image.sh

# 4. Configure Jenkins pipeline and deploy!
```

**Documentation:**
- **Full Guide**: [`docs/AZURE_DEPLOYMENT_GUIDE.md`](docs/AZURE_DEPLOYMENT_GUIDE.md) - Complete step-by-step instructions
- **Quick Start**: [`docs/DEPLOYMENT_QUICK_START.md`](docs/DEPLOYMENT_QUICK_START.md) - TL;DR version (5 steps, ~30 min)
- **Architecture**: [`docs/DEPLOYMENT_ARCHITECTURE.md`](docs/DEPLOYMENT_ARCHITECTURE.md) - System architecture and design

**What's Included:**
- ✅ Jenkins CI/CD pipeline on Azure
- ✅ Automated deployments via GitHub webhooks
- ✅ Azure Container Apps for scalable hosting
- ✅ Persistent storage for reports and database
- ✅ HTTPS with auto-generated certificates
- ✅ Cost management scripts (pause/resume/cleanup)
- ✅ Monitoring and health checks

**Estimated Costs:**
- Full deployment: ~$102-166/month
- Paused services: ~$11/month (storage only)
- Zero with complete cleanup

### Production Checklist

- [x] Containerized with Docker
- [x] HTTPS enabled
- [x] Health check endpoint
- [x] Automated CI/CD pipeline
- [x] Scalable infrastructure
- [ ] Use PostgreSQL instead of SQLite (recommended)
- [ ] Implement rate limiting
- [ ] Add Application Insights monitoring
- [ ] Configure custom domain
- [ ] Set up Azure AD authentication (optional)
- [ ] Implement backup automation

### Local Docker Deployment

For local testing, use the included Dockerfile:

```bash
# Build
docker build -t research-report-app .

# Run
docker run -p 8000:8000 \
  -e OPENAI_API_KEY="your-key" \
  -e TAVILY_API_KEY="your-key" \
  -e LLM_PROVIDER="openai" \
  research-report-app
```

### Available Deployment Scripts

| Script | Purpose | Time |
|--------|---------|------|
| `azure-deploy-jenkins.sh` | Deploy Jenkins CI/CD | ~5 min |
| `setup-app-infrastructure.sh` | Setup Azure resources | ~5 min |
| `build-and-push-docker-image.sh` | Build & push Docker image | ~5 min |
| `pause-services.sh` | Pause to save costs | <1 min |
| `resume-services.sh` | Resume services | ~5 min |
| `check-deployment-status.sh` | Check deployment status | <1 min |
| `cleanup-app-only.sh` | Remove app only | ~2 min |
| `complete-cleanup.sh` | Remove everything | ~5 min |

---

## 🤝 Contributing

Contributions are welcome! Please follow these guidelines:

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

### Development Workflow

1. Discuss major changes in issues first
2. Follow existing code style and conventions
3. Add tests for new features
4. Update documentation
5. Ensure all tests pass

---

## 📄 License

This project is proprietary software. All rights reserved.

**Author**: Sunny Savita

---

## 📞 Support

For questions, issues, or feature requests:

- **Project Documentation**: [Google Docs Link](https://docs.google.com/document/d/1VlHirN62sWE1CwXr4v2YM40sg8luskD6VY4A2gKOHK4/edit?usp=sharing)
- **Issues**: Open an issue on the repository
- **Email**: Contact the maintainer

---

## 🙏 Acknowledgments

- **LangChain & LangGraph**: For the powerful LLM orchestration framework
- **FastAPI**: For the excellent web framework
- **Tavily**: For web search API
- **OpenAI, Google, Groq**: For LLM access

---

## 📚 Additional Resources

### Related Documentation
- [LangGraph Documentation](https://langchain-ai.github.io/langgraph/)
- [FastAPI Documentation](https://fastapi.tiangolo.com/)
- [LangChain Documentation](https://python.langchain.com/)

### Example Reports

Generated reports are stored in `generated_report/` directory with the following structure:

```
generated_report/
├── Impact_of_LLMs_over_the_Future_of_Jobs__20251026_131144/
│   ├── Impact_of_LLMs_over_the_Future_of_Jobs__20251026_131144.docx
│   └── Impact_of_LLMs_over_the_Future_of_Jobs__20251026_131144.pdf
├── LLM_Role_in_pharma_20251026_135707/
│   ├── LLM_Role_in_pharma_20251026_135707.docx
│   └── LLM_Role_in_pharma_20251026_135707.pdf
└── ...
```

---

**Built with ❤️ using LangGraph, FastAPI, and AI**
