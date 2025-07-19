{ config, pkgs, ... }:

{
  # Provide user and home directory details.
  home.username = "josh";
  home.homeDirectory = "/home/josh";

  # Enable this for non-NixOS systems like Ubuntu.
  targets.genericLinux.enable = true;

  # Home Manager itself
  programs.home-manager.enable = true;

  # Install user-specific packages.
  home.packages = with pkgs; [
    brave       # Web browser
    obsidian    # Note-taking app
    git
    vscode      # Visual Studio Code
    waveterm
    _1password-gui
  ];

  # Global Git configuration for user
  programs.git = {
    enable = true;
    userName = "Josh";
    userEmail = "jcnichols22@gmail.com";
    aliases = {};
    extraConfig = {
      init.defaultBranch = "main";
    };
  };

  # Home Manager version tracking
  home.stateVersion = "25.05";
}
