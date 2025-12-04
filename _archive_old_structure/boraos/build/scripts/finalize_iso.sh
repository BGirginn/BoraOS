#!/usr/bin/env bash
# BoraOS Build Script 8: Finalize ISO
# Renames ISO to standard name and sets deterministic timestamp

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

echo -e "${GREEN}=== BoraOS Build: Finalize ISO ===${NC}"

cd "$BORAOS_DIR"

# Find the ISO file
ISO_FILE=$(find build/out -name "*.iso" -type f | head -n 1)

if [ -z "$ISO_FILE" ]; then
    echo -e "${RED}ERROR: No ISO file found in build/out/${NC}"
    exit 1
fi

echo "Found ISO: $ISO_FILE"

# Target filename
TARGET_ISO="build/out/boraos-0.1-x86_64.iso"

# Rename if necessary
if [ "$ISO_FILE" != "$TARGET_ISO" ]; then
    echo "Renaming to: boraos-0.1-x86_64.iso"
    mv "$ISO_FILE" "$TARGET_ISO"
    echo -e "${GREEN}✓ ISO renamed${NC}"
else
    echo "ISO already has correct name"
fi

# Set deterministic timestamp
echo "Setting timestamp to $(date -d @${SOURCE_DATE_EPOCH} -u '+%Y-%m-%d %H:%M:%S UTC')..."
touch -d "@${SOURCE_DATE_EPOCH}" "$TARGET_ISO"
echo -e "${GREEN}✓ Timestamp set${NC}"

# Get final ISO size
ISO_SIZE=$(du -h "$TARGET_ISO" | cut -f1)

echo ""
echo -e "${GREEN}=== ISO Finalization Complete ===${NC}"
echo "Final ISO: $TARGET_ISO"
echo "Size: $ISO_SIZE"
echo "Timestamp: $(stat -c '%y' "$TARGET_ISO" 2>/dev/null || stat -f '%Sm' -t '%Y-%m-%d %H:%M:%S' "$TARGET_ISO")"
