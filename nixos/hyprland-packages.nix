# Hyprland-specific packages - archived for future use
{ pkgs, ... }:

{
  # Uncomment this whole block when you want Hyprland back
  # environment.systemPackages = with pkgs; [
  #   # Wayland/Hyprland specific
  #   waybar
  #   kanshi
  #   hyprlock
  #   hypridle
  #   swww
  #   wlogout
  #   swayosd
  #   swaynotificationcenter
  #   rofi
  #   grim
  #   slurp
  #   
  #   # WM utilities
  #   libnotify
  #   playerctl
  # ];
  
  # programs.hyprland = {
  #   enable = true; 
  #   xwayland.enable = true;
  # };
}
