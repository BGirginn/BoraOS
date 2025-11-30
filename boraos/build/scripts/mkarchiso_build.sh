#!/usr/bin/env bash
# BoraOS Build Script 7: Run mkarchiso
# Executes the main ArchISO build process

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

echo -e "${GREEN}=== BoraOS Build: Run mkarchiso ===${NC}"

cd "$BORAOS_DIR"

# Verify we have root privileges
if [ "$EUID" -ne 0 ]; then
    echo -e "${RED}ERROR: mkarchiso must be run as root${NC}"
    exit 1
fi

# Create output directory
mkdir -p build/out

echo "Starting mkarchiso build..."
echo "Profile: $(pwd)"
echo "Work directory: $(pwd)/build/work"
echo "Output directory: $(pwd)/build/out"
echo ""

# Run mkarchiso with verbose output
mkarchiso -v \
    -w "$(pwd)/build/work" \
    -o "$(pwd)/build/out" \
    "$(pwd)" \
    2>&1 | tee build/logs/mkarchiso.log

# Check if ISO was created
ISO_FILE=$(find build/out -name "*.iso" -type f | head -n 1)

if [ -z "$ISO_FILE" ]; then
    echo -e "${RED}ERROR: ISO file was not created!${NC}"
    echo "Check build/logs/mkarchiso.log for details"
    exit 1
fi

echo ""
echo -e "${GREEN}✓ mkarchiso build completed${NC}"
echo "ISO created: $ISO_FILE"
echo "Log: build/logs/mkarchiso.log"
