#!/usr/bin/env bash
set -e

VNC_PASSWD_FILE="$HOME/.vnc/passwd"
VNC_XSTARTUP_FILE="$HOME/.vnc/xstartup"

# Create password if not already existing
if [ ! -f "$VNC_PASSWD_FILE" ]; then
  echo "vscode" | vncpasswd -f > "$VNC_PASSWD_FILE"
  chmod 600 "$VNC_PASSWD_FILE"
fi

# Create xstartup if missing
if [ ! -f "$VNC_XSTARTUP_FILE" ]; then
  cat << 'EOF' > "$VNC_XSTARTUP_FILE"
#!/bin/bash
xrdb $HOME/.Xresources
startxfce4 &
EOF
  chmod +x "$VNC_XSTARTUP_FILE"
fi

# Kill old session, ignore errors
vncserver -kill :1 || true

# Start new session
vncserver :1 -geometry 1440x900 -depth 24

echo "✅ VNC server started on :1 (port 5901)"
