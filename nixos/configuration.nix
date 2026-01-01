{ config, pkgs, inputs, ... }:

{
  nixpkgs.config.allowUnfree = true;
  nix.settings.experimental-features = [ "nix-command" "flakes"];

  # Bootloader
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # System packages - CLEANED UP (removed Hyprland-specific stuff)
  environment.systemPackages = with pkgs; [
    # GNOME apps 
    gnome-tweaks
    dconf-editor
    vesktop
    # Extensions
    gnomeExtensions.appindicator

    # Productivity apps
    bitwarden-desktop
    libreoffice-qt-fresh
    xournalpp
    telegram-desktop
    todoist-electron
    
    # Browsers
    google-chrome
    brave
    inputs.zen-browser.packages.${pkgs.system}.default
    
    # Development tools
    git
    vim
    neovim
    zed-editor
    vscode-fhs
    ghostty
    
    # Dev languages/tools
    nodejs_20
    python3
    gcc
    gnumake
    valgrind
    
    # CLI utilities
    wget
    curl
    fastfetch
    btop
    yazi
    zip
    unzip
    
    # System utilities
    wl-clipboard
    imagemagick
    mesa
    vimix-cursors
    
    # Gaming
    protonup-qt
    
    # kdePackages.dolphin  
    
    # pavucontrol  # Volume control GUI
  ]; 

  environment.gnome.excludePackages = with pkgs; [
    gnome-tour
    epiphany
    geary
    gnome-music
  ];

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  programs.chromium.enable = true;
  programs.steam.enable = true;
  programs.fish.enable = true;
  
  users.users.ztzy = {
    isNormalUser = true;
    description = "Marcus";
    shell = pkgs.fish;
    extraGroups = [ "networkmanager" "wheel" ];
  };

  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
    XDG_DATA_DIRS = [
      "/home/ztzy/.local/share/flatpak/exports/share"
      "/var/lib/flatpak/exports/share"
    ];
  };

  hardware.graphics.enable = true;
  hardware.bluetooth.enable = true;

  # XDG portal - GNOME uses its own, but keeping GTK is fine
  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-gtk
      # xdg-desktop-portal-hyprland  # REMOVE - not needed for GNOME
    ];
    config.common.default = "*";
  };
  
  # Garbage collection
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 30d";
  };

  # Networking
  networking.hostName = "thanatos";
  networking.networkmanager.enable = true;

  # Locale
  time.timeZone = "America/Los_Angeles";
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  # Battery optimization for ThinkPad
  systemd.services.battery-charge-threshold = {
    description = "Battery config";
    script = ''
      echo 85 > /sys/class/power_supply/BAT0/charge_control_end_threshold
      echo 80 > /sys/class/power_supply/BAT0/charge_control_start_threshold
    '';
    wantedBy = [ "multi-user.target" ];
    serviceConfig.Type = "oneshot";
  };

  # GNOME Desktop
  services.xserver = {
    enable = true;
    displayManager.gdm.enable = true;
    desktopManager.gnome.enable = true;
    xkb = {
      layout = "us";
      variant = "";
    };
  };

  # Disable Plasma6 (already disabled, but being explicit)
  services.desktopManager.plasma6.enable = false;
  
  # Services
  services.blueman.enable = true;
  services.power-profiles-daemon.enable = true;
  services.flatpak.enable = true;
  services.printing.enable = true;
  services.openssh.enable = true;

  # Audio - PipeWire
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };

  # GPG
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  system.stateVersion = "25.05";
}
