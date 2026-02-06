# n8n Getting Started Guide for Home Server

## 1. Accessing Your n8n Instance
*   **URL**: `http://192.168.86.38:5678` (or `http://localhost:5678` if accessing locally)
*   **Credentials**: You should have set these up on first launch. If you need to reset them, check the `PASSWORD_RESET.md` file in the root directory.

## 2. Core Concepts
*   **Workflow**: A sequence of nodes connected together to automate a task.
*   **Node**: A step in the workflow. It can be a **Trigger** (starts the workflow) or an **Action** (does something).
*   **Connection**: The lines connecting nodes, passing data from one to the next.
*   **Execution**: A single run of a workflow.

## 3. Key Nodes for Your Home Server
Since you are running a "Privacy-First" and "Local-First" setup, here are the most relevant nodes:

### Triggers (Start the flow)
*   **Webhook**: Trigger a workflow via an HTTP request (e.g., from your Android app or Chrome extension).
*   **Schedule / Cron**: Run workflows at specific times (e.g., "Every morning at 8 AM").
*   **MQTT Trigger**: Listen for messages from your IoT devices (via Mosquitto).
*   **Postgres Trigger**: (If configured) Listen for changes in your database.

### Actions (Do the work)
*   **HTTP Request**: The "Swiss Army Knife". Call any API (local or remote).
    *   *Use for:* Calling Ollama (`http://ollama:11434`), Uptime Kuma, or external APIs.
*   **Postgres**: Read/Write data to your `personal_db`.
    *   *Use for:* Storing app data, logging events, retrieving vector embeddings.
*   **Read/Write File**: Interact with the local filesystem (mounted volumes).
*   **Code (JavaScript)**: Run custom logic if a node doesn't exist.

### Logic (Control the flow)
*   **If**: Conditional logic (e.g., "If temperature > 30, turn on fan").
*   **Switch**: Route data based on multiple conditions.
*   **Merge**: Combine data from multiple branches.

## 4. Templates
n8n has a vast library of templates. You can access them directly in the editor or browse [n8n.io/workflows](https://n8n.io/workflows).
*   **Recommendation**: Look for "Local" or "Self-Hosted" templates to avoid dependencies on paid cloud services.

## 5. Best Practices
*   **Naming**: Use clear names like `[Cron] Daily Backup` or `[Webhook] Android Notification`.
*   **Tagging**: Use tags like `#home-automation`, `#ai`, `#maintenance` to organize workflows.
*   **Error Handling**: Add an "Error Trigger" node to a separate workflow to catch and notify you of failures (e.g., via email or Gotify).

## 6. Integration with Your Stack
*   **Ollama**: Use the `HTTP Request` node to POST to `http://ollama:11434/api/generate`.
*   **Postgres**: Use the `Postgres` node. Credentials:
    *   Host: `personal_db` (internal docker network) or `192.168.86.38`
    *   User: `admin`
    *   Password: `Pepsiguy1!Postgres`
    *   Database: `personal_projects`
*   **Mosquitto**: Use `MQTT` nodes. Host: `mosquitto`.

## 7. Next Steps
1.  Create a "Hello World" workflow using a **Manual Trigger** and a **Debug** node.
2.  Connect n8n to Postgres and try to read a table.
3.  Build a workflow that takes a Webhook input, sends it to Ollama, and saves the response to Postgres.

## 8. Using the n8n API
You can programmatically manage your workflows using the n8n API.

### Setting up your Environment (Windows)
To use the API from your local machine, set your API Key as an environment variable. Run the provided PowerShell script:
`./home-server/n8n/windows_setup.ps1`

### Example: Creating a Workflow via API
We have created a demo script `home-server/n8n/create_demo_workflow.sh` that uses your API key to create a "Hello World" workflow.
Run it from the server terminal:
```bash
./home-server/n8n/create_demo_workflow.sh
```
This will create a new workflow named "API Generated Demo Workflow" in your n8n dashboard.

### Example: Creating the Catalog Query Workflow
We also created a script to build the "Bonus" workflow automatically:
```bash
./home-server/n8n/create_catalog_workflow.sh
```
*   **Note**: This script attempts to create a Postgres credential for you. If it fails (due to strict schema validation), the workflow will still be created. You just need to open the **Postgres** node in n8n and select your existing credential manually.

## 9. Bonus: Query Your Node Catalog
We have created a catalog of n8n nodes and templates in your Postgres database (`personal_projects`). You can query it directly from n8n!

1.  Add a **Postgres** node.
2.  Set **Operation** to `Execute Query`.
3.  Enter the query: `SELECT * FROM n8n_nodes WHERE category = 'Trigger';`
4.  Execute the node to see the list of available triggers we cataloged.

## 10. Troubleshooting
### "Connection Lost" Error
If you see a "Connection Lost" error in the top right corner of n8n:
1.  **Check URL**: Ensure you are accessing n8n via `http://192.168.86.38:5678` and not `localhost` (unless tunneling).
2.  **WebSockets**: We have switched the push backend to `websocket` in `docker-compose.yml` for better stability.
3.  **VPN/Proxy**: If using a VPN or Proxy, ensure it supports WebSocket connections.

## 11. Credentials Setup
We have created a script `home-server/n8n/setup_credentials.sh` to help you set up common credentials.

### 1. Home Server App Auth (Header Auth)
*   **Purpose**: Secure your Webhooks so only your Android App / Chrome Extension can trigger them.
*   **Key**: `X-API-KEY`
*   **Value**: `invincible-server-secret-key` (Change this in production!)
*   **Usage**: In your Android App, add this header to your HTTP requests.

### 2. Mosquitto MQTT
*   **Purpose**: Connect to your IoT broker.
*   **Host**: `mosquitto`
*   **Port**: `1883`
*   **Auth**: Anonymous (Passwordless) by default.
