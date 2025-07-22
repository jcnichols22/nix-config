{
  description = "Unified NixOS + Ubuntu config with Home Manager";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";  # Stable Nixpkgs
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, nixpkgs-unstable, home-manager, ... }:
    let
      lib = nixpkgs.lib;

      # Helper to get pkgs with unfree enabled
      pkgsFor = system: import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };

      # Shared app list across systems
      sharedPackages = system: import ./packages/default.nix {
        pkgs = pkgsFor system;
      };

    in {

      nixosConfigurations = {
        nixos = lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            ./hosts/nixos/configuration.nix
            ./modules/system-settings.nix
            ./modules/audio.nix
            ./modules/desktop/plasma.nix
            ./modules/networking/tailscale.nix
            ./modules/users.nix
            ./hosts/nixos/hardware-configuration.nix
          ];
        };
      };

      homeConfigurations = {
        ubuntu = home-manager.lib.homeManagerConfiguration {
          pkgs = pkgsFor "x86_64-linux";
          homeDirectory = "/home/josh";
          username = "josh";

          modules = [
            ./hosts/ubuntu/home.nix

            # Optional: shared users module
            ./modules/users.nix

            # Inject shared apps via a module
            ({ pkgs, ... }: {
              home.packages = sharedPackages "x86_64-linux";
            })
          ];
        };
      };
    };
}
