#!/usr/bin/env bash
# BoraOS 0.1 - Automated Live System Setup Script
# This script is executed automatically during the first boot of the live environment

set -e

# Configure localization
echo "Setting up locale..."
echo "en_US.UTF-8 UTF-8" > /etc/locale.gen
locale-gen
echo "LANG=en_US.UTF-8" > /etc/locale.conf

# Set timezone to UTC for live environment
echo "Setting timezone..."
ln -sf /usr/share/zoneinfo/UTC /etc/localtime

# Set hostname
echo "Setting hostname..."
echo "boraos-live" > /etc/hostname

# Configure hosts file
cat > /etc/hosts << EOF
127.0.0.1   localhost
::1         localhost
127.0.1.1   boraos-live.localdomain boraos-live
EOF

# Enable core services
echo "Enabling system services..."
systemctl enable NetworkManager.service
systemctl enable bluetooth.service
systemctl enable sddm.service
systemctl enable systemd-timesyncd.service

# Set up console keymap
echo "KEYMAP=trq" > /etc/vconsole.conf

# Create welcome message
cat > /etc/motd << 'EOF'
╔═══════════════════════════════════════════════════════════════╗
║                                                               ║
║   ██████╗  ██████╗ ██████╗  █████╗  ██████╗ ███████╗         ║
║   ██╔══██╗██╔═══██╗██╔══██╗██╔══██╗██╔═══██╗██╔════╝         ║
║   ██████╔╝██║   ██║██████╔╝███████║██║   ██║███████╗         ║
║   ██╔══██╗██║   ██║██╔══██╗██╔══██║██║   ██║╚════██║         ║
║   ██████╔╝╚██████╔╝██║  ██║██║  ██║╚██████╔╝███████║         ║
║   ╚═════╝  ╚═════╝ ╚═╝  ╚═╝╚═╝  ╚═╝ ╚═════╝ ╚══════╝         ║
║                                                               ║
║                   Welcome to BoraOS 0.1                       ║
║                  Live Installation Media                      ║
║                                                               ║
╚═══════════════════════════════════════════════════════════════╝

Type 'archinstall' to start the installation process
Type 'hyprland' to launch the Hyprland desktop environment

For more information, visit: https://boraos.org

EOF

echo "BoraOS live system setup completed successfully!"
