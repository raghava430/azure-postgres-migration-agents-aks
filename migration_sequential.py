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
from agent_framework.azure import AzureAIAgentClient
from azure.identity import AzureCliCredential

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
    AZURE_RG = os.getenv('RESOURCE_GROUP_DB')
    AZURE_REGION = os.getenv('AZURE_REGION', 'centralus')
    AZURE_SKU = os.getenv('AZURE_SKU', 'Standard_B1ms')
    AZURE_TIER = os.getenv('AZURE_TIER', 'Burstable')
    AZURE_VERSION = os.getenv('AZURE_VERSION', '17')
    AZURE_STORAGE = os.getenv('AZURE_STORAGE', '32')
    
    # Local PostgreSQL
    LOCAL_HOST = os.getenv('LOCAL_HOST', 'localhost')
    LOCAL_DB = os.getenv('LOCAL_DATABASE', 'migration_demo')
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
        env['PGPASSWORD'] = Config.LOCAL_PASS if 'localhost' in command else Config.AZURE_PASS
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

# AGENT INSTRUCTIONS

export_agent_instructions = f"""
Export local database to SQL file.

Database: {Config.LOCAL_DB}
User: {Config.LOCAL_USER}
Host: {Config.LOCAL_HOST}
Output file: migration_backup.sql

Execute these commands in order:
1. psql -h localhost -U postgres -d migration_demo -t -c "SELECT COUNT(*) FROM customers;"
2. psql -h localhost -U postgres -d migration_demo -t -c "SELECT COUNT(*) FROM orders;"
3. pg_dump -U postgres -h localhost -d migration_demo -f migration_backup.sql

Use execute_shell_command tool. Parse JSON "stdout" field.

Output format:
COMMAND: [exact command]
OUTPUT: [stdout]
STATUS: SUCCESS/FAILED

Say "EXPORT COMPLETE" after all 3 commands. STOP.
"""

azure_setup_agent_instructions = f"""
Verify Azure PostgreSQL server exists.

Server name: {Config.AZURE_SERVER_FULL.split('.')[0] if Config.AZURE_SERVER_FULL else 'unknown'}
Resource Group: {Config.AZURE_RG}

Execute this command:
az postgres flexible-server show --name {Config.AZURE_SERVER_FULL.split('.')[0] if Config.AZURE_SERVER_FULL else 'unknown'} --resource-group {Config.AZURE_RG}

Use execute_shell_command tool. Parse JSON "stdout" field.

Output format:
COMMAND: [exact command]
OUTPUT: [stdout]
STATUS: SUCCESS/FAILED

Say "SETUP COMPLETE" after command. STOP.
"""

import_agent_instructions = f"""
Import SQL file to Azure PostgreSQL.

Server: {Config.AZURE_SERVER_FULL}
Database: {Config.AZURE_DB}
User: {Config.AZURE_USER}
File: migration_backup.sql

Execute these commands in order:
1. psql -h {Config.AZURE_SERVER_FULL} -U {Config.AZURE_USER} -d {Config.AZURE_DB} -c "DROP TABLE IF EXISTS customers CASCADE;"
2. psql -h {Config.AZURE_SERVER_FULL} -U {Config.AZURE_USER} -d {Config.AZURE_DB} -c "DROP TABLE IF EXISTS orders CASCADE;"
3. psql -h {Config.AZURE_SERVER_FULL} -U {Config.AZURE_USER} -d {Config.AZURE_DB} -f migration_backup.sql
4. psql -h {Config.AZURE_SERVER_FULL} -U {Config.AZURE_USER} -d {Config.AZURE_DB} -t -c "SELECT COUNT(*) FROM customers;"
5. psql -h {Config.AZURE_SERVER_FULL} -U {Config.AZURE_USER} -d {Config.AZURE_DB} -t -c "SELECT COUNT(*) FROM orders;"

Use execute_shell_command tool. Parse JSON "stdout" field.

Output format:
COMMAND: [exact command]
OUTPUT: [stdout]
STATUS: SUCCESS/FAILED

Say "IMPORT COMPLETE" after all 5 commands. STOP.
"""

