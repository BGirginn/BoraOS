#!/usr/bin/env bash
#
# BoraOS Post-Installation Security Hardening Script
# Run this IMMEDIATELY after installing BoraOS to disk
#
# Usage: sudo /usr/local/bin/boraos-post-install-security.sh
#

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Header
echo -e "${BLUE}╔════════════════════════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║        BoraOS Post-Installation Security Hardening           ║${NC}"
echo -e "${BLUE}╚════════════════════════════════════════════════════════════════╝${NC}"
echo ""

# Check if running as root
if [ "$EUID" -ne 0 ]; then 
    echo -e "${RED}✗ Error: This script must be run as root${NC}"
    echo "  Usage: sudo $0"
    exit 1
fi

echo -e "${YELLOW}⚠ WARNING: This script will harden your system security.${NC}"
echo -e "${YELLOW}  - Remove passwordless sudo${NC}"
echo -e "${YELLOW}  - Enforce password requirements${NC}"
echo -e "${YELLOW}  - Enable firewall${NC}"
echo ""
read -p "Continue? (y/N): " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo -e "${YELLOW}Cancelled by user.${NC}"
    exit 0
fi

echo ""
echo -e "${BLUE}[1/5]${NC} Checking system..."

# Get the current non-root user
ACTUAL_USER="${SUDO_USER:-$(logname 2>/dev/null || echo '')}"
if [ -z "$ACTUAL_USER" ] || [ "$ACTUAL_USER" = "root" ]; then
    echo -e "${YELLOW}⚠ Could not determine non-root user.${NC}"
    read -p "Enter username to configure: " ACTUAL_USER
fi

echo -e "${GREEN}✓${NC} Target user: $ACTUAL_USER"

# Step 1: Remove NOPASSWD sudo
echo ""
echo -e "${BLUE}[2/5]${NC} Removing passwordless sudo..."

if [ -f /etc/sudoers.d/g_wheel ]; then
    # Backup first
    cp /etc/sudoers.d/g_wheel /etc/sudoers.d/g_wheel.backup.$(date +%Y%m%d)
    
    # Option 1: Completely remove (safest)
    rm /etc/sudoers.d/g_wheel
    echo -e "${GREEN}✓${NC} Removed /etc/sudoers.d/g_wheel"
    
    # Verify wheel group still has sudo with password
    if ! grep -q "^%wheel ALL=(ALL:ALL) ALL" /etc/sudoers; then
        echo "%wheel ALL=(ALL:ALL) ALL" >> /etc/sudoers
        echo -e "${GREEN}✓${NC} Ensured wheel group has password-required sudo"
    fi
else
    echo -e "${GREEN}✓${NC} NOPASSWD sudo already removed"
fi

# Step 2: Enforce user password
echo ""
echo -e "${BLUE}[3/5]${NC} Checking user password..."

# Check if user has password set
if passwd -S "$ACTUAL_USER" 2>/dev/null | grep -q ' NP '; then
    echo -e "${YELLOW}⚠ User $ACTUAL_USER has no password set${NC}"
    echo "Setting password for $ACTUAL_USER..."
    passwd "$ACTUAL_USER"
    echo -e "${GREEN}✓${NC} Password set for $ACTUAL_USER"
elif passwd -S "$ACTUAL_USER" 2>/dev/null | grep -q ' L '; then
    echo -e "${YELLOW}⚠ User $ACTUAL_USER account is locked${NC}"
    passwd -u "$ACTUAL_USER"
    passwd "$ACTUAL_USER"
    echo -e "${GREEN}✓${NC} Account unlocked and password set"
else
    echo -e "${GREEN}✓${NC} User $ACTUAL_USER already has password"
fi

# Step 3: Set root password (optional but recommended)
echo ""
echo -e "${BLUE}[4/5]${NC} Root password configuration..."

if passwd -S root 2>/dev/null | grep -q ' NP '; then
    echo -e "${YELLOW}⚠ Root has no password${NC}"
    read -p "Set root password? (recommended) (y/N): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        passwd root
        echo -e "${GREEN}✓${NC} Root password set"
    else
        echo -e "${YELLOW}⚠ Root password not set (not recommended)${NC}"
    fi
else
    echo -e "${GREEN}✓${NC} Root already has password"
fi

# Step 4: Firewall configuration
echo ""
echo -e "${BLUE}[5/5]${NC} Firewall configuration..."

if ! command -v ufw &> /dev/null; then
    read -p "Install and enable ufw firewall? (recommended) (y/N): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        pacman -S --noconfirm ufw
        systemctl enable --now ufw
        ufw --force enable
        ufw default deny incoming
        ufw default allow outgoing
        
        # Allow common services (optional)
        read -p "Allow SSH (port 22)? (y/N): " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            ufw allow ssh
            echo -e "${GREEN}✓${NC} SSH allowed through firewall"
        fi
        
        echo -e "${GREEN}✓${NC} Firewall enabled and configured"
    else
        echo -e "${YELLOW}⚠ Firewall not installed${NC}"
    fi
else
    if ! systemctl is-active --quiet ufw; then
        systemctl enable --now ufw
        ufw --force enable
        ufw default deny incoming
        ufw default allow outgoing
        echo -e "${GREEN}✓${NC} Firewall enabled"
    else
        echo -e "${GREEN}✓${NC} Firewall already active"
    fi
fi

# Summary
echo ""
echo -e "${GREEN}╔════════════════════════════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║              Security Hardening Complete!                     ║${NC}"
echo -e "${GREEN}╚════════════════════════════════════════════════════════════════╝${NC}"
echo ""
echo -e "${GREEN}✓${NC} Passwordless sudo removed"
echo -e "${GREEN}✓${NC} User password enforced"
echo -e "${GREEN}✓${NC} System secured"
echo ""
echo -e "${BLUE}Next steps:${NC}"
echo "  1. Test sudo: ${YELLOW}sudo whoami${NC} (should ask for password)"
echo "  2. Review firewall: ${YELLOW}sudo ufw status${NC}"
echo "  3. Keep system updated: ${YELLOW}sudo pacman -Syu${NC}"
echo ""
echo -e "${YELLOW}Important: Logout and login again for changes to take full effect.${NC}"
echo ""

# Create marker file to prevent re-running
touch /var/lib/boraos-security-hardened

exit 0
