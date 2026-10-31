{
  description = "khalil's homelab - NixOS server config";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    disko = {
      url = "github:nix-community/disko/latest";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      nixpkgs,
      disko,
      ...
    }@inputs:
    {
      nixosConfigurations.homelab = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs; };
        modules = [
          ./hosts/homelab/configuration.nix
          disko.nixosModules.disko
        ];
      };

      diskoConfigurations.homelab = import ./hosts/homelab/disko.nix;
    };
}
