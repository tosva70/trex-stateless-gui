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

# Grant local X11 access and pass the auth cookie into the container.
if command -v xhost &>/dev/null; then
  xhost +local: >/dev/null 2>&1 || true
fi

XAUTH_FILE="${XAUTHORITY:-${HOME}/.Xauthority}"

mkdir -p "${HOME}/.trex-gui"
echo "Starting TRex GUI..."
podman run --rm \
  --name trex-gui \
  --security-opt label=disable \
  -e DISPLAY="${DISPLAY}" \
  -e XAUTHORITY=/tmp/.Xauthority \
  -v /tmp/.X11-unix:/tmp/.X11-unix:ro \
  -v "${XAUTH_FILE}:/tmp/.Xauthority:ro" \
  -v "${HOME}/.trex-gui:/root/.trex-gui" \
  "${IMAGE}"
