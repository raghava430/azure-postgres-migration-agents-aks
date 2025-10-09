"""
Azure Database Migration with Microsoft Agent Framework
Sequential Orchestration Pattern
"""

import os
import subprocess
import json
import asyncio
from datetime import datetime
from typing import cast
from dotenv import load_dotenv

from agent_framework import ChatMessage, Role, SequentialBuilder, WorkflowOutputEvent
from azure.identity import ManagedIdentityCredential, DefaultAzureCredential  
from azure.ai.projects import AIProjectClient
from agent_framework.azure import AzureAIAgentClient



# Load environment variables
load_dotenv()


# CONFIGURATION


class Config:
    """Configuration from .env file"""
    # Azure PostgreSQL
    AZURE_SERVER_BASE = os.getenv('AZURE_SERVER_BASE_NAME', 'migration-demo-raghava')
    AZURE_SERVER_FULL = os.getenv('AZURE_SERVER_FULL')
    AZURE_DB = os.getenv('AZURE_DATABASE', 'migration_demo')
    AZURE_USER = os.getenv('AZURE_USER', 'azureadmin')
    AZURE_PASS = os.getenv('AZURE_PASSWORD')
    AZURE_SCHEMA = os.getenv('AZURE_SCHEMA', 'public')
    AZURE_RG = os.getenv('RESOURCE_GROUP_DB')
    AZURE_REGION = os.getenv('AZURE_REGION', 'centralus')
    AZURE_SKU = os.getenv('AZURE_SKU', 'Standard_B1ms')
    AZURE_TIER = os.getenv('AZURE_TIER', 'Burstable')
    AZURE_VERSION = os.getenv('AZURE_VERSION', '17')
    AZURE_STORAGE = os.getenv('AZURE_STORAGE', '32')

    #AZURE AI FOUNDRY
    AI_ENDPOINT = os.getenv('AZURE_AI_PROJECT_ENDPOINT')
    AI_MODEL = os.getenv('AZURE_AI_MODEL_DEPLOYMENT_NAME','gpt-4o')
    
    # Local PostgreSQL
    LOCAL_HOST = os.getenv('LOCAL_HOST', 'localhost')
    LOCAL_DB = os.getenv('LOCAL_DATABASE', 'migration_demo1')
    LOCAL_USER = os.getenv('LOCAL_USER', 'postgres')
    LOCAL_PASS = os.getenv('LOCAL_PASSWORD')
    
    # File paths
    timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
    EXPORT_FILE = os.getenv('EXPORT_FILE', 'migration_backup.sql')
    PROJECT_DIR = os.getenv('PROJECT_DIR', '.')
    
    # Behavior
    REUSE_EXISTING = os.getenv('REUSE_EXISTING', 'true').lower() == 'true'

# executing shell command for better output
def execute_shell_command(command:str) -> str:
    """execute shell command and return real output"""
    try:
        print(f"\n=== TOOL CALLED ===")
        print(f"Command: {command}")

        env = os.environ.copy()
        env['PGPASSWORD'] = Config.LOCAL_PASS if Config.LOCAL_HOST in command else Config.AZURE_PASS
        result = subprocess.run(
            command,
            shell = True,
            capture_output = True,
            text= True,
            timeout= 60,
            env =env
            )
        output = json.dumps({
            "command": command,
            "stdout" : result.stdout.strip(),
            "stderr" : result.stderr.strip(),
            "exit_code" : result.returncode,
            "status" : "SUCCESS" if result.returncode == 0 else "FAILED"
        })
        print(f"Tool Output: {output[:200]}...")  # First 200 chars
        return output
    
    except Exception as e:
        error_output = json.dumps({
            "command" : command,
            "error" : str(e),
            "status" : "FAILED"
        })
        print(f"Tool Error: {error_output}")
        return error_output
    