verify_agent_instructions = f"""
Verify migration by comparing local vs Azure row counts.

Local: localhost/{Config.LOCAL_DB} (user: {Config.LOCAL_USER})
Azure: {Config.AZURE_SERVER_FULL}/{Config.AZURE_DB} (user: {Config.AZURE_USER})

Execute these commands in order:
1. psql -h localhost -U {Config.LOCAL_USER} -d {Config.LOCAL_DB} -t -c "SELECT COUNT(*) FROM customers;"
2. psql -h localhost -U {Config.LOCAL_USER} -d {Config.LOCAL_DB} -t -c "SELECT COUNT(*) FROM orders;"
3. psql -h {Config.AZURE_SERVER_FULL} -U {Config.AZURE_USER} -d {Config.AZURE_DB} -t -c "SELECT COUNT(*) FROM customers;"
4. psql -h {Config.AZURE_SERVER_FULL} -U {Config.AZURE_USER} -d {Config.AZURE_DB} -t -c "SELECT COUNT(*) FROM orders;"

Compare counts and report MATCH or MISMATCH.

Use execute_shell_command tool. Parse JSON "stdout" field.

Final summary:
Local customers: X | Azure customers: Y | MATCH: YES/NO
Local orders: X | Azure orders: Y | MATCH: YES/NO

Say "VERIFICATION COMPLETE" after summary. STOP.
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
    
    # Validate configuration
    if not Config.AZURE_RG:
        print(" Error: RESOURCE_GROUP_DB must be set in .env file")
        return
    
    try:
        # Create credential using Azure CLI
        credential = AzureCliCredential()
        
        async with AzureAIAgentClient(async_credential=credential) as chat_client:
            print("\n Connected to Azure AI Agent Service")
            
            
            # CREATE AGENTS-----------
            
            print("\n Creating specialized agents...")
            
            export_agent = chat_client.create_agent(
                instructions=export_agent_instructions,
                name="DatabaseExportAgent",
                model="gpt-4o",
                tools = [execute_shell_command]
            )
            print("   Export Agent created")
            
            azure_setup_agent = chat_client.create_agent(
                instructions=azure_setup_agent_instructions,
                name="AzureSetupAgent",
                model="gpt-4o",
                tools = [execute_shell_command]
            )
            print("   Azure Setup Agent created")
            
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
                azure_setup_agent,
                import_agent,
                verify_agent
            ]).build()
            print("   Workflow built: Export → Azure Setup → Import → Verify")
            
            
            # RUN WORKFLOW-------------------------------
            
            print("\n" + "="*70)
            print(" EXECUTING MIGRATION WORKFLOW")
            print("="*70)
            
            # Initial migration request
            migration_request = f"""
            Migrate PostgreSQL database from local to Azure.
            
            Source: {Config.LOCAL_HOST}/{Config.LOCAL_DB}
            Target: Azure PostgreSQL ({Config.AZURE_REGION})
            
            Execute the migration with VERIFICATION at each step:
            1. Export local database WITH row count verification
            2. Setup Azure PostgreSQL
            3. Import data WITH cleanup (DROP CASCADE)
            4. Verify migration by COMPARING local vs Azure counts

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
                    print(f" STEP {step_number}/4 COMPLETED")
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
            print("="*70)
            
            # Save results
            result_file = os.path.join(
                Config.PROJECT_DIR,
                f"migration_results_{datetime.now().strftime('%Y%m%d_%H%M%S')}.txt"
            )
            
            with open(result_file, 'w', encoding='utf-8') as f:
                f.write("="*70 + "\n")
                f.write("AZURE DATABASE MIGRATION RESULTS\n")
                f.write("="*70 + "\n\n")
                
                for i, step_output in enumerate(outputs, start=1):
                    f.write(f"\nSTEP {i}:\n")
                    f.write("-"*70 + "\n")
                    for msg in step_output:
                        if msg.role == Role.ASSISTANT:
                            f.write(f"\nAgent: {msg.author_name}\n")
                            f.write(f"{msg.text}\n")
                    f.write("\n")
            
            print(f"\n Results saved to: {result_file}")
            
    except Exception as e:
        print("\n" + "="*70)
        print(" MIGRATION FAILED")
        print("="*70)
        print(f"Error: {str(e)}")
        print("\nTroubleshooting:")
        print("1. Ensure you're logged in to Azure CLI: az login")
        print("2. Check .env file has correct values")
        print("3. Verify Azure subscription is active")
        print("="*70)


# ENTRY POINT

if __name__ == "__main__":
    # Run the async workflow
    asyncio.run(run_migration_workflow())
