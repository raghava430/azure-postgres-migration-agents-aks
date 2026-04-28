# Azure PostgreSQL Agentic Migration (AKS)

This project implements a multi-agent workflow to migrate PostgreSQL
databases from a local environment to Azure Database for PostgreSQL
using Microsoft Agent Framework, Azure AI Foundry, Docker, and AKS Jobs.

## Overview

The system orchestrates database migration using a structured,
agent-driven pipeline where each stage handles a specific responsibility
such as schema extraction, data transfer, validation, and updates. The
workflow is deployed on Azure Kubernetes Service (AKS) and triggered
through Azure DevOps pipelines.

## Key Features

-   Multi-agent migration workflow using Microsoft Agent Framework\
-   Automated PostgreSQL migration from local to Azure\
-   Containerized execution using Docker\
-   Scalable execution using AKS Jobs\
-   CI/CD integration using Azure DevOps pipelines\
-   Row-count validation to ensure data consistency\
-   Modular design for handling multiple databases

## Architecture

1.  Source database backup is generated locally\
2.  Migration pipeline is triggered via Azure DevOps\
3.  Docker container executes migration logic\
4.  AKS Jobs orchestrate execution across environments\
5.  Agents coordinate migration tasks (extract, load, validate)\
6.  Validation step compares row counts between source and target

## Tech Stack

-   Python 3.11\
-   PostgreSQL\
-   Microsoft Agent Framework\
-   Azure AI Foundry\
-   Azure Kubernetes Service (AKS)\
-   Docker\
-   Azure DevOps\
-   Kubernetes (ConfigMaps, Jobs)

## Project Structure

    .
    ├── kubernetes/
    │   ├── configs/        # ConfigMaps for environment setup
    │   ├── jobs/           # AKS Job definitions for migration
    ├── samples/            # Sample outputs (validation results)
    ├── Dockerfile          # Container setup for migration runtime
    ├── azure-pipelines.yml # CI/CD pipeline definition
    ├── migration_sequential.py
    ├── migration_update.py
    ├── requirements.txt

## How It Works

-   The migration logic is implemented in Python scripts\
-   Agent-based orchestration manages sequential migration steps\
-   Kubernetes Jobs execute migration tasks in a scalable manner\
-   Validation ensures successful migration using row-count checks

## Setup (Local)

``` bash
pip install -r requirements.txt
python migration_sequential.py
```

## Deployment (AKS)

-   Build Docker image\
-   Push to container registry\
-   Apply Kubernetes configs\
-   Trigger jobs via pipeline

## Notes

-   SQL backup files are not included for security reasons\
-   Replace placeholders in config files with your Azure credentials\
-   This project is designed for learning and demonstrating cloud-native
    migration workflows

## Author

Raghava Reddy
