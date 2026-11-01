host := "homelab"

default:
    @just --list

# Update all flake inputs and show the lock diff
update:
    nix flake update
    git diff --stat flake.lock

# Update one flake input, for example: just update-input nixpkgs
update-input name:
    nix flake update {{ name }}
    git diff --stat flake.lock

check:
    nix flake check

fmt:
    nix fmt

# Build locally and deploy to the server over SSH
deploy:
    nixos-rebuild switch --flake .#{{ host }} --target-host khalil@{{ host }} --ask-sudo-password

# List system generations on the server
generations:
    ssh khalil@{{ host }} nixos-rebuild list-generations
