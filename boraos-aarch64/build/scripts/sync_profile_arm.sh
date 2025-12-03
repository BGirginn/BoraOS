#!/usr/bin/env bash
# BoraOS ARM64 - Sync Profile Files Script

set -euo pipefail

echo "→ Syncing ARM64 profile files..."

# Source reproducibility environment
source build/environment.sh

# Set umask for consistent permissions
umask 0022

# Create work profile directory
WORK_PROFILE="build/work/profile"
mkdir -p "$WORK_PROFILE"

# Copy profile files with deterministic timestamps
echo "  Copying profile files..."

cp -r profiledef.sh "$WORK_PROFILE/"
cp -r pacman.conf "$WORK_PROFILE/"
cp -r packages.aarch64 "$WORK_PROFILE/packages.aarch64"

# Copy airootfs if it exists
if [ -d "airootfs" ]; then
    cp -r airootfs "$WORK_PROFILE/"
    echo "  ✓ Copied airootfs overlay"
fi

# Copy grub directory if it exists (required for uefi.grub boot mode)
if [ -d "grub" ]; then
    cp -r grub "$WORK_PROFILE/"
    echo "  ✓ Copied grub configuration"
fi

# Set deterministic timestamps on all files
echo "  Setting deterministic timestamps..."
find "$WORK_PROFILE" -exec touch -d "@${SOURCE_DATE_EPOCH}" {} +

echo "  ✓ Profile files synced to build/work/profile"
echo ""
echo "✓ ARM64 profile sync completed"
echo ""
