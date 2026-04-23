#!/bin/bash
# Run this on the internet-connected build machine (the .222 server or similar).
# It expects to be run from the parent directory that contains both
#   trex-java-sdk/
#   trex-stateless-gui/
# and that this file and Containerfile are somewhere accessible.
#
# Usage:
#   cd ~           # parent of trex-java-sdk/ and trex-stateless-gui/
#   bash trex-stateless-gui/podman/build-image.sh

set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
IMAGE_NAME="trex-gui"
IMAGE_TAG="latest"
OUTPUT_FILE="${SCRIPT_DIR}/trex-gui-image.tar.gz"

echo "=== Building Podman image: ${IMAGE_NAME}:${IMAGE_TAG} ==="
echo "    Build context : $(pwd)"
echo "    Containerfile : ${SCRIPT_DIR}/Containerfile"

podman build \
  -f "${SCRIPT_DIR}/Containerfile" \
  -t "${IMAGE_NAME}:${IMAGE_TAG}" \
  .

echo ""
echo "=== Saving image to ${OUTPUT_FILE} ==="
podman save "${IMAGE_NAME}:${IMAGE_TAG}" | gzip > "${OUTPUT_FILE}"

echo ""
echo "Done. Transfer ${OUTPUT_FILE} to each offline machine, then run:"
echo "  podman load < trex-gui-image.tar.gz"
echo "  bash run-trex-gui.sh"
