{ config, pkgs, inputs, ... }:

{
  imports = [
    ./shared.nix
  ];
  
  home.username = "ztzy";
  home.homeDirectory = "/home/ztzy";
  home.stateVersion = "25.05";
  
  # NixOS-specific dotfiles
  home.file = {
    # Hyprland
    ".config/hypr/hyprland.conf".source = ../.config/hypr/hyprland.conf;
    ".config/hypr/hyprlock.conf".source = ../.config/hypr/hyprlock.conf;
    ".config/hypr/hypridle.conf".source = ../.config/hypr/hypridle.conf;
    
    # Waybar
    ".config/waybar/config.jsonc".source = ../.config/waybar/config.jsonc;
    ".config/waybar/style.css".source = ../.config/waybar/style.css;
    ".config/waybar/scripts/toggle.sh" = {
      source = ../.config/waybar/scripts/toggle.sh;
      executable = true;
    };
    
    # Notification daemon
    ".config/swaync/config.json".source = ../.config/swaync/config.json;
    ".config/swaync/style.css".source = ../.config/swaync/style.css;
    
    # ghsotty terminal (Linux - specific settings)
    ".config/ghostty/config".source = ../.config/ghostty/config;
    # Wlogout
    ".config/wlogout/layout".source = ../.config/wlogout/layout;
    
    # Kanshi (monitor management)
    ".config/kanshi/config".source = ../.config/kanshi/config;
    
    # Assets (for waybar, etc.)
    "dotnix/assets/nix-snowflake.svg".source = ../assets/nix-snowflake.svg;
  };
  
  programs.home-manager.enable = true;
}
