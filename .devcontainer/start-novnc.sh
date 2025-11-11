#!/usr/bin/env bash
set -e

NOVNC_DIR="/usr/share/novnc"
WEBSOCKIFY_BIN="/usr/share/novnc/utils/websockify"

echo "Starting noVNC on port 6080..."
${WEBSOCKIFY_BIN} --web ${NOVNC_DIR} 6080 localhost:5901
