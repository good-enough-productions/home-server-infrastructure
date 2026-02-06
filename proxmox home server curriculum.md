# The "Invincible" Server: A Curriculum for the Modern Maker

## Introduction
This document is a comprehensive guide designed to take you from "following instructions" to "architecting solutions." It is built upon your existing setup (Proxmox, Ubuntu, Docker, Portainer, Postgres) and focuses on the *why* and *how* of building a centralized, AI-powered home ecosystem.

---

## Module 1: Foundations & Philosophy

### 1.1 The "Why": Moving from Consumer to Creator
Most people use computers as "Clients"—devices that consume information (watching Netflix, browsing the web). You are building a "Server"—a device that *provides* services.

*   **Centralization:** Instead of having your notes, files, and code scattered across your laptop, phone, and tablet, they live in one place. Your devices become merely "screens" to view that central truth.
*   **Privacy:** You own the data. No monthly fees to Dropbox or Google for things you can host yourself.
*   **Always-on Automation:** Your laptop sleeps when you close it. Your server never sleeps. It can scrape websites, monitor stock prices, or record TV shows while you are at work.

### 1.2 The Architecture: Understanding the Stack
Think of your setup like a physical building.

1.  **The Land (Hardware):** Your Mini PC. It provides the raw resources (CPU, RAM, Storage).
2.  **The Landlord (Proxmox):** The management layer. It decides who gets to live on the land. It allows you to run multiple "Houses" (VMs) on the same land without them fighting.
3.  **The House (Ubuntu VM):** A specific tenant. This is a full computer running inside Proxmox. It thinks it owns the hardware, but Proxmox is lying to it (benevolently).
4.  **The Appliances (Docker Containers):** The tools inside the house. Your Database, your Dashboard, your future Apps. They are self-contained. If the Toaster (a container) breaks, you don't have to burn down the House (Ubuntu).

### 1.3 The Network: The "Secret Handshake"
*   **IP Address:** The street address.
    *   `192.168.86.38`: The address of your Ubuntu VM.
*   **Port:** The door number.
    *   `:9443`: The door to Portainer (Dashboard).
    *   `:5432`: The door to Postgres (Database).
    *   `:80`: The front door (Websites).
*   **SSH (Secure Shell):** The maintenance tunnel. It allows you to teleport your terminal from your laptop into the server.
    *   **Why use it?** To install heavy machinery (like Docker) or fix things when the graphical interface breaks.
    *   **Why not use it?** For daily tasks, we prefer Web UIs (Portainer) because they are easier to visualize.

---

## Module 2: The Environment (Your Current Setup)

### 2.1 Proxmox (The Hypervisor)
*   **What it is:** A specialized OS based on Debian Linux designed solely to manage Virtual Machines.
*   **Why we use it:**
    *   **Snapshots:** Before you try something risky on Ubuntu, you take a snapshot in Proxmox. If you break Ubuntu, you click "Rollback" and you are back in time 5 seconds later. This gives you the confidence to experiment.
    *   **Isolation:** You can spin up a second VM for "Dangerous AI Experiments" that is completely walled off from your "Personal Database."

### 2.2 Ubuntu VM (The Host)
*   **What it is:** The standard version of Linux.
*   **Why we use it:** It has the best support. If you have a problem, someone else has solved it on Ubuntu.
*   **Your VM:** It is currently the "Docker Host." Its only job is to run the Docker Engine.

### 2.3 Docker (The Engine)
*   **What it is:** A platform for running applications in isolated "Containers."
*   **The "Container" Concept:**
    *   Imagine installing Python. You install v3.10. Then a new app needs v3.12. You upgrade, and the old app breaks.
    *   **Docker solves this:** It wraps the app *and* its specific version of Python into a sealed box. You can run 50 different apps with 50 different Python versions, and they never know about each other.
