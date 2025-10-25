import os
import sys
from datetime import datetime
from typing import Optional
from langgraph.types import Send

current_dir = os.path.dirname(os.path.abspath(__file__))
project_root = os.path.abspath(os.path.join(current_dir, "../../"))
sys.path.append(project_root)

from langgraph.graph import StateGraph, START, END
from langgraph.checkpoint.memory import MemorySaver
from langchain_core.messages import HumanMessage, SystemMessage, AIMessage
from langchain_core.messages import get_buffer_string
from langchain_community.tools.tavily_search import TavilySearchResults

from docx import Document
from reportlab.lib.pagesizes import letter
from reportlab.pdfgen import canvas

from research_and_analyst.backend_server.models import (
    Analyst,
    Perspectives,
    GenerateAnalystsState,
    InterviewState,
    ResearchGraphState,
    
)

from research_and_analyst.utils.model_loader import ModelLoader


def build_interview_graph(llm,tavily_search=None):
    
    """Create a LangGraph subgraph that handles interviews."""

    memory = MemorySaver()
    
    def generation_question(state:InterviewState):
        pass
    
    def search_web(state: InterviewState):
        pass
    
    def generate_answer(state: InterviewState):
        pass
    
    def save_interview(state: InterviewState):
        pass
    
    def write_section(state: InterviewState):
        pass

    builder = StateGraph(InterviewState)
    builder.add_node("ask_question", generation_question)
    builder.add_node("search_web", search_web)
    builder.add_node("generate_answer", generate_answer)
    builder.add_node("save_interview", save_interview)
    builder.add_node("write_section", write_section)

    builder.add_edge(START, "ask_question")
    builder.add_edge("ask_question", "search_web")
    builder.add_edge("search_web", "generate_answer")
    builder.add_edge("generate_answer", "save_interview")
    builder.add_edge("save_interview", "write_section")
    builder.add_edge("write_section", END)

    return builder.compile(checkpointer=memory)


class AutonomousReportGenerator:
    def __init__(self):
        """_summary_
        """
        pass
    
    def create_analyst(self):
        """_summary_
        """
        pass
    
    def human_feedback(self):
        """_summary_
        """
        pass
    
    def write_report(self):
        """_summary_
        """
        pass
    
    def write_introduction(self):
        """_summary_
        """
        pass
    
    def write_conclusion(self):
        """_summary_
        """
        pass
    
    def finalize_report(self):
        """_summary_
        """
        pass
    
    def save_report(self):
        """_summary_
        """
        pass
    
    def _save_as_docx(self):
        """'_summary_'
        """
        pass
    
    def _save_as_pdf(self):
        """_summary_
        """
        pass
    
    def build_graph(self):
        """_summary_
        """
        
        builder = StateGraph(ResearchGraphState)
        # Add nodes
        builder.add_node("create_analyst", self.create_analyst)
        builder.add_node("human_feedback", self.human_feedback)
        builder.add_node("conduct_interview", interview_graph)
        builder.add_node("write_report", self.write_report)
        builder.add_node("write_introduction", self.write_introduction)
        builder.add_node("write_conclusion", self.write_conclusion)
        builder.add_node("finalize_report", self.finalize_report)

        # Edges
        builder.add_edge(START, "create_analyst")
        builder.add_edge("create_analyst", "human_feedback")

        # Map each analyst → interview graph
        builder.add_conditional_edges("human_feedback", initiate_all_interviews, ["conduct_interview"])

        builder.add_edge("conduct_interview", "write_report")
        builder.add_edge("conduct_interview", "write_introduction")
        builder.add_edge("conduct_interview", "write_conclusion")
        builder.add_edge(
            ["write_report", "write_introduction", "write_conclusion"], "finalize_report"
        )
        builder.add_edge("finalize_report", END)

        return builder.compile(interrupt_before=["human_feedback"], checkpointer=self.memory)
    
if __name__ == "__main__":
        """_summary_
        """
        llm = ModelLoader().load_llm()
        print(llm.invoke("hello").content)
        reporter = AutonomousReportGenerator()
        reporter.build_graph()
        
        
        
        
                