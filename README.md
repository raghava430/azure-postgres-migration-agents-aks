# Azure PostgreSQL Agentic Migration (GenAI-Oriented)

A cloud-native PostgreSQL migration system designed with a multi-agent
orchestration approach using Microsoft Agent Framework and Azure AI
Foundry. This project demonstrates how agent-based systems can
coordinate complex data workflows such as database migration,
validation, and execution in distributed environments.

------------------------------------------------------------------------

## Features

-   Multi-agent orchestration using Microsoft Agent Framework\
-   GenAI-oriented workflow design (agent-driven execution)\
-   PostgreSQL migration from local → Azure\
-   AKS-based scalable execution\
-   Dockerized runtime environment\
-   Azure DevOps CI/CD integration\
-   Data validation using row-count verification\
-   Modular pipeline supporting multiple databases

------------------------------------------------------------------------

## Architecture

               ┌────────────────────────────┐
               │      User / Pipeline       │
               │ (Azure DevOps Trigger)     │
               └────────────┬───────────────┘
                            │
                            ▼
            ┌───────────────────────────────┐
            │   Agent Orchestration Layer   │
            │ (Microsoft Agent Framework)   │
            │  - Extract Agent              │
            │  - Load Agent                 │
            │  - Validation Agent           │
            └────────────┬──────────────────┘
                         │
                         ▼
            ┌───────────────────────────────┐
            │   Docker Runtime Environment  │
            │   (Migration Execution)       │
            └────────────┬──────────────────┘
                         │
                         ▼
            ┌───────────────────────────────┐
            │   Kubernetes (AKS Jobs)       │
            │   Distributed Execution       │
            └────────────┬──────────────────┘
                         │
                         ▼
            ┌───────────────────────────────┐
            │ Azure PostgreSQL (Target DB)  │
            └────────────┬──────────────────┘
                         │
                         ▼
            ┌───────────────────────────────┐
            │ Validation Layer              │
            │ (Row Count Comparison)        │
            └───────────────────────────────┘

------------------------------------------------------------------------

## Project Structure

    .
    ├── kubernetes/
    │   ├── configs/        # ConfigMaps
    │   ├── jobs/           # AKS Jobs
    ├── samples/            # Sample outputs
    ├── Dockerfile
    ├── azure-pipelines.yml
    ├── migration_sequential.py
    ├── migration_update.py
    ├── requirements.txt

------------------------------------------------------------------------

## How It Works

### Step 1: Extraction Agent

-   Reads local PostgreSQL database
-   Generates SQL backup

### Step 2: Load Agent

-   Loads data into Azure PostgreSQL
-   Handles schema + data migration

### Step 3: Validation Agent

-   Compares row counts
-   Ensures migration accuracy

### Step 4: Orchestration

-   Agents are executed sequentially
-   Coordinated through agent framework

------------------------------------------------------------------------

## Tech Stack

-   Python 3.11\
-   PostgreSQL\
-   Microsoft Agent Framework\
-   Azure AI Foundry\
-   Azure Kubernetes Service (AKS)\
-   Docker\
-   Azure DevOps\
-   Kubernetes

------------------------------------------------------------------------

## Setup Instructions

### Installation

``` bash
git clone <repo-url>
cd azure-postgres-migration-agents-aks
python -m venv venv
venv\Scripts\activate
pip install -r requirements.txt
```

------------------------------------------------------------------------

### Run Locally

``` bash
python migration_sequential.py
```

------------------------------------------------------------------------

### Deploy to AKS

-   Build Docker image\
-   Push to registry\
-   Apply Kubernetes configs\
-   Execute jobs

------------------------------------------------------------------------

## Design Decisions

### Agent-Based Design

-   Modular separation of tasks\
-   Clear workflow orchestration\
-   Extensible for future agents

### Kubernetes Jobs

-   Reliable execution\
-   Scalable batch processing

### Validation Strategy

-   Row-count verification\
-   Lightweight consistency check

------------------------------------------------------------------------

## Notes

-   Sensitive SQL files are excluded\
-   Replace Azure config placeholders before use\
-   Designed as a GenAI + cloud orchestration project

------------------------------------------------------------------------

## Author

Raghava Reddy
