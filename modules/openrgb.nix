{ config, pkgs, lib, ... }:

{
  # Enable OpenRGB daemon/service
  services.hardware.openrgb = {
    enable = true;

    # Use package with all plugins for best device support
    package = pkgs.openrgb-with-all-plugins;
  };

  # Add OpenRGB CLI/GUI to global PATH for manual launch
  environment.systemPackages = lib.mkForce (
    (config.environment.systemPackages or []) ++ [ pkgs.openrgb-with-all-plugins ]
  );

  # Load kernel modules required for I2C device communication
  boot.kernelModules = lib.mkForce ((config.boot.kernelModules or []) ++ [ "i2c-dev" ]);

  # Enable I2C in the kernel/hardware configuration
  hardware.i2c.enable = true;

  # Provide udev rules for OpenRGB device access
  services.udev.packages = (config.services.udev.packages or []) ++ [ pkgs.openrgb ];
}
