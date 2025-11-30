#!/usr/bin/env bash
# BoraOS Master Build Script
# Executes all build steps in order to create reproducible ISO

set -euo pipefail

# Color output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Get script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BORAOS_DIR="$(dirname "$SCRIPT_DIR")"

echo -e "${BLUE}╔════════════════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║${NC}  ${GREEN}BoraOS 0.1 - Reproducible ISO Build Pipeline${NC}      ${BLUE}║${NC}"
echo -e "${BLUE}╚════════════════════════════════════════════════════════╝${NC}"
echo ""

# Check if running as root
if [ "$EUID" -ne 0 ]; then
    echo -e "${RED}ERROR: This script must be run as root${NC}"
    echo "Run with: sudo ./build.sh"
    exit 1
fi

# Change to BoraOS directory
cd "$BORAOS_DIR"

# Build steps
STEPS=(
    "prepare_environment.sh:Prepare Build Environment"
    "clean_previous_build.sh:Clean Previous Build"
    "sync_profile.sh:Sync Profile Files"
    "build_squashfs.sh:Build SquashFS"
    "mkarchiso_build.sh:Run mkarchiso"
    "finalize_iso.sh:Finalize ISO"
    "generate_checksums.sh:Generate Checksums"
)

TOTAL_STEPS=${#STEPS[@]}
CURRENT_STEP=0

# Execute each step
for step in "${STEPS[@]}"; do
    CURRENT_STEP=$((CURRENT_STEP + 1))
    SCRIPT="${step%%:*}"
    DESCRIPTION="${step##*:}"
    
    echo ""
    echo -e "${BLUE}═══════════════════════════════════════════════════════${NC}"
    echo -e "${BLUE}Step $CURRENT_STEP/$TOTAL_STEPS: ${DESCRIPTION}${NC}"
    echo -e "${BLUE}═══════════════════════════════════════════════════════${NC}"
    echo ""
    
    if [ ! -f "build/scripts/$SCRIPT" ]; then
        echo -e "${RED}ERROR: Script build/scripts/$SCRIPT not found!${NC}"
        exit 1
    fi
    
    if ! bash "build/scripts/$SCRIPT"; then
        echo ""
        echo -e "${RED}╔════════════════════════════════════════╗${NC}"
        echo -e "${RED}║  BUILD FAILED at step $CURRENT_STEP/$TOTAL_STEPS        ║${NC}"
        echo -e "${RED}╚════════════════════════════════════════╝${NC}"
        echo ""
        echo "Check logs in build/logs/ for details"
        exit 1
    fi
done

# Success!
echo ""
echo -e "${GREEN}╔════════════════════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║  BUILD COMPLETED SUCCESSFULLY!                         ║${NC}"
echo -e "${GREEN}╚════════════════════════════════════════════════════════╝${NC}"
echo ""
echo -e "${GREEN}ISO Location:${NC} build/out/boraos-0.1-x86_64.iso"
echo -e "${GREEN}Checksum:${NC} build/out/SHA256SUMS"
echo ""

# Display ISO info
if [ -f "build/out/boraos-0.1-x86_64.iso" ]; then
    ISO_SIZE=$(du -h build/out/boraos-0.1-x86_64.iso | cut -f1)
    echo "ISO Size: $ISO_SIZE"
    echo ""
    echo "SHA256:"
    cat build/out/SHA256SUMS
    echo ""
fi

echo -e "${YELLOW}Next steps:${NC}"
echo "1. Verify ISO: cd build/out && sha256sum -c SHA256SUMS"
echo "2. Test in VM or write to USB drive"
echo "3. Boot and test installation"
echo ""
echo -e "${GREEN}Happy building! 🚀${NC}"
