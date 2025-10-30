from fastapi import FastAPI
from fastapi.staticfiles import StaticFiles
from fastapi.templating import Jinja2Templates
from fastapi.middleware.cors import CORSMiddleware
import os
from datetime import datetime
from research_and_analyst.api.routes import report_routes

app = FastAPI(title="Autonomous Report Generator UI")

app.mount("/static", StaticFiles(directory="static"), name="static")
templates = Jinja2Templates(directory="research_and_analyst/api/templates")
app.templates = templates  # so templates accessible inside router

# 🔹 ADD THIS FUNCTION
def basename_filter(path: str):
    return os.path.basename(path)

# 🔹 REGISTER FILTER
templates.env.filters["basename"] = basename_filter

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_methods=["*"],
    allow_headers=["*"],
)

# Health check endpoint for container orchestration
@app.get("/health")
async def health_check():
    """Health check endpoint for Azure Container Apps and monitoring"""
    return {
        "status": "healthy",
        "service": "research-report-generation",
        "timestamp": datetime.now().isoformat(),
        "version": "1.0.0"
    }

# Register Routes
app.include_router(report_routes.router)
