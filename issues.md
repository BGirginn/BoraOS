# BoraOS – Full ArchISO Build Failure Report  
### All Issues Preventing ISO Generation

---

## 1. Missing UEFI Bootloader Files
ArchISO requires a complete UEFI loader structure:

- `efiboot/loader/loader.conf` — missing  
- `efiboot/loader/entries/*.conf` — missing  
- Additional required subfolders also missing:  
  - `efiboot/fonts/`  
  - `efiboot/EFI/Boot/*`  
  - `efiboot/EFI/systemd/*`

**Effect:** UEFI boot fails.

---

## 2. Missing Syslinux BIOS Boot Files
Required for BIOS boot:

- `syslinux/syslinux.cfg`  
- `archiso_sys.cfg`  
- `archiso_head.cfg`  
- `archiso_pxe.cfg`  
- Multiple `.c32` modules

**Effect:** BIOS/Legacy boot impossible.

---

## 3. Broken or Missing `airootfs/`
Critical ArchISO live filesystem is incomplete:

- `airootfs/root/` missing  
- `airootfs/root/.automated_script.sh` missing  
- `airootfs/etc/*` incomplete  
- `airootfs/usr/` missing  
- Other expected structure missing entirely

**Effect:** mkarchiso aborts with permission/path errors.

---

## 4. Deprecated Boot Modes in `profiledef.sh`
BoraOS uses outdated modes:

- `uefi-x64.systemd-boot.esp`  
- `bios.syslinux.mbr`  
- `bios.syslinux.eltorito`

Correct modern modes:

- `bios.syslinux`  
- `uefi.systemd-boot`

**Effect:** build warnings and potential boot failures.

---

## 5. Invalid pacman.conf Directive
pacman.conf contains:

- `CompressZstd` — not a valid directive

**Effect:** pacman may fail inside build root.

---

## 6. Conflicting / Overloaded Package List
The package list mixes:

- Hyprland  
- SDDM  
- PipeWire + Pulse  
- Wayland + XWayland  
- Qt5 + Qt6  
- GNOME keyring  
- Multiple network stacks  
- Both Intel + AMD Vulkan drivers  

**Effect:** dependency conflicts, unstable live session, graphical failures.

---

## 7. Missing `.automated_script.sh`
Required file:

- `airootfs/root/.automated_script.sh`

**Effect:** fatal mkarchiso error.

---

## 8. Missing Sudoers Configuration
Expected:

- `airootfs/etc/sudoers`  
- `airootfs/etc/sudoers.d/*`

**Effect:** live system boots without sudo capability.

---

## 9. Outdated / Incomplete ArchISO Profile
BoraOS profile appears to be based on older ArchISO schema:

- Missing new hooks  
- Missing updated systemd-boot structure  
- Missing essential profile files  
- Not aligned with mkarchiso (v87+)

**Effect:** repeated validation failures.

---

## Summary Table

| Issue | Description | Severity |
|-------|-------------|----------|
| Missing UEFI files | loader.conf + entries missing | Critical |
| Missing Syslinux files | Entire syslinux/ missing | Critical |
| Missing/broken airootfs | No root filesystem | Critical |
| Deprecated boot modes | Outdated profiledef.sh | High |
| Invalid pacman.conf | Unsupported directive | Medium |
| Conflicting packages | Desktop stack conflicts | Medium |
| Missing automated script | mkarchiso abort | Critical |
| Missing sudoers | Live environment broken | High |
| Outdated profile | Incompatible with ArchISO 2025 | High |