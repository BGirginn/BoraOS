#!/usr/bin/env bash
# BoraOS ARM - Finalize Output

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BUILD_DIR="$(dirname "$SCRIPT_DIR")"
OUT_DIR="${BUILD_DIR}/out"

echo "Finalizing ARM64 output..."

# Find the ISO file
ISO_FILE=$(ls -1 "${OUT_DIR}"/boraos-*.iso 2>/dev/null | head -1)

if [ -z "$ISO_FILE" ]; then
    echo "ERROR: No ISO file found!"
    exit 1
fi

# Get ISO info
ISO_NAME=$(basename "$ISO_FILE")
ISO_SIZE=$(du -h "$ISO_FILE" | cut -f1)

echo "ISO File: $ISO_NAME"
echo "ISO Size: $ISO_SIZE"

# Rename to standard format if needed
EXPECTED_NAME="boraos-0.1-aarch64.iso"
if [ "$ISO_NAME" != "$EXPECTED_NAME" ]; then
    echo "Renaming to: $EXPECTED_NAME"
    mv "$ISO_FILE" "${OUT_DIR}/${EXPECTED_NAME}"
fi

echo "Finalization complete!"
