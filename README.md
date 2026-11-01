# Homelab

NixOS server config (flakes + disko). Host: `homelab`.

Channel: stable `nixos-26.05`. disko is pinned to tag `v1.13.0`.
Wi-Fi is disabled. The server uses Ethernet only.

## Layout

- `flake.nix`: `nixosConfigurations.homelab`, `diskoConfigurations.homelab`, and a dev shell (via `flake-utils`)
- `justfile`: helper commands (`just --list`): `update`, `update-input`, `check`, `fmt`, `deploy`, `generations`
- `hosts/homelab/configuration.nix`: base system, SSH, Tailscale, auto-upgrade
- `hosts/homelab/hardware-configuration.nix`: portable hardware defaults
- `hosts/homelab/disko.nix`: disk layout

## Setup

For disk layout, installation, and post-install steps, see [SETUP.md](SETUP.md).
