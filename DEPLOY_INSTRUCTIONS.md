# Infrastructure Deployment Guide

You have four new services ready to deploy: **Ollama** (AI), **n8n** (Automation), **Uptime Kuma** (Monitoring), and **Mosquitto** (MQTT).

## Step 1: Move files to Server
You need to get the `docker-compose.yml` file onto your Ubuntu VM.
*   **Option A (VS Code Remote):** If you are connected via VS Code, just drag the `docker-compose.yml` into your server's folder (e.g., `~/home-server`).
*   **Option B (Copy/Paste):**
    1.  SSH into your server: `ssh <your-user>@<server-ip>`
    2.  Create a folder: `mkdir -p ~/home-server`
    3.  Go into it: `cd ~/home-server`
    4.  Create the file: `nano docker-compose.yml`
    5.  Paste the content of the `docker-compose.yml` file I created.
    6.  Save: `Ctrl+O`, `Enter`, `Ctrl+X`.

## Step 2: Launch the Stack
Run this command in the folder where you put the file:

```bash
docker compose up -d
```

*   `up`: Create and start containers.
*   `-d`: Detached mode (run in the background).

## Step 3: Verify
1.  **Check Status:** Run `docker ps`. You should see `ollama`, `n8n`, `uptime-kuma`, and `mosquitto` listed as "Up".
2.  **Test n8n:** Open your browser to `http://<server-ip>:5678`. You should see the n8n setup screen.
3.  **Test Ollama:** Open your browser to `http://<server-ip>:11434`. It should say "Ollama is running".
4.  **Test Uptime Kuma:** Open your browser to `http://<server-ip>:3001`. You should see the setup screen.
5.  **Test Mosquitto:** It runs on port 1883 (MQTT) and 9001 (Websockets). You can test it with an MQTT client or Home Assistant.

## Step 4: Home Assistant
*   Go to your **Proxmox Web Interface**.
*   Create a new VM and install **Home Assistant OS** following the official guide or the helper scripts (tteck scripts are great for this).
*   This is a manual step outside of Docker.
