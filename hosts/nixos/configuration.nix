{ config, pkgs, ... }:

{
  # Import hardware config manually if not imported by flake
  imports = [
    ./hardware-configuration.nix
  ];

  # Import shared packages here by importing the shared package list from your flake repo
  # Adjust relative path if your layout differs
  environment.systemPackages = import ../../packages/default.nix { inherit pkgs; };

  # Minimal host-specific settings can also go here or in modules
}
