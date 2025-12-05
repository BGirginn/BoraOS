#!/usr/bin/env bash
# BoraOS ARM - Clean Previous Build

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BUILD_DIR="$(dirname "$SCRIPT_DIR")"

echo "Cleaning previous ARM64 build artifacts..."

# Clean work directory
if [ -d "${BUILD_DIR}/work" ]; then
    echo "Removing work directory..."
    rm -rf "${BUILD_DIR}/work"
fi

# Clean output directory (keep logs)
if [ -d "${BUILD_DIR}/out" ]; then
    echo "Cleaning output directory..."
    rm -f "${BUILD_DIR}/out"/*.iso
    rm -f "${BUILD_DIR}/out"/SHA256SUMS
fi

# Create fresh directories
mkdir -p "${BUILD_DIR}/work"
mkdir -p "${BUILD_DIR}/out"
mkdir -p "${BUILD_DIR}/logs"

echo "Clean complete!"
