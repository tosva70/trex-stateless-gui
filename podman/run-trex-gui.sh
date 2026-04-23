#!/bin/bash
# Drop this script (and trex-gui-image.tar.gz) onto each offline target machine.
# After loading the image with "podman load < trex-gui-image.tar.gz", run this script.
#
# Requires: Podman, and an X11 display (DISPLAY must be set).

set -e

IMAGE="localhost/trex-gui:latest"

if [ -z "${DISPLAY}" ]; then
  echo "ERROR: DISPLAY is not set. Make sure an X11 server is running."
  exit 1
fi

# Allow the container's root user to connect to the local X server.
# (xhost must be available on the host; skip if you manage XAUTHORITY manually.)
if command -v xhost &>/dev/null; then
  xhost +local:root >/dev/null 2>&1 || true
fi

echo "Starting TRex GUI..."
podman run --rm \
  --name trex-gui \
  -e DISPLAY="${DISPLAY}" \
  -v /tmp/.X11-unix:/tmp/.X11-unix:ro \
  -v "${HOME}/.trex-gui:/root/.trex-gui" \
  "${IMAGE}"

# The -v ~/.trex-gui:/root/.trex-gui line persists saved connections across
# container runs. The directory is created automatically by Podman if absent.
