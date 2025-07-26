{ config, pkgs, ... }:

let
  sharedPkgs = import ../../packages/default.nix { inherit pkgs; };
in
{
  imports = [
    ./hardware-configuration.nix
    ../../modules/openrgb.nix
  ];

  environment.systemPackages = sharedPkgs ++ [ pkgs.openrgb ];
}
