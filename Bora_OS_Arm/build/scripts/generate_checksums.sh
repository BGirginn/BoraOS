#!/usr/bin/env bash
# BoraOS ARM - Generate Checksums

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BUILD_DIR="$(dirname "$SCRIPT_DIR")"
OUT_DIR="${BUILD_DIR}/out"

echo "Generating checksums..."

cd "$OUT_DIR"

# Generate SHA256 checksums
if [ -f "boraos-0.1-aarch64.iso" ]; then
    sha256sum boraos-0.1-aarch64.iso > SHA256SUMS
    echo "SHA256SUMS generated:"
    cat SHA256SUMS
else
    echo "ERROR: ISO file not found!"
    exit 1
fi

echo ""
echo "Checksums generated successfully!"
