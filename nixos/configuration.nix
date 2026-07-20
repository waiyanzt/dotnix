{ config, pkgs, inputs, ... }:

{
  # ============================================================================
  # 1. CORE SYSTEM & BOOT
  # ============================================================================
  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.permittedInsecurePackages = [
    "electron-39.8.10"
  ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  # Avoid tracking bleeding-edge kernels on this laptop; reboot hangs are often
  # kernel/platform regressions, and the default kernel set is the safer baseline.
  boot.kernelPackages = pkgs.linuxPackages;
  
  networking.hostName = "thanatos";
  networking.networkmanager.enable = true;
  
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
  
  # ============================================================================
  # 2. DESKTOP ENVIRONMENT - NIRI
  # ============================================================================
  programs.niri.enable = true;
  security.polkit.enable = true;
  services.gnome.gnome-keyring.enable = true;

  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${pkgs.tuigreet}/bin/tuigreet --time --remember --cmd niri-session";
        user = "greeter";
      };
    };
  };
  
  # Keep XKB configured for Wayland compositors and Xwayland apps.
  services.xserver = {
    xkb = {
      layout = "us";
      variant = "";
    };
  };
  
  # ============================================================================
  # 3. USER CONFIGURATION
  # ============================================================================
  users.users.ztzy = {
    isNormalUser = true;
    description = "Morpheus";
    shell = pkgs.fish;
    extraGroups = [ "openrazer" "networkmanager" "wheel" "plugdev" ];
  };
  
  programs.fish.enable = true;
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };
    
  # ============================================================================
  # 4. ESSENTIAL SERVICES
  # ============================================================================
  services.openssh.enable = true;
  services.printing.enable = true;
  services.power-profiles-daemon.enable = true;
  services.upower.enable = true;
  services.blueman.enable = true;
  services.fwupd.enable = true;
  
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
  
  # Hardware
  hardware.graphics.enable = true;
  hardware.bluetooth.enable = true;
  hardware.openrazer.enable = true;
  
  # ThinkPad Battery Thresholds
  systemd.services.battery-charge-threshold = {
    description = "Set ThinkPad battery thresholds";
    script = ''
      echo 85 > /sys/class/power_supply/BAT0/charge_control_end_threshold
      echo 80 > /sys/class/power_supply/BAT0/charge_control_start_threshold
    '';
    wantedBy = [ "multi-user.target" ];
    serviceConfig.Type = "oneshot";
  };
  
  # udev rules for ZSA keyboard flashing
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

  programs.steam = {
    enable = true;
    protontricks.enable = true;
    extest.enable = true;
  };
  
  # ============================================================================
  # 5. PACKAGE INSTALLATION
  # ============================================================================
  environment.systemPackages = with pkgs; [
    # Development
    git
    vim
    neovim
    zed-editor
    ghostty
    gcc
    gnumake
    valgrind
    nodejs
    python3
    mcp-nixos
    xwayland-satellite
    
    # Browsers
    google-chrome
    inputs.zen-browser.packages.${pkgs.system}.default
    brave
    
    # Applications
    vesktop
    spotify
    bitwarden-desktop
    zathura
    telegram-desktop
    todoist-electron
    openconnect

    # CLI Utilities
    fastfetch
    wget
    curl
    btop
    yazi
    wl-clipboard
    pciutils
    zip
    unzip
    codex
    
    # Disk utilities for partitioning
    gparted
    popsicle
  ];
  
  
  # ============================================================================
  # 6. STORAGE OPTIMIZATION (Critical for 120GB partition)
  # ============================================================================
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 7d";
  };
  
  nix.settings.auto-optimise-store = true;
  
  # Keep fewer generations to save space
  boot.loader.systemd-boot.configurationLimit = 5;
  
  # ============================================================================
  # 7. ENVIRONMENT VARIABLES
  # ============================================================================
  environment.sessionVariables = {
    # Enable Wayland support for Chromium/Electron apps
    NIXOS_OZONE_WL = "1";
    
    # Optional: Force Wayland for Firefox
    MOZ_ENABLE_WAYLAND = "1";
  };
  
  # ============================================================================
  # 8. SYSTEM STATE VERSION
  # ============================================================================
  system.stateVersion = "25.05";
}
