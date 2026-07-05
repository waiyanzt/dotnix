{ config, pkgs, inputs, ... }:

{
  imports = [
    ./shared.nix
    inputs.noctalia.homeModules.default
  ];
  
  home.username = "ztzy";
  home.homeDirectory = "/home/ztzy";
  home.stateVersion = "25.05";
  
  # NixOS-specific dotfiles
  home.file = {
    # Ghostty terminal (Linux-specific settings)
    ".config/ghostty/config".source = ../.config/ghostty/config;
  };

  # The module installs Noctalia. Settings can be added here incrementally;
  # Noctalia v5 keeps GUI-written overrides in its mutable state directory.
  programs.noctalia.enable = true;

  # Keep Niri's KDL configuration in the repository while Home Manager places
  # it at ~/.config/niri/config.kdl.
  xdg.configFile."niri/config.kdl".source = ../.config/niri/config.kdl;

  programs.home-manager.enable = true;
}
