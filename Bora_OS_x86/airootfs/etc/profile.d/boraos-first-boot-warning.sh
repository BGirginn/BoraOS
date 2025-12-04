#!/usr/bin/env bash
#
# BoraOS First Boot Notice
# Displays security warning on first login after installation
#

MARKER_FILE="/var/lib/boraos-security-hardened"
WARNING_SHOWN="/var/lib/boraos-first-boot-warning-shown"

# Only show if system is installed (not live environment)
if [ -f /run/archiso/bootmnt/.arch/pkglist.x86_64.txt ]; then
    # Live environment, don't show warning
    exit 0
fi

# Only show once
if [ -f "$WARNING_SHOWN" ]; then
    exit 0
fi

# Show warning if security not hardened
if [ ! -f "$MARKER_FILE" ]; then
    cat << 'EOF'

╔════════════════════════════════════════════════════════════════╗
║                      ⚠ SECURITY NOTICE ⚠                      ║
╚════════════════════════════════════════════════════════════════╝

This is a fresh BoraOS installation. Your system currently has:
  ⚠ Passwordless sudo enabled (from live environment)
  ⚠ Potential security vulnerabilities

IMPORTANT: Run the security hardening script NOW:

  sudo /usr/local/bin/boraos-post-install-security.sh

This will:
  ✓ Remove passwordless sudo
  ✓ Enforce password requirements
  ✓ Enable firewall (optional)

For more information, see:
  /usr/share/doc/boraos/SECURITY.md

Press ENTER to continue...
EOF
    read -r
    
    # Mark warning as shown
    touch "$WARNING_SHOWN"
fi
