Enterprise GenAI Product Analytics
A synthetic portfolio project demonstrating how raw interaction data from an enterprise GenAI assistant can be transformed into validated adoption, engagement and client-level KPIs.
Project Overview
The purpose of this project is to demonstrate an end-to-end product analytics workflow for an enterprise AI assistant.
The project covers the full process from raw interaction logs to final reporting, including:
	•	data cleaning
	•	duplicate handling
	•	test and demo account exclusions
	•	internal-user exclusions
	•	KPI definition
	•	user and organisation-level aggregation
	•	conversation-thread analysis
	•	multi-turn engagement measurement
	•	month-on-month growth analysis
	•	client segmentation
	•	validation and reconciliation
	•	Excel dashboard reporting
All data, organisations, users, identifiers and performance figures in this repository are completely synthetic.
## Dashboard Preview
![Enterprise GenAI Product Analytics Dashboard](images/dashboard_overview.png)

![Analytics Workflow](images/analytics_workflow.png)

Business Problem
Measuring usage of an AI assistant is not as simple as counting database rows.
Product teams may want to understand:
	•	How many questions are users asking?
	•	How many users are actively using the AI assistant?
	•	How many client organisations are adopting it?
	•	Are users continuing conversations after the first question?
	•	Which client segments demonstrate stronger usage?
	•	Is AI usage growing month over month?
These questions require different aggregation levels and clearly defined business rules.
Analytics Workflow
Raw Interaction Logs
        ↓
Data Cleaning
        ↓
Valid Analytical Population
        ↓
Core Usage Metrics
        ↓
Conversation Engagement
        ↓
Client Segment Analysis
        ↓
Validation
        ↓
Excel Reporting
Data Model
The synthetic dataset uses four main entities:
Organisations
    │
    ├── Users
    │
    └── Threads
            │
            └── Messages
The project analyses behaviour at multiple levels:
Level
Example Metric
Message
Questions Asked
User
Unique Users
Organisation
Active Organisations
Thread
Multi-turn Threads
Month
MoM Usage Growth
Segment
Questions per Organisation
Core Metrics
The project includes the following KPIs:
Metric
Purpose
Questions Asked
Measures total AI usage volume
Unique Users
Measures breadth of user adoption
Active Organisations
Measures client-level adoption
Threads
Measures conversation starts
Multi-turn Threads
Measures deeper conversational engagement
Multi-turn Rate
Measures the percentage of conversations continuing beyond one question
Questions per Organisation
Measures client-level usage depth
Questions per User
Measures user-level usage depth
MoM Question Growth
Measures monthly change in AI usage
Full definitions are available in:
documentation/metric_dictionary.md
Data Cleaning
Before calculating KPIs, the raw interaction data is cleaned to remove activity that should not contribute to client product analytics.
The cleaning logic excludes:
	•	assistant-response events
	•	test organisations
	•	demo organisations
	•	internal users
	•	duplicate message events
Stable IDs are used as the source of truth rather than organisation or user names.
The SQL cleaning logic is available in:
sql/01_data_cleaning.sql
Multi-turn Engagement
One of the key engagement measures in this project is the multi-turn conversation rate.
A thread with one valid user question is classified as single-turn.
A thread with more than one valid user question is classified as multi-turn.
Thread A
Question 1
Assistant Response
Question 2
Assistant Response

Result: Multi-turn
This metric provides a simple proxy for deeper conversational engagement rather than measuring only raw question volume.
Client Segment Analysis
The synthetic organisations are grouped into:
	•	Enterprise
	•	Mid-Market
	•	SME
Usage and engagement can therefore be compared across client segments using metrics such as:
	•	questions asked
	•	unique users
	•	active organisations
	•	conversation threads
	•	multi-turn rate
	•	questions per organisation
Validation Approach
The project includes validation checks for:
	•	duplicate message IDs
	•	internal-user leakage
	•	test and demo organisation leakage
	•	monthly question reconciliation
	•	thread-level reconciliation
	•	multi-turn rate boundaries
	•	organisation-level aggregation
	•	user-level aggregation
	•	month-on-month calculations
	•	segment reconciliation
	•	timestamp boundaries
See:
documentation/validation_notes.md
Project Structure
enterprise-genai-product-analytics/
│
├── data/
│   ├── organisations.csv
│   ├── users.csv
│   ├── threads.csv
│   └── clean_questions.csv
│
├── sql/
│   ├── 01_data_cleaning.sql
│   ├── 02_monthly_usage_metrics.sql
│   ├── 03_multi_turn_engagement.sql
│   └── 04_segment_analysis.sql
│
├── dashboard/
│   └── genai_product_analytics.xlsx
│
├── documentation/
│   ├── metric_dictionary.md
│   ├── data_model.md
│   └── validation_notes.md
│
├── images/
│
└── README.md
Technologies
	•	SQL
	•	Microsoft Excel
	•	Power Query-style transformation logic
	•	Product Analytics
	•	KPI Design
	•	Data Validation
	•	Customer Segmentation
Key Analytical Lessons
This project demonstrates that analytics is not only about writing queries.
A technically correct number can still represent the wrong business metric if the analytical population, aggregation level or KPI definition is unclear.
Important considerations include:
	•	defining what counts as valid activity
	•	selecting the correct aggregation level
	•	removing non-client activity
	•	avoiding duplicate records
	•	separating usage volume from adoption breadth
	•	distinguishing single interactions from deeper engagement
	•	validating results before reporting
Confidentiality Notice
This repository is a synthetic recreation inspired by professional analytics work.
No employer data, client information, proprietary source code, internal database schemas, credentials or confidential performance metrics are included.
All organisations, users, IDs, timestamps and analytical results are fictional and were created solely for portfolio demonstration purposes.
