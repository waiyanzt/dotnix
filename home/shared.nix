{ config, pkgs, ... }:

{
  # Fish shell - just enable it, customizations go in config.fish
  programs.fish.enable = true;
  
  # Starship prompt
  programs.starship = {
    enable = true;
    enableFishIntegration = true;
  };
  
  # Zoxide (smart cd)
  programs.zoxide = {
    enable = true;
    enableFishIntegration = true;
  };
  
  # Direnv (per-project environments)
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };
  
  # Dotfiles - symlinked automatically
  home.file = {
    # Fish shell configuration
    ".config/fish/config.fish".source = ../.config/fish/config.fish;
    ".config/fish/fish_variables".source = ../.config/fish/fish_variables;
    
    # Neovim configuration
    ".config/nvim/init.lua".source = ../.config/nvim/init.lua;
    ".config/nvim/lua/themes.lua".source = ../.config/nvim/lua/themes.lua;
    ".config/nvim/lua/neckpain.lua".source = ../.config/nvim/lua/neckpain.lua;
    ".config/nvim/lua/dashboard.lua".source = ../.config/nvim/lua/dashboard.lua;
  };
}
