#!/usr/bin/env bash
# BoraOS ARM64 - Generate Checksums Script

set -euo pipefail

echo "→ Generating checksums..."

cd build/out

# Generate SHA256 checksums for all ISO and IMG files
if ls *.iso 2>/dev/null || ls *.img 2>/dev/null; then
    sha256sum *.iso *.img 2>/dev/null > SHA256SUMS || true
    
    if [ -f SHA256SUMS ]; then
        echo "  ✓ SHA256SUMS created"
        echo ""
        echo "  Checksums:"
        cat SHA256SUMS
    else
        echo "  ⚠️  No checksums generated"
    fi
else
    echo "  ⚠️  No ISO or IMG files found"
fi

cd ../..

echo ""
echo "✓ Checksum generation completed"
echo ""