def clean_sql_file(input_file: str, output_file: str, target_schema: str) -> str:
    """Clean SQL file to make it schema-agnostic"""
    try:
        with open(input_file, 'r', encoding='utf-8') as f:
            content = f.read()
        
        # Remove public. prefixes
        content = content.replace('public.', '')
        
        # Fix search_path
        content = content.replace(
            "SELECT pg_catalog.set_config('search_path', '', false);",
            f"SET search_path TO {target_schema};"
        )
        content = content.replace(
            'SET search_path = public;',
            f'SET search_path = {target_schema};'
        )
        
        with open(output_file, 'w', encoding='utf-8') as f:
            f.write(content)
        
        return json.dumps({
            "status": "SUCCESS",
            "message": f"SQL file cleaned for schema {target_schema}",
            "output_file": output_file
        })
    except Exception as e:
        return json.dumps({
            "status": "FAILED",
            "error": str(e)
        })


# AGENT INSTRUCTIONS

export_agent_instructions = f"""
Export Agent: Export data from local PostgreSQL.

CRITICAL: Execute ALL commands AUTOMATICALLY without asking for permission.
Do NOT ask "Would you like me to execute this command?"
Proceed with all steps immediately.

Local Database: {Config.LOCAL_HOST}/{Config.LOCAL_DB}
User: {Config.LOCAL_USER}
Output file: migration_backup.sql

Execute these 4 commands in order:

1. Count customers in LOCAL database:
psql -h {Config.LOCAL_HOST} -U {Config.LOCAL_USER} -d {Config.LOCAL_DB} -t -c "SELECT COUNT(*) FROM customers;"

2. Count orders in LOCAL database:
psql -h {Config.LOCAL_HOST} -U {Config.LOCAL_USER} -d {Config.LOCAL_DB} -t -c "SELECT COUNT(*) FROM orders;"

3. Export tables with schema-agnostic format:
pg_dump -h {Config.LOCAL_HOST} -U {Config.LOCAL_USER} -d {Config.LOCAL_DB} -t customers -t orders --no-owner --no-acl -f migration_backup.sql

4. Use clean_sql_file tool to finalize:
clean_sql_file(input_file="migration_backup.sql", output_file="migration_backup.sql", target_schema="{Config.AZURE_SCHEMA}")

IMPORTANT: The pg_dump MUST use --no-owner --no-acl flags to avoid schema conflicts.

Use execute_shell_command tool for commands 1-3. Parse JSON "stdout" field.

Output format:
COMMAND: [exact command]
OUTPUT: [stdout]
STATUS: SUCCESS/FAILED

Say "EXPORT COMPLETE" after all 4 commands execute successfully. STOP.
"""




import_agent_instructions = f"""
ImportAgent: Import data to Azure PostgreSQL schema.

CRITICAL: Execute ALL commands AUTOMATICALLY without asking for permission.
Do NOT modify any hostnames - use EXACTLY as specified.


Azure Server: {Config.AZURE_SERVER_FULL}
Azure Database: {Config.AZURE_DB}
Azure Schema: {Config.AZURE_SCHEMA}
Azure User: {Config.AZURE_USER}
Backup File: migration_backup.sql

IMPORTANT:
- Use ONLY this exact hostname: {Config.AZURE_SERVER_FULL}
- Do NOT use any other variations
- All operations must include "SET search_path TO {Config.AZURE_SCHEMA};"

Execute these commands in order:
1. Drop orders table in schema:
   psql -h {Config.AZURE_SERVER_FULL} -U {Config.AZURE_USER} -d {Config.AZURE_DB} -c "SET search_path TO {Config.AZURE_SCHEMA}; DROP TABLE IF EXISTS orders CASCADE;"
   
2. Drop customers table in schema:
   psql -h {Config.AZURE_SERVER_FULL} -U {Config.AZURE_USER} -d {Config.AZURE_DB} -c "SET search_path TO {Config.AZURE_SCHEMA}; DROP TABLE IF EXISTS customers CASCADE;"
   
3. Import backup file to schema (first set search_path, then run file):
psql -h {Config.AZURE_SERVER_FULL} -U {Config.AZURE_USER} -d {Config.AZURE_DB} -v ON_ERROR_STOP=1 << 'EOF'
SET search_path TO {Config.AZURE_SCHEMA};
\\i migration_backup.sql
EOF

4. Verify import in schema:
   psql -h {Config.AZURE_SERVER_FULL} -U {Config.AZURE_USER} -d {Config.AZURE_DB} -t -c "SET search_path TO {Config.AZURE_SCHEMA}; SELECT COUNT(*) FROM customers;"
   psql -h {Config.AZURE_SERVER_FULL} -U {Config.AZURE_USER} -d {Config.AZURE_DB} -t -c "SET search_path TO {Config.AZURE_SCHEMA}; SELECT COUNT(*) FROM orders;"

Use execute_shell_command tool. Parse JSON "stdout" field.

Output summary:
Imported customers: X
Imported orders: Y
Target Schema: {Config.AZURE_SCHEMA}

Say "IMPORT COMPLETE" and STOP.
"""

