{ config, pkgs, inputs, ... }:

{
  imports = [
    ./shared.nix
  ];
  
  home.username = "morpheus";
  home.homeDirectory = "/Users/morpheus";
  home.stateVersion = "24.11";
  
  # macOS-specific dotfiles
  home.file = {
    # Ghostty terminal (macOS settings)
    ".config/ghostty/config".source = ../.config/ghostty/config;
    
    # Add any other macOS-specific dotfiles here if needed
  };
  
  # Let Home Manager install and manage itself
  programs.home-manager.enable = true;

}
