"""
Azure Database Incremental Sync with Microsoft Agent Framework
Sequential Orchestration Pattern - Sync Only New Records
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
    AZURE_SERVER_FULL = os.getenv('AZURE_SERVER_FULL')
    AZURE_DB = os.getenv('AZURE_DATABASE', 'migration_demo')
    AZURE_USER = os.getenv('AZURE_USER', 'azureadmin')
    AZURE_PASS = os.getenv('AZURE_PASSWORD')
    
    # Local PostgreSQL
    LOCAL_HOST = os.getenv('LOCAL_HOST', 'localhost')
    LOCAL_DB = os.getenv('LOCAL_DATABASE', 'migration_demo')
    LOCAL_USER = os.getenv('LOCAL_USER', 'postgres')
    LOCAL_PASS = os.getenv('LOCAL_PASSWORD')
    


# TOOL: Execute Shell Command
def execute_shell_command(command: str) -> str:
    """Execute shell command and return real output"""
    try:
        print(f"\n=== TOOL CALLED ===")
        print(f"Command: {command}")

        env = os.environ.copy()
        env['PGPASSWORD'] = Config.LOCAL_PASS if 'localhost' in command else Config.AZURE_PASS
        
        result = subprocess.run(
            command,
            shell=True,
            capture_output=True,
            text=True,
            timeout=60,
            env=env
            )
        
        output = json.dumps({
            "command": command,
            "stdout": result.stdout.strip(),
            "stderr": result.stderr.strip(),
            "exit_code": result.returncode,
            "status": "SUCCESS" if result.returncode == 0 else "FAILED"
        })
        print(f"Tool Output: {output[:200]}...")  # First 200 chars
        return output
    except Exception as e:
        error_output = json.dumps ({
            "command": command,
            "error": str(e),
            "status": "FAILED"
        })
        print(f"Tool Error: {error_output}")
        return error_output

# AGENT INSTRUCTIONS
check_new_records_instructions = f"""
CheckNewRecordsAgent: Find new records added since last sync.

Azure DB: {Config.AZURE_SERVER_FULL}/{Config.AZURE_DB}

Tasks:
1. Get last sync timestamp from sync_metadata table for customers
2. Get last sync timestamp from sync_metadata table for orders
3. Count new customers in LOCAL where created_at > last_sync_timestamp
4. Count new orders in LOCAL where created_at > last_sync_timestamp

Commands to run:
psql -h {Config.AZURE_SERVER_FULL} -U {Config.AZURE_USER} -d {Config.AZURE_DB} -t -c "SELECT last_sync_timestamp FROM sync_metadata WHERE table_name='customers';"
psql -h {Config.AZURE_SERVER_FULL} -U {Config.AZURE_USER} -d {Config.AZURE_DB} -t -c "SELECT last_sync_timestamp FROM sync_metadata WHERE table_name='orders';"
psql -h localhost -U {Config.LOCAL_USER} -d {Config.LOCAL_DB} -t -c "SELECT COUNT(*) FROM customers WHERE created_at > 'TIMESTAMP_FROM_STEP1';"
psql -h localhost -U {Config.LOCAL_USER} -d {Config.LOCAL_DB} -t -c "SELECT COUNT(*) FROM orders WHERE created_at > 'TIMESTAMP_FROM_STEP2';"

Use execute_shell_command tool.

Output:
Last sync customers: YYYY-MM-DD HH:MM:SS
Last sync orders: YYYY-MM-DD HH:MM:SS
New customers: X
New orders: Y

Say "CHECK COMPLETE" and STOP.
"""

sync_new_records_instructions = f"""
SyncNewRecordsAgent: Sync only new records to Azure.

Local: localhost/{Config.LOCAL_DB}
Azure: {Config.AZURE_SERVER_FULL}/{Config.AZURE_DB}

Get last sync timestamps from previous agent output.

Tasks:
1. Get new customers from LOCAL (created_at > last_sync)
2. INSERT each new customer into Azure one by one
3. Get new orders from LOCAL (created_at > last_sync)
4. INSERT each new order into Azure one by one
5. Update sync_metadata with current timestamp

For each record, use INSERT:
psql -h {Config.AZURE_SERVER_FULL} -U {Config.AZURE_USER} -d {Config.AZURE_DB} -c "INSERT INTO customers VALUES (...);"

Then update metadata:
psql -h {Config.AZURE_SERVER_FULL} -U {Config.AZURE_USER} -d {Config.AZURE_DB} -c "UPDATE sync_metadata SET last_sync_timestamp=CURRENT_TIMESTAMP WHERE table_name='customers';"

Use execute_shell_command tool.

