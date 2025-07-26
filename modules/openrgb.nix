{ config, pkgs, lib, ... }:

{
  services.hardware.openrgb = {
    enable = true;
    package = pkgs.openrgb;
  };

  boot.kernelModules = lib.mkForce [ "i2c-dev" ];
  hardware.i2c.enable = true;

  # Avoid this line to prevent recursion:
  # services.udev.packages = (config.services.udev.packages or []) ++ [ pkgs.openrgb ];

  # Instead, optionally define a default list that can be extended elsewhere:
  services.udev.packages = lib.mkDefault [ pkgs.openrgb ];
}
