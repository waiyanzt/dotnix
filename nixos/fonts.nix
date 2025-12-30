# fonts.nix
{ config, pkgs, ... }:
{
  fonts = {
    enableDefaultPackages = true;
    packages = with pkgs; [
      # Dev fonts
      nerd-fonts.zed-mono          
      nerd-fonts.iosevka-term      
      
      # General UI coverage
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-color-emoji
    ];
    fontconfig = {
      defaultFonts = {
        monospace = [ 
          "ZedMono Nerd Font"           # Primary
          "Iosevka Term Nerd Font"      # Fallback
          "Noto Sans Mono CJK SC" 
        ];
        sansSerif = [ "Noto Sans" "Noto Sans CJK SC" ];
        serif = [ "Noto Serif" "Noto Serif CJK SC" ];
        emoji = [ "Noto Color Emoji" ];
      };
    };
  };
}

