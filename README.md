# Homelab

NixOS server config (flakes + disko). Host: `homelab`.

Purpose: hosting data pipelines, APIs, scraping scripts, and AI agents.

## Layout

- `flake.nix`: `nixosConfigurations.homelab` and `diskoConfigurations.homelab`
- `hosts/homelab/configuration.nix`: base system, SSH, Tailscale, auto-upgrade
- `hosts/homelab/hardware-configuration.nix`: portable hardware defaults
- `hosts/homelab/disko.nix`: disk layout

## Disk layout

Target: 512GB NVMe SSD (`/dev/nvme0n1` by default).

- ESP: 1G, vfat, mounted at `/boot`
- swap: 8G, swap
- root: 100G, ext4, mounted at `/`
- data: remaining space, ext4, mounted at `/srv`

## Install (minimal ISO)

Prerequisite: push this repo to GitHub, or copy it to a USB stick. The commands
below reference the flake; a local path works too (see the note at the end).

1. Boot the NixOS minimal ISO and switch to root:

   ```bash
   sudo -i
   ```

2. Get network access. Ethernet usually works out of the box. For Wi-Fi:

   ```bash
   nmtui
   ```

3. Identify the target disk:

   ```bash
   lsblk
   ```

4. Partition, format, and mount with disko. This destroys the disk:

   ```bash
   nix --experimental-features "nix-command flakes" run \
     github:nix-community/disko/latest -- \
     --mode destroy,format,mount \
     --flake github:hh9dj/homelab#homelab \
     --argstr device /dev/nvme0n1
   ```

5. Install:

   ```bash
   nixos-install \
     --flake github:hh9dj/homelab#homelab \
     --root /mnt \
     --no-channel-copy \
     --no-root-password
   ```

6. Set the user password and reboot:

   ```bash
   nixos-enter --root /mnt -c 'passwd khalil'
   reboot
   ```

## Post-install

- Log in as `khalil`.
- Join Tailscale:

  ```bash
  sudo tailscale up
  ```

- SSH is key-only. The authorized key is set in `configuration.nix`.
- Automatic upgrades and weekly garbage collection are enabled. `system.autoUpgrade`
  pulls `github:hh9dj/homelab#homelab`; edit `configuration.nix` if you fork.
- Apply changes from the repo:

  ```bash
  sudo nixos-rebuild switch --flake .#homelab
  ```

## Notes

- To use a local flake instead of GitHub, replace the flake reference in steps 4 and 5
  with the repo path, for example `--flake /mnt/usb/homelab#homelab`.
- Nix only sees files tracked by Git. Commit the files (or use a `path:` flake reference)
  before running `nixos-rebuild` or the install commands from a local clone.
- To change the target disk, pass a different `--argstr device /dev/<device>`.
- `hardware-configuration.nix` is portable. After install you may replace it with a
  generated one for exact hardware detection:

  ```bash
  sudo nixos-generate-config --show-hardware-config > hosts/homelab/hardware-configuration.nix
  ```
