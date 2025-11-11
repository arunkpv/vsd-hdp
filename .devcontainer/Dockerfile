# syntax=docker/dockerfile:1
FROM mcr.microsoft.com/devcontainers/base:ubuntu-22.04

ENV DEBIAN_FRONTEND=noninteractive

# Install XFCE, VNC, supervisor, noVNC, Python (for websockify)
RUN apt-get update && \
    apt-get install -y xfce4 xfce4-goodies tigervnc-standalone-server \
    dbus-x11 x11-xserver-utils supervisor git python3 python3-websockify novnc \
    wget gnupg && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# --- OpenGL Software Rendering Fix ---
RUN apt-get update && \
    apt-get install -y mesa-utils libgl1-mesa-dri libgl1-mesa-glx libglu1-mesa libosmesa6 && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Force software rendering (no GPU access in Codespaces)
ENV LIBGL_ALWAYS_SOFTWARE=1
ENV MESA_LOADER_DRIVER_OVERRIDE=llvmpipe

# Copy startup scripts and supervisor config
COPY setup-vnc.sh /usr/local/bin/setup-vnc.sh
COPY start-novnc.sh /usr/local/bin/start-novnc.sh
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

RUN chmod +x /usr/local/bin/setup-vnc.sh /usr/local/bin/start-novnc.sh

# Expose both VNC (5901) and noVNC (6080) ports
EXPOSE 5901 6080

CMD ["/usr/bin/supervisord", "-n"]
