# How to Reset Your Ubuntu Password

Since you have physical access to the server (via Proxmox), you can break in and change the lock.

## Method 1: The Easy Way (If you know the Root password)
Sometimes you set a password for `root` that matches your Proxmox password.

1.  Open the **Proxmox Console** for your Ubuntu VM.
2.  At the `login:` prompt, type `root` and press Enter.
3.  Try your Proxmox password.
4.  **If it works:**
    *   Type: `passwd <your-username>` (e.g., `passwd dschm`)
    *   Enter the new password twice.
    *   Done!

## Method 2: The "Hacker" Way (If you are totally locked out)
This forces the server to let you in as root without a password.

1.  **Reboot the VM:** In Proxmox, click **Reboot** (or Stop then Start).
2.  **Catch the Boot Menu:** As soon as the "Tianocore" or BIOS logo appears, hold down **`Shift`** (or tap `Esc` repeatedly). You want to see a menu that says "Ubuntu", "Advanced options for Ubuntu", etc.
3.  **Edit Mode:**
    *   Select the top line ("Ubuntu").
    *   Press **`e`** on your keyboard (for edit).
4.  **Modify the Code:**
    *   Use arrow keys to find the line starting with `linux` (it ends with `... ro quiet splash $vt_handoff`).
    *   Go to the end of that line.
    *   Add this text at the very end: `rw init=/bin/bash`
    *   (Make sure there is a space before `rw`).
5.  **Boot:** Press **`F10`** or `Ctrl+X`.
6.  **The Shell:** You will drop into a black screen with a cursor. You are now Root.
7.  **Change Password:**
    *   Type: `passwd <your-username>` (e.g., `passwd dschm`)
    *   Type your new password.
    *   Type it again.
8.  **Reboot:**
    *   Type: `exec /sbin/init` (or just hard reset the VM from Proxmox).

You should now be able to log in with the new password!
