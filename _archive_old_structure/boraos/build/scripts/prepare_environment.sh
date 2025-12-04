#!/usr/bin/env bash
# BoraOS Build Script 1: Prepare Environment
# Verifies system requirements and sets up reproducible build environment

set -euo pipefail

# Color output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${GREEN}=== BoraOS Build: Prepare Environment ===${NC}"

# 1. Verify running on Arch Linux
echo "Checking Linux distribution..."
if [ ! -f /etc/arch-release ]; then
    echo -e "${RED}ERROR: This script must run on Arch Linux${NC}"
    exit 1
fi
echo -e "${GREEN}✓ Running on Arch Linux${NC}"

# 2. Verify archiso is installed
echo "Checking archiso installation..."
if ! pacman -Qi archiso &>/dev/null; then
    echo -e "${RED}ERROR: archiso is not installed${NC}"
    echo "Install with: sudo pacman -S archiso"
    exit 1
fi
echo -e "${GREEN}✓ archiso is installed${NC}"

# 3. Verify root privileges
echo "Checking root privileges..."
if [ "$EUID" -ne 0 ]; then
    echo -e "${RED}ERROR: This script must be run as root${NC}"
    echo "Run with: sudo ./prepare_environment.sh"
    exit 1
fi
echo -e "${GREEN}✓ Running as root${NC}"

# 4. Verify required tools
echo "Checking required tools..."
REQUIRED_TOOLS=("git" "make" "gcc" "mksquashfs" "fakeroot" "mkarchiso")
for tool in "${REQUIRED_TOOLS[@]}"; do
    if ! command -v "$tool" &>/dev/null; then
        echo -e "${RED}ERROR: Required tool '$tool' not found${NC}"
        echo "Install with: sudo pacman -S base-devel archiso squashfs-tools fakeroot"
        exit 1
    fi
done
echo -e "${GREEN}✓ All required tools installed${NC}"

# 5. Verify required directories exist
echo "Checking project structure..."
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BORAOS_DIR="$(dirname "$(dirname "$SCRIPT_DIR")")"

cd "$BORAOS_DIR"

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

echo -e "${GREEN}✓ Project structure valid${NC}"

# 6. Create build directories if they don't exist
echo "Creating build directories..."
mkdir -p build/{scripts,logs,work,out}
echo -e "${GREEN}✓ Build directories created${NC}"

# 7. Export reproducibility variables
echo "Setting reproducibility variables..."
export SOURCE_DATE_EPOCH=1704067200   # Jan 1, 2024 00:00 UTC
export LANG=C
export LC_ALL=C
export TZ=UTC
export UMASK=0022

# Save to environment file for other scripts
cat > build/environment.sh << 'EOF'
#!/usr/bin/env bash
# Reproducibility environment variables
export SOURCE_DATE_EPOCH=1704067200   # Jan 1, 2024 00:00 UTC
export LANG=C
export LC_ALL=C
export TZ=UTC
export UMASK=0022
umask 0022
EOF

chmod +x build/environment.sh
echo -e "${GREEN}✓ Reproducibility variables set${NC}"

# 8. Initialize pacman keys
echo "Initializing pacman keyring..."
if [ ! -d /etc/pacman.d/gnupg ]; then
    pacman-key --init
    pacman-key --populate archlinux
    echo -e "${GREEN}✓ Pacman keyring initialized${NC}"
else
    echo -e "${YELLOW}✓ Pacman keyring already initialized${NC}"
fi

# 9. Check system resources
echo "Checking system resources..."
TOTAL_RAM=$(free -g | awk '/^Mem:/{print $2}')
if [ "$TOTAL_RAM" -lt 4 ]; then
    echo -e "${YELLOW}WARNING: System has less than 4GB RAM (${TOTAL_RAM}GB available)${NC}"
    echo "Build may be slow or fail"
else
    echo -e "${GREEN}✓ Sufficient RAM: ${TOTAL_RAM}GB${NC}"
fi

AVAILABLE_SPACE=$(df -BG . | awk 'NR==2 {print $4}' | sed 's/G//')
if [ "$AVAILABLE_SPACE" -lt 10 ]; then
    echo -e "${RED}ERROR: Insufficient disk space (${AVAILABLE_SPACE}GB available, 10GB required)${NC}"
    exit 1
fi
echo -e "${GREEN}✓ Sufficient disk space: ${AVAILABLE_SPACE}GB${NC}"

# 10. Summary
echo ""
echo -e "${GREEN}=== Environment Preparation Complete ===${NC}"
echo "Build directory: $BORAOS_DIR/build/"
echo "Work directory: $BORAOS_DIR/build/work/"
echo "Output directory: $BORAOS_DIR/build/out/"
echo "Source date epoch: $(date -d @$SOURCE_DATE_EPOCH -u)"
echo ""
echo -e "${GREEN}Ready to build BoraOS ISO${NC}"
