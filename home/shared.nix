{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    starship
    zoxide
    eza 
    direnv
  ];

  # Dotfiles - symlinked automatically
  home.file = {
    ".config/fish/config.fish".source = ../.config/fish/config.fish;
    # ".config/fish/functions".source = ../.config/fish/functions;

    # Neovim configuration
    ".config/nvim/init.lua".source = ../.config/nvim/init.lua;
    ".config/nvim/lua/themes.lua".source = ../.config/nvim/lua/themes.lua;
    ".config/nvim/lua/neckpain.lua".source = ../.config/nvim/lua/neckpain.lua;
    ".config/nvim/lua/dashboard.lua".source = ../.config/nvim/lua/dashboard.lua;
  };
}
