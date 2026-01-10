{ config, pkgs, inputs, ... }:

{
  nixpkgs.config.allowUnfree = true;
  
  # System packages - CLI tools only, no GUI apps
  environment.systemPackages = with pkgs; [
    # Shell and terminal
    starship
    
    # Essential CLI tools
    git
    curl
    wget
    vim
    neovim
    aws-sam-cli
    
    # File management and navigation
    yazi
    zoxide
    eza
    ripgrep
    fd
    
    # System utilities
    btop
    fastfetch
    
    # Compression
    zip
    unzip
    
    # Dev tools
    python3
    gcc
    
    # Fonts
    nerd-fonts.iosevka-term
    
    # Apps
    telegram-desktop
    claude-code
  ];
  
  
  # Set Fish as default shell for your user
  programs.fish.enable = true;
  users.users.morpheus = {
    name = "morpheus";
    home = "/Users/morpheus";
    shell = pkgs.fish;
  };
  
  # Enable direnv for per-project environments
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };
  
  # ADD THIS - required for system defaults to work
  system.primaryUser = "morpheus";
  
  # Nix settings
  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
  };
  
  # Auto-optimize store
  nix.optimise.automatic = true;
  
  # Garbage collection - weekly cleanup
  nix.gc = {
    automatic = true;
    interval = { Weekday = 0; Hour = 2; Minute = 0; };
    options = "--delete-older-than 30d";
  };
  
  # macOS system defaults
  system.defaults = {
    dock = {
      autohide = true;
      show-recents = false;
    };
    finder = {
      AppleShowAllExtensions = true;
      FXEnableExtensionChangeWarning = false;
    };
    NSGlobalDomain = {
      AppleShowAllExtensions = true;
      InitialKeyRepeat = 15;
      KeyRepeat = 2;
    };
  };
  
  # Networking
  networking.hostName = "balthazar";
  networking.computerName = "balthazar";
  
  # Used for backwards compatibility
  system.stateVersion = 5;
  
  # Platform
  nixpkgs.hostPlatform = "aarch64-darwin";
}
