{ pkgs, ... }:
{
  imports = [
    ./disko.nix
    ./hardware-configuration.nix
  ];

  nix.settings.experimental-features = [
    "flakes"
    "nix-command"
  ];

  nixpkgs.config.allowUnfree = true;

  boot.loader = {
    efi.canTouchEfiVariables = true;
    systemd-boot.enable = true;
  };

  boot.kernel.sysctl = {
    "vm.swappiness" = 10;
  };

  networking = {
    hostName = "homelab";
    networkmanager.enable = true;
  };

  time.timeZone = "Europe/Paris";

  users.users.khalil = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMs9s/E2UpJ6TZP7i4vsW8Ry6JhS2ZxAYEWz2UWwrSFZ"
    ];
  };

  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
      PermitRootLogin = "no";
    };
  };

  services.tailscale.enable = true;

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 14d";
  };

  system.autoUpgrade = {
    enable = true;
    flake = "github:hh9dj/homelab#homelab";
  };

  environment.systemPackages = with pkgs; [
    vim
    git
    curl
    htop
  ];

  system.stateVersion = "26.05";
}
