#!/usr/bin/env bash
# BoraOS ARM - Sync Profile Files

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BUILD_DIR="$(dirname "$SCRIPT_DIR")"
PROFILE_DIR="$(dirname "$BUILD_DIR")"

echo "Syncing ARM64 profile files..."

# Verify required files exist
REQUIRED_FILES=(
    "profiledef.sh"
    "packages.aarch64"
    "pacman.conf"
)

for file in "${REQUIRED_FILES[@]}"; do
    if [ ! -f "${PROFILE_DIR}/${file}" ]; then
        echo "ERROR: Required file missing: ${file}"
        exit 1
    fi
    echo "  ✓ ${file}"
done

# Verify airootfs structure
if [ ! -d "${PROFILE_DIR}/airootfs" ]; then
    echo "ERROR: airootfs directory missing!"
    exit 1
fi
echo "  ✓ airootfs/"

# Verify efiboot structure
if [ ! -d "${PROFILE_DIR}/efiboot" ]; then
    echo "ERROR: efiboot directory missing!"
    exit 1
fi
echo "  ✓ efiboot/"

echo "Profile sync complete!"
