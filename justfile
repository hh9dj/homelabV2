host := "homelab"

default:
    @just --list

# Update all flake inputs and show the lock diff
update:
    nix flake update
    git diff --stat flake.lock

# Update one flake input, for example: just update-input nixpkgs
update-input name:
    nix flake update {{name}}
    git diff --stat flake.lock

check:
    nix flake check

fmt:
    nix fmt

# Apply the config on this machine. Only runs on the server itself.
switch:
    @[ "$(hostname)" = "{{host}}" ] || { echo "refusing: this is not {{host}}. Use 'just deploy' from your workstation."; exit 1; }
    sudo nixos-rebuild switch --flake .#{{host}}

# Build locally and deploy to the server over SSH
deploy:
    nixos-rebuild switch --flake .#{{host}} --target-host khalil@{{host}} --sudo
