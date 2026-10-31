{
  description = "khalil's homelab - NixOS server config";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
    flake-utils.url = "github:numtide/flake-utils";
    disko = {
      url = "github:nix-community/disko/v1.13.0";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      nixpkgs,
      flake-utils,
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
    }
    // flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
      in
      {
        formatter = pkgs.nixfmt-tree;

        devShells.default = pkgs.mkShell {
          packages = with pkgs; [
            just
            nixfmt
          ];
        };
      }
    );
}
