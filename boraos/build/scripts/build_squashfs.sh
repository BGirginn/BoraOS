#!/usr/bin/env bash
# BoraOS Build Script 4: Build SquashFS
# Creates reproducible squashfs filesystem

set -euo pipefail

# Source reproducibility environment
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BORAOS_DIR="$(dirname "$(dirname "$SCRIPT_DIR")")"

if [ ! -f "$BORAOS_DIR/build/environment.sh" ]; then
    echo "ERROR: Run prepare_environment.sh first"
    exit 1
fi

source "$BORAOS_DIR/build/environment.sh"

# Color output
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m'

echo -e "${GREEN}=== BoraOS Build: Build SquashFS ===${NC}"

cd "$BORAOS_DIR"

# Verify airootfs exists
if [ ! -d "build/work/profile/airootfs" ]; then
    echo -e "${RED}ERROR: build/work/profile/airootfs not found. Run sync_profile.sh first.${NC}"
    exit 1
fi

# Verify filelist exists
if [ ! -f "build/work/filelist.txt" ]; then
    echo -e "${RED}ERROR: build/work/filelist.txt not found. Run sync_profile.sh first.${NC}"
    exit 1
fi

# Create squashfs output directory
mkdir -p build/work/iso/arch/x86_64/

echo "Building reproducible squashfs..."
echo "Source: build/work/profile/airootfs/"
echo "Output: build/work/iso/arch/x86_64/airootfs.sfs"
echo "Compression: zstd level 6"
echo ""

# Build squashfs with exact reproducible parameters
mksquashfs build/work/profile/airootfs/ \
    build/work/iso/arch/x86_64/airootfs.sfs \
    -comp zstd \
    -Xcompression-level 6 \
    -noappend \
    -all-root \
    -sort build/work/filelist.txt \
    -no-progress \
    -root-mode 755 \
    -mkfs-time "${SOURCE_DATE_EPOCH}" \
    2>&1 | tee build/logs/squashfs.log

if [ ! -f "build/work/iso/arch/x86_64/airootfs.sfs" ]; then
    echo -e "${RED}ERROR: SquashFS build failed!${NC}"
    exit 1
fi

# Get squashfs size
SFS_SIZE=$(du -h build/work/iso/arch/x86_64/airootfs.sfs | cut -f1)

echo ""
echo -e "${GREEN}✓ SquashFS built successfully${NC}"
echo "Size: $SFS_SIZE"
echo "Location: build/work/iso/arch/x86_64/airootfs.sfs"
echo "Log: build/logs/squashfs.log"