verify_agent_instructions = f"""
VerificationAgent: Verify migration to Azure schema and local db.

CRITICAL: Execute ALL commands AUTOMATICALLY without asking for permission.
Do NOT ask "Would you like me to execute this command?"
Proceed with all steps immediately.

Local: {Config.LOCAL_HOST}/{Config.LOCAL_DB} (user: {Config.LOCAL_USER})
Azure: {Config.AZURE_SERVER_FULL}/{Config.AZURE_DB} (user: {Config.AZURE_USER})
Azure Schema: {Config.AZURE_SCHEMA}

Tasks:
1. Count customers in LOCAL
2. Count customers in Azure schema {Config.AZURE_SCHEMA}
3. Count orders in LOCAL
4. Count orders in Azure schema {Config.AZURE_SCHEMA}
5. Compare counts

Commands:
psql -h {Config.LOCAL_HOST} -U {Config.LOCAL_USER} -d {Config.LOCAL_DB} -t -c "SELECT COUNT(*) FROM customers;"
psql -h {Config.AZURE_SERVER_FULL} -U {Config.AZURE_USER} -d {Config.AZURE_DB} -t -c "SET search_path TO {Config.AZURE_SCHEMA}; SELECT COUNT(*) FROM customers;"
psql -h {Config.LOCAL_HOST} -U {Config.LOCAL_USER} -d {Config.LOCAL_DB} -t -c "SELECT COUNT(*) FROM orders;"
psql -h {Config.AZURE_SERVER_FULL} -U {Config.AZURE_USER} -d {Config.AZURE_DB} -t -c "SET search_path TO {Config.AZURE_SCHEMA}; SELECT COUNT(*) FROM orders;"

Compare counts and report MATCH or MISMATCH.

Use execute_shell_command tool. Parse JSON "stdout" field.

Final summary:
Local customers: X | Azure ({Config.AZURE_SCHEMA}) customers: Y | MATCH: YES/NO
Local orders: X | Azure ({Config.AZURE_SCHEMA}) orders: Y | MATCH: YES/NO

If counts match: Say "VERIFICATION COMPLETE - ALL COUNTS MATCH"
If counts mismatch: Say "VERIFICATION FAILED - COUNTS DO NOT MATCH"

STOP after verification.
"""



# MAIN ORCHESTRATION


