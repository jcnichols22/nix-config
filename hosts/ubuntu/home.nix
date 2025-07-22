{ config, pkgs, ... }:

{
  programs.home-manager.enable = true;

  home.packages = with pkgs; [
    # Reference the same shared package list here if possible,
    # or just list apps you want on Ubuntu user environment
    brave
    obsidian
    vscode
    _1password-gui
    # Note: tailscale and waveterm can also be added if needed
  ];

  # Enable additional Home-Manager modules or config here if desired
}
