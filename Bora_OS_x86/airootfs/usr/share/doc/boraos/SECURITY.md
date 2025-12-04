# BoraOS x86_64 - Security Considerations

## Live Environment Security

### Default Configuration (LIVE ISO ONLY)

The live environment uses **passwordless sudo** for convenience during testing and installation:

**File**: `/etc/sudoers.d/g_wheel`
```
%wheel ALL=(ALL:ALL) NOPASSWD: ALL
```

⚠️ **WARNING**: This is **ONLY safe for the live environment**. Users should never boot into the installed system without changing this configuration.

## Post-Installation Security (CRITICAL)

### Step 1: Remove NOPASSWD Configuration

After completing installation to disk, **immediately** remove or modify the passwordless sudo configuration:

```bash
# Option 1: Remove the file entirely
sudo rm /etc/sudoers.d/g_wheel

# Option 2: Require password for sudo
sudo visudo /etc/sudoers.d/g_wheel
# Change line to:
%wheel ALL=(ALL:ALL) ALL
```

### Step 2: Set User Password

Ensure all user accounts have strong passwords:

```bash
# Set password for your user
passwd

# Set root password (if needed)
sudo passwd root
```

### Step 3: Verify Configuration

Test that sudo now requires password:

```bash
# This should prompt for password
sudo whoami
```

## Automated Post-Install Script

Create `/root/post-install-security.sh` after installation:

```bash
#!/bin/bash
# BoraOS Post-Installation Security Hardening

echo "=== BoraOS Security Hardening ==="

# Remove NOPASSWD sudo
if [ -f /etc/sudoers.d/g_wheel ]; then
    echo "Removing passwordless sudo..."
    rm /etc/sudoers.d/g_wheel
    echo "✓ Removed /etc/sudoers.d/g_wheel"
fi

# Force password creation if not set
if ! passwd -S $(whoami) | grep -q ' P '; then
    echo "Setting user password..."
    passwd
fi

echo "✓ Security hardening complete"
echo "Sudo now requires password."
```

Make executable and run:
```bash
chmod +x /root/post-install-security.sh
sudo /root/post-install-security.sh
```

## Additional Security Recommendations

### Firewall
```bash
# Install and enable UFW
sudo pacman -S ufw
sudo systemctl enable --now ufw
sudo ufw enable
sudo ufw default deny incoming
sudo ufw default allow outgoing
```

### SSH (if needed)
```bash
# Disable root login via SSH
sudo sed -i 's/^#PermitRootLogin.*/PermitRootLogin no/' /etc/ssh/sshd_config
# Disable password authentication (use keys)
sudo sed -i 's/^#PasswordAuthentication.*/PasswordAuthentication no/' /etc/ssh/sshd_config
sudo systemctl restart sshd
```

### Automatic Updates (optional)
```bash
# Enable automatic security updates
sudo pacman -S pacman-contrib
sudo systemctl enable --now paccache.timer
```

## Security Checklist

- [ ] Remove `/etc/sudoers.d/g_wheel` or require password
- [ ] Set strong user password
- [ ] Set root password (optional but recommended)
- [ ] Enable firewall (ufw)
- [ ] Configure SSH securely (if using)
- [ ] Review installed services
- [ ] Keep system updated regularly

---

**Remember**: The live environment is designed for testing and installation only. Always harden security after installing to disk!
