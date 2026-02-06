# Project Context & System Architecture

**Usage Instruction for LLMs:**
This file contains the "Ground Truth" of my current home server build. When I ask you to help me build a new feature, app, or automation, **read this file first**. It defines my hardware, software stack, active services, and development philosophy. Do not hallucinate a different setup.

---

## 1. High-Level Goals
*   **The "Invincible" Server:** A centralized, always-on home server that provides services (AI, Automation, Database) to my "Client" devices (Phone, Laptop).
*   **Privacy-First AI:** Running local LLMs (Ollama) and vector databases (pgvector) to build a personal AI assistant ("Olivia") that owns my data.
*   **Cross-Platform Ecosystem:** Building a unified interface (Android App + Chrome Extension) that connects to this server.
*   **Automation:** Using n8n and Home Assistant to automate physical and digital tasks.

---

## 2. Infrastructure Stack

### Hardware & Virtualization
*   **Host Hardware:** Mini PC (Intel NUC/Beelink style).
*   **Hypervisor:** **Proxmox VE**.
    *   *Role:* Manages VMs and LXC containers. Handles backups and snapshots.
*   **Primary VM (The "Docker Host"):**
    *   **OS:** Ubuntu Server (Linux).
    *   **IP Address:** `192.168.86.38`
    *   **Role:** Runs all application containers via Docker Compose.

### Container Orchestration
*   **Engine:** Docker.
*   **Management:** **Portainer** (Web UI) and **Docker Compose** (YAML files).
*   **Location:** `~/home-server/docker-compose.yml` is the source of truth for the main stack.

---

## 3. Active Services (The "Truth")

These services are currently **deployed and running** on the Ubuntu VM (`192.168.86.38`).

| Service | Internal Port | URL | Purpose |
| :--- | :--- | :--- | :--- |
| **Portainer** | `9443` | `https://192.168.86.38:9443` | Docker Management Dashboard. |
| **PostgreSQL** | `5432` | `postgres://...:5432` | Main Database. Includes `pgvector` extension for AI embeddings. |
| **Ollama** | `11434` | `http://192.168.86.38:11434` | Local LLM API (The "Brain"). |
| **n8n** | `5678` | `http://192.168.86.38:5678` | Workflow Automation (The "Glue"). |
| **Uptime Kuma** | `3001` | `http://192.168.86.38:3001` | Service Monitoring & Alerts. |
| **Mosquitto** | `1883` | `mqtt://192.168.86.38:1883` | MQTT Broker for IoT devices. |

---

## 4. Development Roadmap & Status

### ✅ Completed
*   Proxmox installed and configured.
*   Ubuntu VM deployed.
*   Docker & Portainer installed.
*   Core Services deployed (Postgres, Ollama, n8n, Kuma, MQTT).

### 🚧 In Progress / Next Steps
1.  **Home Assistant:**
    *   *Plan:* Deploy as a **separate VM** (HAOS) in Proxmox, NOT a Docker container.
    *   *Reason:* To gain access to the Supervisor and Add-on store for easier management of Zigbee/Matter.
2.  **Remote Access:**
    *   *Plan:* Install **Tailscale** on the Ubuntu VM and personal devices.
    *   *Goal:* Access `192.168.86.38` from outside the home network without opening router ports.
3.  **App Development:**
    *   *Plan:* Build a **React + Vite + Capacitor** app.
    *   *Goal:* A single codebase that deploys as a Native Android App and a Chrome Extension.
    *   *Backend:* Will connect to the existing Python/FastAPI (to be built) or directly to n8n/Ollama.

---

## 5. Technical Preferences (Style Guide)
*   **Docker First:** If a solution can be containerized, do it.
*   **Compose over CLI:** Always provide `docker-compose.yml` snippets, not `docker run` commands.
*   **Python:** Preferred language for custom scripts/backends.
*   **Explanation Style:** Explain *why* we are doing something (architectural context) before showing *how* (commands).
