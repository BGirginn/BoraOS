# BoraOS Future Enhancements - Roadmap

## Priority 1: Essential Improvements (Ready to Implement)

### ✅ COMPLETED: Web Browser
- [x] Added Firefox to live environment for documentation access
- Users can browse web and read documentation during installation

### 🔒 Security Hardening
**Status**: Documentation created (`SECURITY.md`)

**Next Steps**:
- [ ] Create automated post-install security script
- [ ] Add warning message on first boot after installation
- [ ] Integrate into archinstall workflow

**Implementation**:
```bash
# Auto-run script location: /etc/profile.d/boraos-first-boot.sh
# Check if system is freshly installed and warn about NOPASSWD
```

## Priority 2: ARM64 Build Automation

### Pre-Build Script for ARM64
**Status**: Planned

**Problem**: ARM64 lacks `archiso` in official repos (AUR only)

**Solution**: Automated pre-build script

**File**: `Bora_OS_ARM/build/scripts/00-prepare-archiso-arm.sh`

```bash
#!/usr/bin/env bash
# Automated AUR archiso installation for ARM64

# Check if archiso is installed
if ! pacman -Q archiso &>/dev/null; then
    echo "Installing archiso from AUR..."
    
    # Install yay (AUR helper) if not present
    if ! command -v yay &>/dev/null; then
        git clone https://aur.archlinux.org/yay-bin.git
        cd yay-bin
        makepkg -si --noconfirm
        cd .. && rm -rf yay-bin
    fi
    
    # Install archiso
    yay -S --noconfirm archiso
fi
```

**Effort**: Low (1-2 hours)  
**Impact**: High (simplifies ARM64 builds significantly)

## Priority 3: TUI Installer (Major Feature)

### Custom Terminal UI Installer
**Status**: Design Phase

**Current State**: 
- `installer_config_schema.json` exists with detailed schema
- Only `archinstall` available (generic, not BoraOS-specific)

**Proposed Stack**:
- **Language**: Rust or Python
- **TUI Library**: 
  - Rust: `ratatui` (formerly tui-rs) ← Recommended
  - Python: `textual` or `urwid`

**Features**:
1. Guided BoraOS-specific installation
2. Automatic Hyprland configuration
3. Theme selection (Waybar, SDDM)
4. Locale/timezone setup for Turkish users
5. Post-install security hardening integration
6. Automatic dotfiles installation

**File Structure**:
```
Bora_OS_x86/installer/
├── Cargo.toml (or pyproject.toml)
├── src/
│   ├── main.rs
│   ├── ui/
│   │   ├── welcome.rs
│   │   ├── disk.rs
│   │   ├── user.rs
│   │   ├── network.rs
│   │   └── theme.rs
│   ├── backend/
│   │   ├── partitioner.rs
│   │   ├── installer.rs
│   │   └── config.rs
│   └── schema.rs (from installer_config_schema.json)
└── README.md
```

**Effort**: High (20-40 hours)  
**Impact**: Very High (signature feature, huge UX improvement)

**Development Phases**:
1. **Phase 1**: JSON schema parser
2. **Phase 2**: Basic TUI framework
3. **Phase 3**: Disk partitioning UI
4. **Phase 4**: User/network configuration
5. **Phase 5**: Theme selection
6. **Phase 6**: Installation backend
7. **Phase 7**: Testing and refinement

## Priority 4: Package Enhancements

### Additional Packages to Consider

**Web Browsers** (alternatives/additions):
- [ ] `chromium` - Google Chrome open-source version
- [ ] `qutebrowser` - Keyboard-driven, minimal

**File Managers** (GUI option):
- [ ] `thunar` - Lightweight GUI file manager
- [ ] `pcmanfm-qt` - Qt-based lightweight option

**Text Editors** (GUI):
- [ ] `code` (VS Code) - Popular IDE
- [ ] `gedit` or `mousepad` - Simple GUI editors

**System Tools**:
- [ ] `gparted` - GUI partition editor (useful for live environment)
- [ ] `timeshift` - System backup/restore

**Network Tools**:
- [ ] `wireshark-qt` - Network analyzer (optional, advanced users)

## Priority 5: Localization

### Turkish Language Support
**Status**: Fonts OK, needs full locale

**Tasks**:
- [ ] Add Turkish locale generation to build
- [ ] Turkish keyboard layout by default
- [ ] Turkish timezone (Europe/Istanbul) default
- [ ] Turkish UI translations for installer
- [ ] Turkish documentation (`README.tr.md`)

## Implementation Timeline

### Sprint 3 (Immediate - Next Week)
- [x] Firefox addition
- [x] Security documentation
- [ ] ARM64 pre-build script
- [ ] Security hardening automation

### Sprint 4 (Short-term - 2-4 weeks)
- [ ] TUI Installer - Phase 1-3
- [ ] Additional package considerations
- [ ] Turkish localization

### Sprint 5 (Medium-term - 1-2 months)
- [ ] TUI Installer - Phase 4-7
- [ ] GUI options research
- [ ] Advanced theming system

## Community Contributions

Areas where contributions would be most valuable:
1. **TUI Installer** - Complex, needs Rust/Python expertise
2. **Theming System** - Design skills, Hyprland knowledge
3. **Documentation** - Turkish translations, guides
4. **Testing** - ARM64 hardware testing, bug reports

---

**Last Updated**: 2025-12-04  
**Project Status**: Active Development  
**Current Sprint**: 3
