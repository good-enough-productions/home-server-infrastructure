# Setting Up VS Code Remote - SSH

You asked: *"I assume that means I need to be running VS Code on the server itself?"*
**Answer:** No! That's the magic. You run VS Code on your **Windows PC**, but it "tunnels" into the server. It feels like you are editing local files, but you are actually editing files on the server.

## The Division of Labor

| Who | What they can do | Why? |
| :--- | :--- | :--- |
| **Me (Antigravity)** | Write code, create config files, organize plans. | I live in a secure sandbox. I can read/write files in your `C:\Users\dschm\Desktop\Home Server` folder, but I **cannot** see or touch your Proxmox server (Ubuntu VM) because it is on your private network and I don't have your SSH keys. |
| **You (The User)** | Move files to the server, run terminal commands, install extensions. | You have physical access and the "Keys to the Castle" (SSH credentials). You act as the bridge between my code and your infrastructure. |

---

## Step-by-Step: Connecting VS Code to Your Server

### 1. Install the Extension (You do this)
1.  Open VS Code on your Windows PC.
2.  Click the **Extensions** icon (blocks on the left) or press `Ctrl+Shift+X`.
3.  Search for **"Remote - SSH"** (by Microsoft).
4.  Click **Install**.

### 2. Configure the Connection (You do this)
1.  Click the new **Remote Explorer** icon on the left sidebar (looks like a monitor with a `><` symbol).
2.  Hover over "SSH" and click the **+ (Plus)** button.
3.  Enter your connection command (from your notes):
    ```bash
    ssh <your-username>@192.168.86.38
    ```
    *(Replace `<your-username>` with your actual Ubuntu username).*
4.  Press **Enter**.
5.  It will ask which configuration file to update. Choose the first one (usually `C:\Users\dschm\.ssh\config`).
6.  Click **Connect** in the popup (bottom right) or find the host in the list and click the "Window" icon next to it.
7.  **Select OS:** Choose "Linux".
8.  **Password:** Enter your Ubuntu password.
    > **Note:** This is the password you created when you first installed Ubuntu on this VM. It is the same one you use for `sudo` commands.

### 3. The "Aha!" Moment
A new VS Code window will open. Look at the bottom left corner. It should say **"SSH: 192.168.86.38"**.
*   **File Explorer:** If you click "Open Folder", you are now looking at the *Server's* file system, not Windows!
*   **Terminal:** If you open the terminal (`Ctrl+~`), you are running commands *on the Server*.

---

## How to Deploy with this Setup

Now that you are connected, here is the easy workflow:

1.  **On your Windows VS Code (Local):**
    *   Open the `docker-compose.yml` file I made for you.
    *   Copy the contents (`Ctrl+A`, `Ctrl+C`).

2.  **On your Server VS Code (Remote):**
    *   Open the Terminal (`Ctrl+~`).
    *   Type: `mkdir home-server` (to make a folder).
    *   Type: `code home-server/docker-compose.yml` (this tells VS Code to create/open this file on the server).
    *   Paste the content (`Ctrl+V`).
    *   Save (`Ctrl+S`).

3.  **Run it:**
    *   In the Server Terminal, run: `docker compose up -d`

You have now successfully bridged the gap!
