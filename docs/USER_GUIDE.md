# User Guide

## Table of Contents
- [Introduction](#introduction)
- [Getting Started](#getting-started)
- [Generating Your First Report](#generating-your-first-report)
- [Understanding the Process](#understanding-the-process)
- [Providing Feedback](#providing-feedback)
- [Best Practices](#best-practices)
- [Tips for Better Reports](#tips-for-better-reports)
- [FAQ](#faq)
- [Troubleshooting](#troubleshooting)

---

## Introduction

Welcome to the Autonomous Research Report Generation System! This tool helps you create comprehensive, well-researched reports on any topic using AI-powered analyst personas.

### What Can You Do?

- 📝 Generate research reports on any topic
- 🔍 Automatically gather information from the web
- 👥 Get multiple expert perspectives
- ✍️ Receive professionally formatted reports
- 💬 Provide feedback to refine the research
- 📥 Download reports in DOCX and PDF formats

### How It Works

The system creates specialized AI analyst personas who:
1. Research your topic from different angles
2. Gather information from reputable web sources
3. Conduct simulated expert interviews
4. Compile findings into a structured report
5. Cite all sources used

---

## Getting Started

### Step 1: Access the System

Open your web browser and navigate to:
```
http://localhost:8000
```
(Or the URL provided by your administrator)

### Step 2: Create an Account

1. Click **Sign Up** on the login page
2. Choose a unique username
3. Create a secure password
4. Click **Create Account**

![Signup Page](screenshots/signup.png)

### Step 3: Login

1. Enter your username and password
2. Click **Login**
3. You'll be redirected to your dashboard

![Login Page](screenshots/login.png)

---

## Generating Your First Report

### Step 1: Enter Your Topic

On the dashboard, you'll see a form with a text input field.

**Enter your research topic**, for example:
- "Impact of AI on Healthcare"
- "Future of Renewable Energy"
- "Blockchain in Supply Chain Management"
- "Mental Health in Remote Work"

![Dashboard](screenshots/dashboard.png)

**Tips for Good Topics**:
- Be specific but not too narrow
- Avoid overly broad topics like "History of the World"
- Include key terms you want covered
- Focus on a single main question or area

### Step 2: Start Generation

1. Type your topic in the input field
2. Click **Generate Report**
3. Wait while the system creates analyst personas (5-10 seconds)

![Loading](screenshots/loading.png)

### Step 3: Review Analysts

The system will show you the AI analyst personas it created. For example:

**For topic "Impact of AI on Healthcare":**

1. **Dr. Emily Chen** - Clinical AI Researcher
   - Focus: Patient care applications
   - Perspective: Medical professional

2. **Prof. James Wright** - Healthcare Policy Expert
   - Focus: Regulatory and ethical implications
   - Perspective: Policy maker

3. **Sarah Miller** - Health Tech Entrepreneur
   - Focus: Commercial applications and innovation
   - Perspective: Industry insider

### Step 4: Provide Feedback (Optional)

You can refine the analysts by providing feedback:

**Examples**:
- "Focus more on rural healthcare"
- "Include perspectives from developing countries"
- "Add analysis of cost implications"
- "Consider privacy and security aspects"

**Or simply press Enter** to continue without changes.

### Step 5: Wait for Completion

The system will now:
1. Each analyst conducts research (20-30 seconds per analyst)
2. Web searches are performed automatically
3. Report sections are written
4. Introduction and conclusion are generated
5. Final report is compiled and saved

![Progress](screenshots/progress.png)

### Step 6: Download Your Report

Once complete, you'll see download buttons:
- **Download DOCX** - Editable Word document
- **Download PDF** - Print-ready PDF file

![Download](screenshots/download.png)

---

## Understanding the Process

### Phase 1: Analyst Creation (5-10 seconds)

The AI analyzes your topic and creates 3 specialized analyst personas with:
- Unique names and roles
- Specific focus areas
- Different perspectives

**Example**:
- Topic: "Renewable Energy Future"
- Analysts: Environmental Scientist, Energy Policy Expert, Green Tech Engineer

### Phase 2: Research & Interviews (30-60 seconds)

Each analyst:
1. **Formulates Questions** - Based on their expertise
2. **Searches the Web** - Using Tavily search API
3. **Gathers Information** - From credible sources
4. **Conducts Interview** - With an AI expert
5. **Writes Section** - Compiling findings

**All analysts work simultaneously** (parallel processing).

### Phase 3: Report Compilation (10-20 seconds)

The system:
1. **Writes Introduction** - Sets context
2. **Consolidates Sections** - Merges analyst findings
3. **Writes Conclusion** - Summarizes insights
4. **Compiles Sources** - Lists all citations

### Phase 4: Export (1-2 seconds)

Reports are saved in two formats:
- **DOCX**: Editable Microsoft Word format
- **PDF**: Professional, print-ready format

Both files are stored in a folder named after your topic and timestamp.

---

## Providing Feedback

### When to Provide Feedback

**Good situations**:
- Analysts don't cover an important aspect
- You want a different perspective included
- Need more technical or non-technical focus
- Want specific examples or case studies

**When to skip**:
- Analysts look reasonable for your topic
- You want a general overview
- Time is critical

### Types of Feedback

#### 1. Add Perspectives
```
"Include a patient perspective"
"Add insights from small businesses"
"Consider environmental impact"
```

#### 2. Change Focus
```
"Focus more on practical applications"
"Emphasize recent developments (2023-2024)"
"Include more technical details"
```

#### 3. Adjust Depth
```
"Provide beginner-friendly explanations"
"Include advanced technical analysis"
"Add statistical data and metrics"
```

#### 4. Refine Scope
```
"Limit to North American context"
"Focus on developing countries"
"Consider both urban and rural settings"
```

### Feedback Examples

**Topic**: "Artificial Intelligence in Education"

**Default Analysts**:
1. Education Technology Researcher
2. University Professor
3. EdTech Product Manager

**Feedback**: "Include perspectives from K-12 teachers and students"

**Result**: Updated analysts might include classroom teachers and student representatives

---

## Best Practices

### Choosing Topics

✅ **Good Topics**:
- "Impact of Remote Work on Team Collaboration"
- "Quantum Computing Applications in Drug Discovery"
- "Sustainable Fashion Industry Practices"
- "Cybersecurity Challenges in IoT Devices"

❌ **Avoid**:
- Too broad: "History of Science"
- Too specific: "Street names in Paris"
- Multiple topics: "AI and Blockchain and IoT"
- Personal opinions: "Why X is better than Y"

### Writing Effective Feedback

✅ **Good Feedback**:
- Specific and actionable
- Focuses on content, not format
- Adds new perspectives
- Clarifies scope

❌ **Ineffective Feedback**:
- "Make it better"
- "I don't like these"
- Format requests ("Make it shorter")
- Contradicts the topic

### Maximizing Report Quality

1. **Start with a Clear Topic**
   - Be specific about what you want to learn
   - Include key terms and concepts

2. **Review Analysts Carefully**
   - Check if they cover different angles
   - Ensure relevant expertise is included

3. **Provide Targeted Feedback**
   - Identify gaps in coverage
   - Suggest additional perspectives

4. **Allow Sufficient Time**
   - Don't rush the process
   - Each analyst needs time to research

5. **Review and Edit**
   - Download the DOCX for editing
   - Add your own insights
   - Verify claims if needed

---

## Tips for Better Reports

### Research-Heavy Topics

For academic or technical topics:

**Feedback suggestions**:
- "Include recent peer-reviewed studies"
- "Add statistical evidence"
- "Cite academic sources"
- "Include methodology comparisons"

**Example Topic**: "Machine Learning in Climate Modeling"

### Business/Industry Topics

For market and business analysis:

**Feedback suggestions**:
- "Include market size and trends"
- "Add competitor analysis"
- "Consider ROI and cost factors"
- "Include case studies from leading companies"

**Example Topic**: "Digital Transformation in Retail"

### Policy/Social Topics

For policy and social issues:

**Feedback suggestions**:
- "Include diverse stakeholder perspectives"
- "Consider ethical implications"
- "Add historical context"
- "Discuss policy recommendations"

**Example Topic**: "Universal Basic Income Feasibility"

### Technical Topics

For technology and engineering:

**Feedback suggestions**:
- "Include technical specifications"
- "Add implementation challenges"
- "Consider scalability issues"
- "Include code examples or diagrams"

**Example Topic**: "Microservices Architecture Patterns"

---

## FAQ

### General Questions

**Q: How long does report generation take?**  
A: Typically 30-60 seconds total. Analyst creation takes 5-10 seconds, research takes 20-30 seconds per analyst (parallel), and compilation takes 10-20 seconds.

**Q: How many analysts are created?**  
A: By default, 3 analysts. This provides diverse perspectives while keeping generation time reasonable.

**Q: Can I generate multiple reports?**  
A: Yes! You can generate as many reports as you need. Each gets its own folder with a timestamp.

**Q: What languages are supported?**  
A: Currently, English. The system may understand other languages but works best with English topics.

### Report Quality

**Q: How accurate are the reports?**  
A: Reports are based on web searches and AI analysis. Always verify critical information from primary sources.

**Q: Are sources cited?**  
A: Yes! All reports include a Sources section with citations and URLs.

**Q: Can I edit the reports?**  
A: Yes! Download the DOCX format for full editing capability.

**Q: Why are some reports better than others?**  
A: Quality depends on:
- Topic clarity and specificity
- Available online information
- Feedback provided
- Current web content on the topic

### Technical Questions

**Q: Where are reports saved?**  
A: In the `generated_report` folder, organized by topic name and timestamp.

**Q: Can I access old reports?**  
A: Yes! All reports are saved permanently unless manually deleted.

**Q: What if generation fails?**  
A: Check your internet connection and try again. Contact support if issues persist.

**Q: Can I download reports later?**  
A: Currently, download links are shown immediately after generation. Bookmark or save them. Future versions will include a report library.

### Customization

**Q: Can I request more or fewer analysts?**  
A: Currently fixed at 3. Contact your administrator for custom configurations.

**Q: Can I choose specific analyst types?**  
A: Not directly, but you can guide analyst selection through feedback.

**Q: Can I request specific sources?**  
A: The system automatically searches the web. You can provide feedback like "Include academic sources" to influence source selection.

**Q: Can I change report format?**  
A: DOCX and PDF are currently supported. The DOCX can be converted to other formats using Word.

---

## Troubleshooting

### Login Issues

**Problem**: "Invalid username or password"  
**Solution**: 
- Check for typos
- Passwords are case-sensitive
- Reset password if needed (contact admin)

**Problem**: Can't access dashboard after login  
**Solution**:
- Ensure cookies are enabled
- Clear browser cache
- Try a different browser

### Generation Issues

**Problem**: Report generation seems stuck  
**Solution**:
- Wait at least 2 minutes before refreshing
- Check internet connection
- Try generating again with a different topic

**Problem**: "Error generating report"  
**Solution**:
- Try a simpler topic
- Check if topic is appropriate
- Contact support with the error message

**Problem**: Analysts don't match my topic  
**Solution**:
- Provide specific feedback
- Regenerate with a clearer topic
- Try rephrasing your topic

### Download Issues

**Problem**: Can't download files  
**Solution**:
- Check browser download settings
- Disable popup blockers
- Try right-click → Save As

**Problem**: Downloaded files won't open  
**Solution**:
- Ensure you have appropriate software (Word for DOCX, PDF reader for PDF)
- Try downloading again
- Check file isn't corrupted

### Report Quality Issues

**Problem**: Report is too generic  
**Solution**:
- Provide more specific feedback
- Choose a narrower topic
- Request specific examples or case studies

**Problem**: Missing important aspects  
**Solution**:
- Provide feedback highlighting what's missing
- Regenerate the report
- Edit the DOCX to add missing content

**Problem**: Outdated information  
**Solution**:
- Specify "Focus on recent developments (2023-2024)" in feedback
- Edit DOCX to update information
- Verify critical facts from primary sources

---

## Example Workflows

### Academic Research

**Scenario**: Writing a literature review

1. **Topic**: "Recent Advances in Natural Language Processing"
2. **Feedback**: "Include academic papers from 2023-2024, focus on transformer architectures"
3. **Use Report**: As a starting point for literature review
4. **Edit**: Add specific papers you want to cite

### Business Analysis

**Scenario**: Market research for a startup

1. **Topic**: "SaaS Market Trends in HR Technology"
2. **Feedback**: "Include market size, growth rates, and major competitors"
3. **Use Report**: For investor presentation
4. **Edit**: Add your company's unique angle

### Content Creation

**Scenario**: Blog post research

1. **Topic**: "Benefits of Mindfulness Meditation"
2. **Feedback**: "Include scientific studies and practical tips"
3. **Use Report**: As research material
4. **Edit**: Adapt tone for your audience

### Professional Development

**Scenario**: Learning new technology

1. **Topic**: "Introduction to Kubernetes for Developers"
2. **Feedback**: "Include practical examples and common use cases"
3. **Use Report**: As a learning guide
4. **Edit**: Add your own notes and experiments

---

## Getting Help

### Support Channels

- **Documentation**: Check this guide and other docs
- **Administrator**: Contact your system administrator
- **GitHub Issues**: Report bugs or request features
- **Email**: support@example.com

### Providing Feedback

Help us improve! When reporting issues:

1. **Describe the problem** clearly
2. **Include the topic** you were researching
3. **Screenshot** if relevant
4. **Expected vs. actual** behavior
5. **Browser and OS** information

---

## Tips from Power Users

### Tip 1: Iterative Refinement
"I often generate a report, review it, then generate another with more specific feedback based on gaps I notice."

### Tip 2: Multiple Perspectives
"For complex topics, I generate 2-3 reports with different focuses and combine insights."

### Tip 3: Fact Checking
"Always verify critical claims, especially for academic or professional work."

### Tip 4: Source Mining
"The sources section is gold - I use it to find additional resources for deeper research."

### Tip 5: Template Creation
"I keep a DOCX template and paste report content into it for consistent formatting."

---

## Keyboard Shortcuts

| Action | Shortcut |
|--------|----------|
| Submit topic | `Enter` in input field |
| Submit feedback | `Enter` in textarea (Shift+Enter for new line) |
| Back to dashboard | Browser back button |

---

## Report Structure Guide

### Standard Report Sections

1. **Title** - Your research topic
2. **Introduction** - Context and preview
3. **Body Sections** - One per analyst perspective
   - Section title
   - Summary
   - Key insights
   - Inline citations [1], [2], etc.
4. **Conclusion** - Summary of findings
5. **Sources** - Complete citation list

### Reading Your Report

**DOCX Format**:
- Headings are styled (easy to navigate)
- Editable
- Can add comments
- Compatible with all Word processors

**PDF Format**:
- Professional appearance
- Print-ready
- Centered text layout
- Page numbers

---

## Best Practices Summary

✅ **DO**:
- Be specific with topics
- Review analysts before continuing
- Provide targeted feedback
- Verify critical information
- Edit reports for your needs
- Save important reports

❌ **DON'T**:
- Use overly broad topics
- Skip the analyst review
- Provide vague feedback
- Accept everything as fact
- Share sensitive information in topics
- Generate duplicate reports unnecessarily

---

**Need More Help?**

Check out our other documentation:
- [API Documentation](API_DOCUMENTATION.md) - For developers
- [Architecture Guide](ARCHITECTURE.md) - System design
- [Development Guide](DEVELOPMENT_GUIDE.md) - Contributing

---

**Last Updated**: January 2025  
**Version**: 1.0  
**Author**: Sunny Savita




