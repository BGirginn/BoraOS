#!/usr/bin/env bash
# BoraOS Build Script 9: Generate Checksums
# Creates SHA256 checksums with deterministic timestamps

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

echo -e "${GREEN}=== BoraOS Build: Generate Checksums ===${NC}"

cd "$BORAOS_DIR/build/out"

# Check if ISO exists
if [ ! -f "boraos-0.1-x86_64.iso" ]; then
    echo -e "${RED}ERROR: boraos-0.1-x86_64.iso not found${NC}"
    exit 1
fi

echo "Generating SHA256 checksum..."
sha256sum boraos-0.1-x86_64.iso > SHA256SUMS

# Set deterministic timestamp on checksum file
touch -d "@${SOURCE_DATE_EPOCH}" SHA256SUMS

echo -e "${GREEN}✓ SHA256SUMS created${NC}"

# Display checksum
cat SHA256SUMS

echo ""
echo -e "${GREEN}=== Checksum Generation Complete ===${NC}"
echo "Checksum file: build/out/SHA256SUMS"
echo ""
echo "Verify ISO with:"
echo "  cd build/out && sha256sum -c SHA256SUMS"
