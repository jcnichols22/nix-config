{
  description = "System configuration for NixOS with home-manager and flakes";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";
    flake-utils.url = "github:numtide/flake-utils";
    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, flake-utils, home-manager, ... }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };
    in
    flake-utils.lib.eachDefaultSystem (system:
      {
        packages.default = pkgs.hello;
      }
    ) // {

      # ✅ NixOS system configuration
      nixosConfigurations = {
        nixos = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            ./nixos/configuration.nix
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.josh = import ./home/josh/home.nix;
            }
          ];
        };
      };

      # ✅ Standalone Home Manager configuration for Ubuntu (and other Linux distros)
      homeConfigurations = {
        josh = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          modules = [
            ./home/josh/home.nix
          ];
        };
      };

    };
}
