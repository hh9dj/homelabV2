{ pkgs, ... }:
{
  imports = [
    ./disko.nix
    ./hardware-configuration.nix
  ];

  nix = {
    settings = {
      experimental-features = [
        "flakes"
        "nix-command"
      ];
      # Allow these users to receive unsigned store paths from remote builds
      # (nixos-rebuild --target-host, nix copy). Root-equivalent: fine for a
      # single-user server.
      trusted-users = [
        "root"
        "khalil"
      ];
    };
    optimise.automatic = true;
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 14d";
    };
  };

  boot = {
    blacklistedKernelModules = [ "cfg80211" ];
    kernel = {
      sysctl = {
        "vm.swappiness" = 10;
      };
    };
    loader = {
      efi = {
        canTouchEfiVariables = true;
      };
      systemd-boot = {
        configurationLimit = 10;
        enable = true;
      };
    };
  };

  services = {
    fstrim = {
      enable = true;
    };
    openssh = {
      enable = true;
      settings = {
        KbdInteractiveAuthentication = false;
        PasswordAuthentication = false;
        PermitRootLogin = "no";
      };
    };
    tailscale = {
      enable = true;
      openFirewall = true;
      useRoutingFeatures = "client";
    };
  };

  zramSwap.enable = true;

  networking = {
    hostName = "homelab";
    networkmanager.enable = false;
    firewall.interfaces.tailscale0.allowedTCPPorts = [ 22 ];
  };

  time.timeZone = "Europe/Paris";

  users.users.khalil = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMs9s/E2UpJ6TZP7i4vsW8Ry6JhS2ZxAYEWz2UWwrSFZ"
    ];
  };

  system.autoUpgrade = {
    enable = true;
    flake = "github:hh9dj/homelabV2#homelab";
  };

  environment.systemPackages = with pkgs; [
    vim
    git
    curl
    htop
  ];

  system.stateVersion = "26.05";
}
