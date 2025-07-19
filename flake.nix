{
  description = "System configuration for NixOS with home-manager and flakes";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05"; # Use stable release
    flake-utils.url = "github:numtide/flake-utils";
    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      # Choose the latest matching your NixOS version, change release if needed
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, flake-utils, home-manager, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
          config.allowUnfree = true;
        };
      in {
        packages.default = pkgs.hello; # Example placeholder
      }
    ) // {

      nixosConfigurations = {
        nixos = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            ./nixos/configuration.nix
            # Home Manager as a NixOS module:
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.josh = import ./home/josh/home.nix;
            }
          ];
        };
      };

    };
}

