# System Architecture

## Table of Contents
- [Overview](#overview)
- [Architecture Principles](#architecture-principles)
- [System Components](#system-components)
- [Data Flow](#data-flow)
- [LangGraph Workflow](#langgraph-workflow)
- [State Management](#state-management)
- [Database Schema](#database-schema)
- [Scalability Considerations](#scalability-considerations)

---

## Overview

The Autonomous Research Report Generation System is built on a modern, modular architecture that combines:

- **LangGraph** for orchestrating complex AI workflows
- **FastAPI** for high-performance web serving
- **Multi-LLM Support** for flexibility and cost optimization
- **Stateful Workflow Management** for human-in-the-loop interactions

### Architecture Style

**Pattern**: Multi-Agent AI System with Human-in-the-Loop  
**Communication**: Event-driven state machine (LangGraph)  
**Data Storage**: SQLite (development), PostgreSQL-ready (production)  
**Deployment**: ASGI-based (Uvicorn)

---

## Architecture Principles

### 1. Separation of Concerns

```
┌─────────────────────────────────────────────────────────┐
│  Presentation Layer (FastAPI + Jinja2)                  │
│  • Routes, templates, static files                      │
└─────────────────────────┬───────────────────────────────┘
                          │
┌─────────────────────────▼───────────────────────────────┐
│  Business Logic Layer (Services)                        │
│  • Report generation orchestration                      │
│  • State management                                     │
└─────────────────────────┬───────────────────────────────┘
                          │
┌─────────────────────────▼───────────────────────────────┐
│  Workflow Layer (LangGraph)                             │
│  • Multi-agent coordination                             │
│  • Interview workflows                                  │
└─────────────────────────┬───────────────────────────────┘
                          │
┌─────────────────────────▼───────────────────────────────┐
│  Integration Layer (Utilities)                          │
│  • LLM providers, search APIs                           │
│  • Configuration, logging                               │
└─────────────────────────────────────────────────────────┘
```

### 2. Modularity

Each component is independently testable and replaceable:

- **LLM Provider**: Swap OpenAI ↔ Gemini ↔ Groq via config
- **Search Provider**: Replace Tavily with alternatives
- **Database**: Switch SQLite → PostgreSQL → MySQL
- **UI**: Replace Jinja2 templates with React/Vue

### 3. Extensibility

- **Plugin Architecture**: Add new workflow nodes easily
- **Custom Prompts**: Jinja2 templates for prompt management
- **Multiple Output Formats**: Easy to add new export formats

### 4. Observability

- **Structured Logging**: JSON logs with full context
- **State Inspection**: View workflow state at any point
- **Error Tracking**: Detailed exception information

---

## System Components

### 1. Web Application Layer

#### FastAPI Application (`api/main.py`)

```python
┌────────────────────────────────────────────┐
│          FastAPI Application               │
├────────────────────────────────────────────┤
│  • CORS Middleware                         │
│  • Static File Serving                     │
│  • Template Engine (Jinja2)               │
│  • Router Registration                     │
└────────────────────────────────────────────┘
```

**Responsibilities**:
- HTTP request/response handling
- Session management
- Static file serving
- Template rendering
- Error handling

**Key Features**:
- Async/await support
- Automatic API documentation (Swagger/OpenAPI)
- Request validation with Pydantic
- Dependency injection

#### Routes (`api/routes/report_routes.py`)

```python
Authentication Routes:
  GET  /              → Login page
  POST /login         → Authenticate user
  GET  /signup        → Signup page
  POST /signup        → Create account

Report Routes:
  GET  /dashboard     → User dashboard
  POST /generate_report → Start generation
  POST /submit_feedback → Submit feedback
  GET  /download/{file} → Download report
```

### 2. Service Layer

#### Report Service (`api/services/report_service.py`)

```python
┌────────────────────────────────────────────┐
│          ReportService                     │
├────────────────────────────────────────────┤
│  + start_report_generation()               │
│  + submit_feedback()                       │
│  + get_report_status()                     │
│  + download_file()                         │
└────────────────────────────────────────────┘
```

**Responsibilities**:
- Workflow initiation and management
- Thread ID generation
- State updates
- File retrieval

**Pattern**: Facade pattern over LangGraph workflow

### 3. Workflow Layer

#### Autonomous Report Generator

```python
┌─────────────────────────────────────────────────────────┐
│      AutonomousReportGenerator                          │
├─────────────────────────────────────────────────────────┤
│  Graph Construction:                                    │
│    • build_graph()          → Construct LangGraph      │
│                                                         │
│  Node Functions:                                        │
│    • create_analyst()       → Generate personas        │
│    • human_feedback()       → Pause for input          │
│    • write_report()         → Compile sections         │
│    • write_introduction()   → Generate intro           │
│    • write_conclusion()     → Generate conclusion      │
│    • finalize_report()      → Assemble final output    │
│                                                         │
│  Utilities:                                             │
│    • save_report()          → Export DOCX/PDF          │
│    • _save_as_docx()        → DOCX formatting          │
│    • _save_as_pdf()         → PDF formatting           │
└─────────────────────────────────────────────────────────┘
```

#### Interview Workflow Builder

```python
┌─────────────────────────────────────────────────────────┐
│      InterviewGraphBuilder                              │
├─────────────────────────────────────────────────────────┤
│  Graph Construction:                                    │
│    • build()                → Construct interview graph│
│                                                         │
│  Node Functions:                                        │
│    • _generate_question()   → Analyst asks question    │
│    • _search_web()          → Tavily web search        │
│    • _generate_answer()     → Expert responds          │
│    • _save_interview()      → Store transcript         │
│    • _write_section()       → Compile section          │
└─────────────────────────────────────────────────────────┘
```

### 4. Integration Layer

#### Model Loader (`utils/model_loader.py`)

```python
┌────────────────────────────────────────────┐
│          ModelLoader                       │
├────────────────────────────────────────────┤
│  API Key Management:                       │
│    • ApiKeyManager                         │
│                                            │
│  Model Loading:                            │
│    • load_llm()        → Chat models       │
│    • load_embeddings() → Embedding models  │
│                                            │
│  Supported Providers:                      │
│    • OpenAI (GPT-4o)                       │
│    • Google (Gemini 2.0 Flash)             │
│    • Groq (DeepSeek R1)                    │
└────────────────────────────────────────────┘
```

**Pattern**: Factory pattern for model instantiation

#### Configuration Loader (`utils/config_loader.py`)

```python
┌────────────────────────────────────────────┐
│       Configuration System                 │
├────────────────────────────────────────────┤
│  Source Priority:                          │
│    1. Explicit path argument               │
│    2. CONFIG_PATH env variable             │
│    3. Default: config/configuration.yaml   │
│                                            │
│  Features:                                 │
│    • YAML parsing                          │
│    • Path resolution                       │
│    • Error handling                        │
└────────────────────────────────────────────┘
```

### 5. Data Layer

#### Database Configuration (`database/db_config.py`)

```python
┌────────────────────────────────────────────┐
│          Database Layer                    │
├────────────────────────────────────────────┤
│  ORM: SQLAlchemy                           │
│  Database: SQLite (default)                │
│                                            │
│  Models:                                   │
│    • User                                  │
│      - id (PK)                             │
│      - username (unique)                   │
│      - password (hashed)                   │
│                                            │
│  Security:                                 │
│    • Bcrypt password hashing               │
│    • 72-character password limit           │
└────────────────────────────────────────────┘
```

### 6. Cross-Cutting Concerns

#### Logging System (`logger/custom_logger.py`)

```python
┌────────────────────────────────────────────┐
│       Structured Logging                   │
├────────────────────────────────────────────┤
│  Technology: structlog                     │
│  Format: JSON                              │
│                                            │
│  Processors:                               │
│    • TimeStamper (ISO format, UTC)         │
│    • LogLevelAdder                         │
│    • EventRenamer                          │
│    • JSONRenderer                          │
│                                            │
│  Outputs:                                  │
│    • Console (stdout)                      │
│    • File (logs/{timestamp}.log)           │
└────────────────────────────────────────────┘
```

#### Exception Handling (`exception/custom_exception.py`)

```python
┌────────────────────────────────────────────┐
│       Custom Exception System              │
├────────────────────────────────────────────┤
│  Class: ResearchAnalystException           │
│                                            │
│  Captures:                                 │
│    • File name                             │
│    • Line number                           │
│    • Error message                         │
│    • Full traceback                        │
│                                            │
│  Features:                                 │
│    • Context preservation                  │
│    • Logger-friendly formatting            │
│    • Exception chaining                    │
└────────────────────────────────────────────┘
```

---

## Data Flow

### 1. Report Generation Flow

```
┌─────────┐
│  User   │
└────┬────┘
     │ 1. Submit topic via /generate_report
     ▼
┌─────────────────┐
│  FastAPI Route  │
└────┬────────────┘
     │ 2. Call ReportService.start_report_generation()
     ▼
┌──────────────────┐
│  Report Service  │
└────┬─────────────┘
     │ 3. Create thread_id, start LangGraph workflow
     ▼
┌───────────────────────────────────────────────────┐
│  LangGraph: AutonomousReportGenerator             │
├───────────────────────────────────────────────────┤
│  Node: create_analyst                             │
│    • Invoke LLM with CREATE_ANALYSTS_PROMPT       │
│    • Generate 3 analyst personas                  │
│    • Store in state                               │
└────┬──────────────────────────────────────────────┘
     │
     ▼
┌───────────────────────────────────────────────────┐
│  Node: human_feedback [INTERRUPT]                 │
│    • Workflow pauses                              │
│    • Return control to user                       │
└────┬──────────────────────────────────────────────┘
     │
     │ 4. Return to user with thread_id
     ▼
┌─────────┐
│  User   │
└────┬────┘
     │ 5. Reviews analysts, provides feedback
     │ 6. Submit via /submit_feedback
     ▼
┌─────────────────┐
│  FastAPI Route  │
└────┬────────────┘
     │ 7. Call ReportService.submit_feedback()
     ▼
┌──────────────────┐
│  Report Service  │
└────┬─────────────┘
     │ 8. Update state, resume workflow
     ▼
┌───────────────────────────────────────────────────┐
│  LangGraph: Resume from human_feedback            │
├───────────────────────────────────────────────────┤
│  Conditional Edge: initiate_all_interviews        │
│    • Send parallel tasks for each analyst         │
└────┬──────────────────────────────────────────────┘
     │
     │ For Each Analyst (Parallel):
     ▼
┌───────────────────────────────────────────────────┐
│  SubGraph: Interview Workflow                     │
├───────────────────────────────────────────────────┤
│  1. ask_question                                  │
│     • Analyst formulates question                 │
│  2. search_web                                    │
│     • Generate search query                       │
│     • Call Tavily API                             │
│  3. generate_answer                               │
│     • Expert responds with context                │
│  4. save_interview                                │
│     • Store conversation                          │
│  5. write_section                                 │
│     • Compile into report section                 │
└────┬──────────────────────────────────────────────┘
     │ All interviews complete
     ▼
┌───────────────────────────────────────────────────┐
│  Parallel Nodes:                                  │
│    • write_report (consolidate sections)          │
│    • write_introduction (create intro)            │
│    • write_conclusion (create conclusion)         │
└────┬──────────────────────────────────────────────┘
     │
     ▼
┌───────────────────────────────────────────────────┐
│  Node: finalize_report                            │
│    • Assemble: intro + content + conclusion       │
│    • Consolidate sources                          │
│    • Store in state.final_report                  │
└────┬──────────────────────────────────────────────┘
     │
     ▼
┌───────────────────────────────────────────────────┐
│  Report Service                                   │
│    • Get final_report from state                  │
│    • Save as DOCX                                 │
│    • Save as PDF                                  │
│    • Return file paths                            │
└────┬──────────────────────────────────────────────┘
     │
     ▼
┌─────────┐
│  User   │ Downloads reports
└─────────┘
```

### 2. Data Storage Flow

```
User Data:
  Input: Username + Password (form)
    ↓
  Hash: Bcrypt (72-char truncated)
    ↓
  Store: SQLite (users table)
    ↓
  Session: In-memory dictionary (SESSIONS)

Report Data:
  Input: Research topic
    ↓
  Processing: LangGraph workflow
    ↓
  State: MemorySaver (in-memory checkpointing)
    ↓
  Output: File system (generated_report/)
    ↓
  Organization: Topic-based folders with timestamps
```

---

## LangGraph Workflow

### State Machine Diagram

```
START
  │
  ▼
┌─────────────────┐
│ create_analyst  │
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│ human_feedback  │ [INTERRUPT POINT]
└────────┬────────┘
         │
         │ (conditional)
         ├─────────────────────┐
         │                     │
         ▼                     ▼
┌──────────────────┐      ┌──────┐
│conduct_interview │ ×N   │ END  │ (if no analysts)
│   (parallel)     │      └──────┘
└────────┬─────────┘
         │ (fan-in)
         ├────────────────────┬────────────────────┐
         ▼                    ▼                    ▼
┌───────────────┐  ┌─────────────────┐  ┌─────────────────┐
│ write_report  │  │write_introduction│  │write_conclusion │
└───────┬───────┘  └────────┬────────┘  └────────┬────────┘
        │                   │                     │
        └───────────────────┼─────────────────────┘
                            ▼
                  ┌─────────────────┐
                  │finalize_report  │
                  └────────┬────────┘
                           │
                           ▼
                          END
```

### Node Descriptions

| Node | Type | Purpose | Blocking |
|------|------|---------|----------|
| `create_analyst` | Function | Generate analyst personas | No |
| `human_feedback` | Interrupt | Pause for user input | Yes |
| `conduct_interview` | Subgraph | Per-analyst research | No |
| `write_report` | Function | Consolidate sections | No |
| `write_introduction` | Function | Generate intro | No |
| `write_conclusion` | Function | Generate conclusion | No |
| `finalize_report` | Function | Assemble final output | No |

### Edge Types

**Standard Edges**:
```python
builder.add_edge("create_analyst", "human_feedback")
builder.add_edge("conduct_interview", "write_report")
```

**Conditional Edges**:
```python
builder.add_conditional_edges(
    "human_feedback",
    initiate_all_interviews,  # Function returns list of Send objects
    ["conduct_interview", END]
)
```

**Fan-out (Parallel Processing)**:
```python
def initiate_all_interviews(state):
    return [
        Send("conduct_interview", {"analyst": analyst, ...})
        for analyst in state["analysts"]
    ]
```

**Fan-in (Synchronization)**:
```python
# Automatic - all parallel tasks must complete before next node
builder.add_edge("conduct_interview", "write_report")
```

---

## State Management

### State Types

#### 1. GenerateAnalystsState
```python
{
    "topic": str,                    # User input
    "max_analysts": int,             # Configuration (default: 3)
    "human_analyst_feedback": str,   # User feedback
    "analysts": List[Analyst]        # Generated output
}
```

#### 2. InterviewState (extends MessagesState)
```python
{
    "messages": List[BaseMessage],   # Conversation history
    "max_num_turns": int,            # Interview length limit
    "context": List[str],            # Search results (accumulated)
    "analyst": Analyst,              # Current analyst
    "interview": str,                # Full transcript
    "sections": List[str]            # Generated sections (accumulated)
}
```

#### 3. ResearchGraphState
```python
{
    "topic": str,
    "max_analysts": int,
    "human_analyst_feedback": str,
    "analysts": List[Analyst],
    "sections": List[str],           # Accumulated from all analysts
    "introduction": str,
    "content": str,
    "conclusion": str,
    "final_report": str
}
```

### State Updates

**Reducer Functions**:
```python
from typing import Annotated
import operator

# Accumulate lists
sections: Annotated[list, operator.add]

# Override values
topic: str
```

**Update Methods**:
```python
# During workflow execution
def create_analyst(state):
    return {"analysts": new_analysts}  # Updates state.analysts

# External update (user feedback)
graph.update_state(
    thread,
    {"human_analyst_feedback": feedback},
    as_node="human_feedback"
)
```

### Checkpointing

**MemorySaver** stores snapshots:
```python
memory = MemorySaver()
graph = builder.compile(
    interrupt_before=["human_feedback"],
    checkpointer=memory
)

# State persists across runs
thread = {"configurable": {"thread_id": "abc-123"}}
graph.stream(input, thread)
# ... later ...
graph.stream(None, thread)  # Resumes from checkpoint
```

---

## Database Schema

### Current Schema (SQLite)

```sql
CREATE TABLE users (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    username VARCHAR UNIQUE NOT NULL,
    password VARCHAR NOT NULL
);

CREATE UNIQUE INDEX idx_username ON users(username);
```

### Future Enhancements

```sql
-- Reports table
CREATE TABLE reports (
    id UUID PRIMARY KEY,
    user_id INTEGER REFERENCES users(id),
    topic VARCHAR(500) NOT NULL,
    thread_id VARCHAR(100) UNIQUE NOT NULL,
    status VARCHAR(50) NOT NULL,  -- pending, in_progress, completed, failed
    docx_path VARCHAR(1000),
    pdf_path VARCHAR(1000),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    completed_at TIMESTAMP
);

-- Analysts table (for tracking)
CREATE TABLE analysts (
    id SERIAL PRIMARY KEY,
    report_id UUID REFERENCES reports(id),
    name VARCHAR(200),
    role VARCHAR(200),
    affiliation VARCHAR(200),
    description TEXT
);

-- Feedback table
CREATE TABLE feedback (
    id SERIAL PRIMARY KEY,
    report_id UUID REFERENCES reports(id),
    feedback_text TEXT,
    submitted_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

---

## Scalability Considerations

### Current Limitations

1. **In-Memory State**: MemorySaver doesn't persist across restarts
2. **Single Server**: No horizontal scaling
3. **Synchronous Processing**: One report at a time per thread
4. **SQLite**: Limited concurrent writes

### Scaling Strategies

#### 1. Distributed State Management

```python
from langgraph.checkpoint.postgres import PostgresSaver

# Replace MemorySaver
checkpointer = PostgresSaver(connection_string="postgresql://...")
graph = builder.compile(checkpointer=checkpointer)
```

#### 2. Task Queue

```python
from celery import Celery

celery = Celery('tasks', broker='redis://localhost:6379')

@celery.task
def generate_report_async(topic, thread_id):
    # Run workflow in background
    pass
```

#### 3. Horizontal Scaling

```
       ┌──────────────┐
       │Load Balancer │
       └──────┬───────┘
              │
    ┌─────────┼─────────┐
    │         │         │
    ▼         ▼         ▼
┌────────┐┌────────┐┌────────┐
│FastAPI ││FastAPI ││FastAPI │
│Worker 1││Worker 2││Worker 3│
└────┬───┘└────┬───┘└────┬───┘
     │         │         │
     └─────────┼─────────┘
               │
        ┌──────▼──────┐
        │ PostgreSQL  │
        │+ Redis Cache│
        └─────────────┘
```

#### 4. Microservices Architecture

```
┌────────────────┐     ┌──────────────────┐
│  API Gateway   │────▶│  Auth Service    │
└────────┬───────┘     └──────────────────┘
         │
         ├─────────────▶┌──────────────────┐
         │              │ Report Service   │
         │              └──────────────────┘
         │
         └─────────────▶┌──────────────────┐
                        │ Storage Service  │
                        └──────────────────┘
```

---

## Performance Metrics

### Expected Latencies

| Operation | Time | Notes |
|-----------|------|-------|
| Analyst creation | 5-10s | Single LLM call |
| Interview (per analyst) | 15-30s | 2-3 search + LLM calls |
| Report compilation | 10-20s | 3 parallel LLM calls |
| Total report generation | 30-60s | 3 analysts, full workflow |
| DOCX/PDF export | 1-2s | File I/O |

### Resource Usage

- **Memory**: 500MB-1GB per active workflow
- **CPU**: Low (I/O bound, mostly waiting on APIs)
- **Network**: 50-100 API calls per report
- **Storage**: ~100KB per report (DOCX + PDF)

---

## Security Architecture

### Current Implementation

1. **Password Security**: Bcrypt hashing
2. **Session Management**: Cookie-based (in-memory)
3. **API Keys**: Environment variables

### Production Recommendations

1. **HTTPS Only**: TLS encryption
2. **JWT Authentication**: Stateless sessions
3. **Rate Limiting**: Per-user and per-IP
4. **API Key Rotation**: Automatic rotation schedule
5. **RBAC**: Role-based access control
6. **Audit Logging**: Track all actions
7. **Input Sanitization**: Prevent injection attacks

---

**Last Updated**: January 2025  
**Version**: 1.0  
**Author**: Sunny Savita




