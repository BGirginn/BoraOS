#!/usr/bin/env bash
# BoraOS Build Script 3: Sync Profile
# Synchronizes profile files with deterministic timestamps

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

echo -e "${GREEN}=== BoraOS Build: Sync Profile ===${NC}"

cd "$BORAOS_DIR"

# Verify required files
echo "Verifying profile files..."
if [ ! -f "profiledef.sh" ]; then
    echo -e "${RED}ERROR: profiledef.sh not found${NC}"
    exit 1
fi

if [ ! -f "pacman.conf" ]; then
    echo -e "${RED}ERROR: pacman.conf not found${NC}"
    exit 1
fi

if [ ! -f "packages.x86_64" ]; then
    echo -e "${RED}ERROR: packages.x86_64 not found${NC}"
    exit 1
fi

if [ ! -d "airootfs" ]; then
    echo -e "${RED}ERROR: airootfs/ directory not found${NC}"
    exit 1
fi

echo -e "${GREEN}✓ All profile files present${NC}"

# Create profile staging directory
echo "Creating profile staging directory..."
mkdir -p build/work/profile
echo -e "${GREEN}✓ Created staging directory${NC}"

# Copy profile files with deterministic ordering
echo "Copying profile files..."

# Copy root files
cp -v profiledef.sh build/work/profile/
cp -v pacman.conf build/work/profile/
cp -v packages.x86_64 build/work/profile/

# Copy airootfs recursively
echo "Copying airootfs/..."
rsync -a --delete airootfs/ build/work/profile/airootfs/

echo -e "${GREEN}✓ Profile files copied${NC}"

# Set all timestamps to SOURCE_DATE_EPOCH for reproducibility
echo "Setting deterministic timestamps..."
find build/work/profile -exec touch -h -d "@${SOURCE_DATE_EPOCH}" {} +
echo -e "${GREEN}✓ Timestamps set to $(date -d @${SOURCE_DATE_EPOCH} -u '+%Y-%m-%d %H:%M:%S UTC')${NC}"

# Create file list for deterministic squashfs ordering
echo "Generating file list..."
(cd build/work/profile/airootfs && find . -type f -o -type l | LC_ALL=C sort) > build/work/filelist.txt
echo -e "${GREEN}✓ File list generated ($(wc -l < build/work/filelist.txt) entries)${NC}"

# Verify staged profile
echo "Verifying staged profile..."
STAGED_FILES=("build/work/profile/profiledef.sh" "build/work/profile/pacman.conf" "build/work/profile/packages.x86_64")
for file in "${STAGED_FILES[@]}"; do
    if [ ! -f "$file" ]; then
        echo -e "${RED}ERROR: Staged file '$file' is missing!${NC}"
        exit 1
    fi
done

if [ ! -d "build/work/profile/airootfs" ]; then
    echo -e "${RED}ERROR: Staged airootfs/ directory is missing!${NC}"
    exit 1
fi

echo -e "${GREEN}✓ Staged profile verified${NC}"

echo ""
echo -e "${GREEN}=== Profile Sync Complete ===${NC}"
echo "Profile staged at: build/work/profile/"
echo "File list: build/work/filelist.txt"
