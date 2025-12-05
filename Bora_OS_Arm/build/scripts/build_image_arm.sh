#!/usr/bin/env bash
# BoraOS ARM - Build ISO Image

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BUILD_DIR="$(dirname "$SCRIPT_DIR")"
PROFILE_DIR="$(dirname "$BUILD_DIR")"

echo "Building ARM64 ISO image..."

# Create work and output directories
WORK_DIR="${BUILD_DIR}/work"
OUT_DIR="${BUILD_DIR}/out"
LOG_FILE="${BUILD_DIR}/logs/build-$(date +%Y%m%d-%H%M%S).log"

mkdir -p "$WORK_DIR" "$OUT_DIR" "${BUILD_DIR}/logs"

echo "Work directory: $WORK_DIR"
echo "Output directory: $OUT_DIR"
echo "Log file: $LOG_FILE"
echo ""

# Run mkarchiso
echo "Running mkarchiso..."
echo "This may take a while depending on network speed and package count..."
echo ""

mkarchiso -v -w "$WORK_DIR" -o "$OUT_DIR" "$PROFILE_DIR" 2>&1 | tee "$LOG_FILE"

# Verify ISO was created
ISO_FILE=$(ls -1 "${OUT_DIR}"/boraos-*.iso 2>/dev/null | head -1)
if [ -z "$ISO_FILE" ]; then
    echo "ERROR: ISO file not found in output directory!"
    exit 1
fi

echo ""
echo "ISO created: $ISO_FILE"
echo "Build log: $LOG_FILE"
