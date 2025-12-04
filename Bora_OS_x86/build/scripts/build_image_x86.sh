#!/usr/bin/env bash
# BoraOS x86_64 - Build ISO Script

set -euo pipefail

echo "→ Building x86_64 ISO..."

# Source reproducibility environment
source build/environment.sh

# Set deterministic build environment
export SOURCE_DATE_EPOCH
export LANG=C
export LC_ALL=C
export TZ=UTC

# Log file
LOG_FILE="build/logs/mkarchiso_x86.log"

echo "  Running mkarchiso for x86_64..."
echo "  Log: $LOG_FILE"

# Build ISO using mkarchiso
echo "  Building ISO for x86_64..."

# Run mkarchiso
if yes | mkarchiso -v -w build/work -o build/out build/work/profile > "$LOG_FILE" 2>&1; then
    echo "  ✓ ISO build completed"
else
    echo ""
    echo "ERROR: mkarchiso failed!"
    echo "Check log: $LOG_FILE"
    tail -20 "$LOG_FILE"
    exit 1
fi

echo ""
echo "✓ x86_64 ISO build completed"
echo ""