Output:
Customers synced: X
Orders synced: Y

Say "SYNC COMPLETE" and STOP.
"""

verify_sync_instructions = f"""
VerificationAgent: Verify incremental sync worked.

Local: localhost/{Config.LOCAL_DB}
Azure: {Config.AZURE_SERVER_FULL}/{Config.AZURE_DB}

Tasks:
1. Count  customers in LOCAL
2. Count  customers in AZURE
3. Count  orders in LOCAL
4. Count  orders in AZURE
5. Compare counts - report MATCH or MISMATCH

Commands:
psql -h localhost -U {Config.LOCAL_USER} -d {Config.LOCAL_DB} -t -c "SELECT COUNT(*) FROM customers;"
psql -h {Config.AZURE_SERVER_FULL} -U {Config.AZURE_USER} -d {Config.AZURE_DB} -t -c "SELECT COUNT(*) FROM customers;"
psql -h localhost -U {Config.LOCAL_USER} -d {Config.LOCAL_DB} -t -c "SELECT COUNT(*) FROM orders;"
psql -h {Config.AZURE_SERVER_FULL} -U {Config.AZURE_USER} -d {Config.AZURE_DB} -t -c "SELECT COUNT(*) FROM orders;"

Final summary:
Local customers: X | Azure customers: Y | MATCH: YES/NO
Local orders: X | Azure orders: Y | MATCH: YES/NO

Say "VERIFICATION COMPLETE" and STOP.
"""

# MAIN WORKFLOW
async def run_incremental_sync():
    print("\n" + "="*70)
    print(" AZURE DATABASE INCREMENTAL SYNC - AGENT FRAMEWORK")
    print("="*70)
    print(f" Started: {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}")
    print(f" Pattern: Sequential Orchestration")
    print(f" Mode: Incremental (New Records Only)")
    print("="*70 + "\n")
    
    try:
        # Create credential using Azure CLI
        credential = AzureCliCredential()
        async with AzureAIAgentClient(async_credential=credential) as chat_client:
            print("  Connected to Azure AI Agent Service\n")
            
            # Create agents
            print(" Creating specialized agents...")
            
            check_agent = chat_client.create_agent(
                instructions=check_new_records_instructions,
                name="CheckNewRecordsAgent",
                model="gpt-4o",
                tools=[execute_shell_command]
            )
            print("   Check Agent created")
            
            sync_agent = chat_client.create_agent(
                instructions=sync_new_records_instructions,
                name="SyncNewRecordsAgent",
                model="gpt-4o",
                tools=[execute_shell_command]
            )
            print("   Sync Agent created")
            
            verify_agent = chat_client.create_agent(
                instructions=verify_sync_instructions,
                name="VerificationAgent",
                model="gpt-4o",
                tools=[execute_shell_command]
            )
            print("   Verification Agent created")
            
            # Build workflow
            print("\n Building sequential workflow...")
            workflow = SequentialBuilder().participants([
                check_agent,
                sync_agent,
                verify_agent
            ]).build()
            print("   Workflow built: Check -> Sync -> Verify\n")
            
            # Execute workflow
            print("="*70)
            print(" EXECUTING INCREMENTAL SYNC WORKFLOW")
            print("="*70 + "\n")
            
            sync_request = """
            Perform incremental sync of PostgreSQL database from local to Azure.
            
            Source: localhost/migration_demo
            Target: Azure PostgreSQL
            
            Execute incremental sync:
            1. Check for new records since last sync (use sync_metadata table)
            2. Sync ONLY new records (do NOT drop existing data)
            3. Verify total counts match between local and Azure
            
            Fail immediately if any step encounters errors.
            """
            
            outputs = []
            step = 1
            
            async for event in workflow.run_stream(sync_request):
                if isinstance(event, WorkflowOutputEvent):
                    outputs.append(cast(list[ChatMessage], event.data))
                    
                    print("\n" + "="*70)
                    print(f" STEP {step}/3 COMPLETED")
                    print("="*70 + "\n")
                    
                    for msg in outputs[-1]:
                        if msg.role == Role.ASSISTANT:
                            print(f" Agent: {msg.author_name}")
                            print("─"*70)
                            print(msg.text)
                            print()
                    
                    step += 1
            
            print("="*70)
            print(" INCREMENTAL SYNC COMPLETED")
            print("="*70)
            print(f" Completed: {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}")
            print(f" Total Steps: {len(outputs)}")
            print("="*70 + "\n")

    except Exception as e:
        print("\n" + "="*70)
        print(" SYNC FAILED")
        print("="*70)
        print(f"Error: {str(e)}")


if __name__ == "__main__":
    asyncio.run(run_incremental_sync())
