# syntax=docker/dockerfile:1
FROM mcr.microsoft.com/devcontainers/base:ubuntu-22.04

# Enable privileged mode
USER root

SHELL ["/bin/bash", "-lc"]
ENV DEBIAN_FRONTEND=noninteractive
ENV DISPLAY=:1

# -----------------------------
# System & build dependencies
# -----------------------------
RUN apt-get update && apt-get install -y --no-install-recommends \
    git build-essential autoconf automake libtool m4 \
    tcl tcl-dev tk tk-dev libcairo2-dev \
    libx11-dev libxext-dev libxrender-dev libxpm-dev libxaw7-dev \
    libreadline-dev libncurses-dev flex bison gawk tcsh \
    python3 python3-pip pkg-config curl ca-certificates \
    xfce4 xfce4-terminal x11vnc xvfb novnc websockify supervisor dbus-x11 \
    libgoogle-glog-dev libgflags-dev gedit vim \
    clang lld libffi-dev libboost-system-dev libboost-filesystem-dev \
    libboost-python-dev libfl-dev zlib1g-dev graphviz xdot \
    libopenblas-dev libomp-dev libfftw3-dev \
 && apt-get clean && rm -rf /var/lib/apt/lists/*

# -----------------------------
# noVNC desktop (supervisor)
# -----------------------------
# With context "..", this file is available at .devcontainer/supervisord.conf
COPY supervisord.conf /etc/supervisor/conf.d/vnc.conf

EXPOSE 6080
CMD ["/usr/bin/supervisord", "-n"]