*   **Alternatives:**
    *   *Bare Metal:* Installing everything directly on Ubuntu. (Messy, hard to clean up).
    *   *Virtual Machines:* Running a full OS for every app. (Too heavy, wastes RAM).

### 2.4 Portainer (The Dashboard)
*   **What it is:** A web interface for Docker.
*   **Why we use it:** Docker is a command-line tool. Portainer gives you buttons. You can see logs, restart apps, and edit configurations without typing `sudo docker run...` ever again.

### 2.5 PostgreSQL (The Brain)
*   **What it is:** An enterprise-grade Relational Database.
*   **Why we use it:**
    *   **Standardization:** It is the industry standard. Learning it pays off professionally.
    *   **pgvector:** The extension we installed allows it to store "Embeddings" (AI memories). This is crucial for your "Olivia" assistant.
---

## Module 3: Practical Skills - Managing Containers

### 3.1 Anatomy of a Container
To "speak Docker," you need to understand four words:
1.  **Image:** The "Recipe." A read-only template (e.g., `postgres:16`). You download this from the internet.
2.  **Container:** The "Cake." A running instance of the image. You can bake 10 cakes from one recipe.
3.  **Volume:** The "Plate." If you delete the container (eat the cake), the data inside it is gone. A Volume is a folder on your Ubuntu VM that is "mounted" into the container. This ensures your data survives even if you delete the container.
4.  **Port:** The "Serving Window." The container runs on an internal port (e.g., 3000). You map it to an external port (e.g., 3001) so you can reach it from your laptop.

### 3.2 The "Stack" (Docker Compose)
In Portainer, we use **Stacks**. A Stack is just a text file (YAML) that describes the Image, Volume, and Port all in one place.
*   **Why?** If you use `docker run` commands, you'll forget what flags you used. A Stack file is self-documenting.

### 3.3 Exercise: Installing Uptime Kuma
Let's install a tool to monitor your websites and server health.

1.  **Open Portainer** -> **Local** -> **Stacks** -> **Add Stack**.
2.  **Name:** `uptime-kuma`
3.  **Editor:** Paste this:
    ```yaml
    services:
      uptime-kuma:
        image: louislam/uptime-kuma:1
        container_name: uptime-kuma
        volumes:
          - uptime-kuma-data:/app/data
        ports:
          - "3001:3001"  # <--- You will access it at 192.168.86.38:3001
        restart: always

    volumes:
      uptime-kuma-data:
    ```
4.  **Deploy.**
5.  **Verify:** Go to `http://192.168.86.38:3001`. You just built a monitoring station in 30 seconds.

---

## Module 4: Home Assistant & Automation

### 4.1 The Great Divide: OS vs. Container
This is where most beginners get confused.
*   **Home Assistant OS (HAOS):** You dedicate a whole VM to it. It includes a "Supervisor" and an "Add-on Store."
*   **Home Assistant Container:** You run it as just another Docker container (like we did with Postgres). **It does NOT have the Add-on Store.**

**Which should you choose?**
*   Since you have Proxmox, **create a new VM and install Home Assistant OS.**
*   **Why?** The "Add-on Store" is incredibly convenient for beginners. It manages complex configurations (like MQTT, Zigbee, Matter) for you.
*   **If you use Docker:** You have to install those "Add-ons" manually as separate Docker containers and wire them together. This gives you more control but requires more work.

### 4.2 Understanding "Add-ons"
An "Add-on" in Home Assistant is actually just a Docker Container that Home Assistant manages for you.
*   **Example:** "Mosquitto Broker" (for IoT).
    *   **In HAOS:** You click "Install" in the Add-on store. HAOS spins up a hidden Docker container and connects it.
    *   **In Docker:** You go to Portainer, create a `mosquitto` stack, open ports, and configure Home Assistant to talk to it IP-to-IP.

### 4.3 Exercise: Setting up MQTT (The Docker Way)
Since you already have a Docker host, let's set up the "IoT Language" (MQTT) manually so you understand what HAOS does under the hood.