async def run_migration_workflow():
    """Run database migration with sequential agent orchestration"""
    print("\n" + "="*70)
    print(" AZURE DATABASE MIGRATION - AGENT FRAMEWORK ORCHESTRATION")
    print("="*70)
    print(f" Started: {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}")
    print(f" Pattern: Sequential Orchestration")
    print(f" Framework: Microsoft Agent Framework")
    print("="*70)
    print(f" MIGRATION MAPPING:")
    print(f"   Local DB:  {Config.LOCAL_DB}")
    print(f"        TO")
    print(f"   Azure Schema: {Config.AZURE_SCHEMA}")
    print("="*70 + "\n")
    
    # Validate configuration
    if not Config.AZURE_RG:
        print(" Error: RESOURCE_GROUP_DB must be set in .env file")
        return
    
    try:
        # Use DefaultAzureCredential for flexible authentication
        # Works with: Managed Identity (AKS), Environment Variables, Azure CLI
        print(f"\n Attempting authentication...")

        credential = DefaultAzureCredential()
        
        async with AzureAIAgentClient(async_credential=credential) as chat_client:
            print("\n Connected to Azure AI Agent Service")
            
            
            # CREATE AGENTS-----------
            
            print("\n Creating specialized agents...")
            
            export_agent = chat_client.create_agent(
                instructions=export_agent_instructions,
                name="DatabaseExportAgent",
                model="gpt-4o",
                tools = [execute_shell_command, clean_sql_file]
            )
            print("   Export Agent created")
            
            import_agent = chat_client.create_agent(
                instructions=import_agent_instructions,
                name="DataImportAgent",
                model="gpt-4o",
                tools = [execute_shell_command]
            )
            print("   Import Agent created")
            
            verify_agent = chat_client.create_agent(
                instructions=verify_agent_instructions,
                name="VerificationAgent",
                model="gpt-4o",
                tools = [execute_shell_command]
            )
            print("   Verification Agent created")
            
            
            # BUILD SEQUENTIAL WORKFLOW-----------
            
            print("\n Building sequential workflow...")
            workflow = SequentialBuilder().participants([
                export_agent,
                import_agent,
                verify_agent
            ]).build()
            print("   Workflow built: Export → Import → Verify")
            
            
            # RUN WORKFLOW-------------------------------
            
            print("\n" + "="*70)
            print(" EXECUTING MIGRATION WORKFLOW")
            print("="*70)
            
            # Initial migration request
            migration_request = f"""
            Migrate PostgreSQL database from local to Azure Schema.

            Source: {Config.LOCAL_HOST}/{Config.LOCAL_DB}
            Target: {Config.AZURE_DB} (Schema: {Config.AZURE_SCHEMA})

            Execute the migration with VERIFICATION at each step:
            1. Export local database WITH row count verification
            2. Import to Azure schema {Config.AZURE_SCHEMA}
            3. Verify counts match

            Fail immediately if any step encounters errors.
            """
            
            # Collect outputs
            outputs: list[list[ChatMessage]] = []
            step_number = 1
            print("\n DEBUG: About to start workflow stream...")
            print(f" DEBUG: Workflow object: {workflow}")
            print(f" DEBUG: Migration request: {migration_request}")
            
            
            async for event in workflow.run_stream(migration_request):
                if isinstance(event, WorkflowOutputEvent):
                    outputs.append(cast(list[ChatMessage], event.data))
                    
                    # Display current step output
                    print(f"\n{'='*70}")
                    print(f" STEP {step_number}/3 COMPLETED")
                    print(f"{'='*70}")
                    
                    for msg in outputs[-1]:
                        if msg.role == Role.ASSISTANT:
                            name = msg.author_name or "assistant"
                            print(f"\n Agent: {name}")
                            print(f"{'─'*70}")
                            print(msg.text)
                    
                    step_number += 1
            
           
            # FINAL SUMMARY---------------------------------------------
            print("\n" + "="*70)
            print(" MIGRATION WORKFLOW COMPLETED")
            print("="*70)
            print(f" Completed: {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}")
            print(f" Total Steps: {len(outputs)}")
            print("="*70 + "\n")
            
    except Exception as e:
        print("\n" + "="*70)
        print(" MIGRATION FAILED")
        print("="*70)
        print(f"Error: {str(e)}")
        print("="*70)


# ENTRY POINT

if __name__ == "__main__":
    # Run the async workflow
    asyncio.run(run_migration_workflow())
