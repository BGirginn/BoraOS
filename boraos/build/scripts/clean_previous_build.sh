#!/usr/bin/env bash
# BoraOS Build Script 2: Clean Previous Build
# Removes build artifacts while preserving source files

set -euo pipefail

# Source reproducibility environment
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BORAOS_DIR="$(dirname "$(dirname "$SCRIPT_DIR")")"

if [ -f "$BORAOS_DIR/build/environment.sh" ]; then
    source "$BORAOS_DIR/build/environment.sh"
fi

# Color output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${GREEN}=== BoraOS Build: Clean Previous Build ===${NC}"

cd "$BORAOS_DIR"

# Remove build artifacts
echo "Removing previous build artifacts..."

if [ -d "build/work" ]; then
    echo "  Removing build/work/..."
    rm -rf build/work/*
    echo -e "${GREEN}  ✓ Removed work directory${NC}"
else
    echo -e "${YELLOW}  - work directory does not exist${NC}"
fi

if [ -d "build/out" ]; then
    echo "  Removing build/out/..."
    rm -rf build/out/*
    echo -e "${GREEN}  ✓ Removed output directory${NC}"
else
    echo -e "${YELLOW}  - out directory does not exist${NC}"
fi

if [ -d "build/logs" ]; then
    echo "  Clearing build/logs/..."
    rm -f build/logs/*
    echo -e "${GREEN}  ✓ Cleared log files${NC}"
else
    echo -e "${YELLOW}  - logs directory does not exist${NC}"
fi

# Recreate directories
echo "Recreating build directories..."
mkdir -p build/{work,out,logs}
echo -e "${GREEN}✓ Build directories ready${NC}"

# Verify critical source files are intact
echo "Verifying source files..."
CRITICAL_FILES=("profiledef.sh" "pacman.conf" "packages.x86_64")
for file in "${CRITICAL_FILES[@]}"; do
    if [ ! -f "$file" ]; then
        echo -e "${RED}ERROR: Critical file '$file' is missing!${NC}"
        exit 1
    fi
done

if [ ! -d "airootfs" ]; then
    echo -e "${RED}ERROR: airootfs/ directory is missing!${NC}"
    exit 1
fi

if [ ! -d "prompts" ]; then
    echo -e "${YELLOW}WARNING: prompts/ directory is missing${NC}"
fi

echo -e "${GREEN}✓ All source files intact${NC}"

echo ""
echo -e "${GREEN}=== Clean Complete ===${NC}"
echo "Build workspace is clean and ready"
