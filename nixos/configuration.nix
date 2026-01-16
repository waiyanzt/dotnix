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
    # gnome-tweaks
    # dconf-editor
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
    polychromatic

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
  
  users.users.ztzy= {
    isNormalUser = true;
    description = "Morpheus";
    shell = pkgs.fish;
    extraGroups = [ "openrazer" "networkmanager" "wheel" "plugdev"];
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

  # to configure razer mouse and kb
  hardware.openrazer.enable = true;

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

  # Enable the COSMIC Login manager
  services.displayManager.cosmic-greeter.enable = true;

  # Enable the COSMIC desktip environment
  services.desktopManager.cosmic.enable = true;

  services.displayManager.autoLogin = {
    enable = true;
    user = "ztzy";
  };

  services.system76-scheduler.enable = true;

  environment.sessionVariables.COSMIC_DATA_CONTROL_ENABLED = 1;


  # GNOME Desktop
  # services.xserver = {
  #   enable = true;
  #   displayManager.gdm.enable = true;
  #   desktopManager.gnome.enable = true;
  #   xkb = {
  #     layout = "us";
  #     variant = "";
  #   };
  # };

  
  
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

  # udev rules for flashing zsa moonlander
  services.udev.extraRules = ''
  # Rules for Oryx web flashing and live training
    KERNEL=="hidraw*", ATTRS{idVendor}=="16c0", MODE="0664", GROUP="plugdev"
    KERNEL=="hidraw*", ATTRS{idVendor}=="3297", MODE="0664", GROUP="plugdev"

    # Rule for all ZSA keyboards
    SUBSYSTEM=="usb", ATTR{idVendor}=="3297", GROUP="plugdev"
    
    # Wally Flashing rules for the Ergodox EZ
    ATTRS{idVendor}=="16c0", ATTRS{idProduct}=="04[789B]?", ENV{ID_MM_DEVICE_IGNORE}="1"
    ATTRS{idVendor}=="16c0", ATTRS{idProduct}=="04[789A]?", ENV{MTP_NO_PROBE}="1"
    SUBSYSTEMS=="usb", ATTRS{idVendor}=="16c0", ATTRS{idProduct}=="04[789ABCD]?", MODE:="0666"
    KERNEL=="ttyACM*", ATTRS{idVendor}=="16c0", ATTRS{idProduct}=="04[789B]?", MODE:="0666"
    
    # Keymapp / Wally Flashing rules for the Moonlander and Planck EZ
    SUBSYSTEMS=="usb", ATTRS{idVendor}=="0483", ATTRS{idProduct}=="df11", MODE:="0666", SYMLINK+="stm32_dfu"
    
    # Keymapp Flashing rules for the Voyager
    SUBSYSTEMS=="usb", ATTRS{idVendor}=="3297", MODE:="0666", SYMLINK+="ignition_dfu"
  '';

  users.groups.plugdev = {};
  
  # GPG
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  system.stateVersion = "25.05";
}
