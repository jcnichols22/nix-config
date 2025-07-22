{ config, pkgs, ... }:

{
  users.users.josh = {
    isNormalUser = true;
    description = "josh";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
      kdePackages.kate
    ];
  };
}