1.  **Create a Stack** in Portainer named `mqtt`.
2.  **Paste:**
    ```yaml
    services:
      mosquitto:
        image: eclipse-mosquitto
        container_name: mosquitto
        ports:
          - "1883:1883" # The standard MQTT port
          - "9001:9001" # Web interface
        volumes:
          - mosquitto_data:/mosquitto/data
          - mosquitto_config:/mosquitto/config
        restart: always

    volumes:
      mosquitto_data:
      mosquitto_config:
    ```
3.  **Deploy.**
4.  **Result:** Your server is now listening on Port 1883 for smart lightbulbs to scream "I'M ON!"

---

## Module 5: The Developer's Workflow (Building Apps)

### 5.1 The Cycle
You are no longer just writing scripts; you are building *systems*.
1.  **Idea:** "I want a script that checks if the garage is open."
2.  **Local Dev:** Write `garage.py` on your laptop. Use `db.py` to save data to the server.
3.  **Containerize:** Wrap `garage.py` in a `Dockerfile`.
4.  **Deploy:** Ship the container to the server so it runs 24/7.

### 5.2 Step-by-Step: Dockerizing a Python Script
Let's say you have `main.py` and `requirements.txt`.

1.  **Create a file named `Dockerfile` (no extension):**
    ```dockerfile
    # The Base Image (The OS)
    FROM python:3.10-slim

    # The Work Directory (Where we live inside the box)
    WORKDIR /app

    # Copy files from Laptop -> Box
    COPY requirements.txt .
    RUN pip install --no-cache-dir -r requirements.txt
    COPY . .

    # The Command to run when the box opens
    CMD ["python", "main.py"]
    ```

2.  **Build the Image (On your Server):**
    *   Move the files to the server (drag and drop via VS Code Remote or use Git).
    *   Run: `docker build -t garage-monitor .`

3.  **Run the Container:**
    *   Run: `docker run -d --name garage-app --restart always garage-monitor`

### 5.3 Why this matters
You can now restart your server, update Ubuntu, or mess with other files, and your `garage-app` will just keep working. It is "Invincible."

---

## Module 6: Extending Your Reach

### 6.1 Tailscale (The Magic VPN)
*   **The Problem:** You want to check your server from the grocery store, but your home router blocks you.
*   **The Solution:** Tailscale.
*   **Action:**
    1.  Install Tailscale on your Ubuntu VM: `curl -fsSL https://tailscale.com/install.sh | sh`
    2.  Install Tailscale on your Android Phone.
    3.  **Result:** Your phone and server are now on a private "Mesh Network." You can open `http://192.168.86.38:9443` from anywhere in the world (using the Tailscale IP).

### 6.2 Android Integration
*   **Concept:** Your Android app is just a "Remote Control" for the server.
*   **How to build it:**
    *   Use **Retrofit** (Java/Kotlin) to send HTTP requests to your server.
    *   **Example:** Your server runs a Python API (using FastAPI). Your Android app sends `POST /api/garage/open`. The Python script receives it and opens the garage.

### 6.3 Private AI (Ollama)
*   **The Goal:** Chat with "Olivia" without sending data to OpenAI.
*   **Action:** Run Ollama in Docker.
    ```bash
    docker run -d -v ollama:/root/.ollama -p 11434:11434 --name ollama ollama/ollama
    ```
*   **Usage:** You can now send prompts to `http://192.168.86.38:11434` from your Python scripts or Android app.

---

## Conclusion
You have built a foundation that 99% of developers never achieve. You have a centralized, backed-up, always-on server with a professional database and the ability to deploy any software in seconds.

**Your Next Steps:**
1.  **Install Uptime Kuma** (Module 3) to feel the power of "One Click Install."
2.  **Set up Home Assistant OS** as a new VM in Proxmox.
3.  **Build your first "Olivia" memory script** using the `db.py` and `pgvector` setup.
