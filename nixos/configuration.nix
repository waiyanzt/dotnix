{ config, pkgs, inputs, ... }:

{
  # ============================================================================
  # 1. CORE SYSTEM & BOOT
  # ============================================================================
  nixpkgs.config.allowUnfree = true;
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelPackages = pkgs.linuxPackages_latest;

  networking.hostName = "thanatos";
  networking.networkmanager.enable = true;
  time.timeZone = "America/Los_Angeles";

  # ============================================================================
  # 2. DESKTOP ENVIRONMENT & DISPLAY (GDM + GNOME + COSMIC)
  # ============================================================================
  services.xserver = {
    enable = true;
    displayManager.gdm.enable = true;
    desktopManager.gnome.enable = true;
    
    # Essential for Wayland/COSMIC to hand off secrets to Keyring
    updateDbusEnvironment = true; 
  };
  
  services.desktopManager.cosmic.enable = true;

  # Explicitly disable auto-login to fix the Keyring issue.
  # This forces a password entry at GDM which unlocks the secret store for Zed.
  services.displayManager.autoLogin.enable = false;

  services.dbus.packages = [ pkgs.gcr ]; # Helps with GUI prompts for secrets

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
  # 4. SYSTEM SERVICES (SRE/DevOps Tools)
  # ============================================================================
  services.system76-scheduler.enable = true; # Optimized for COSMIC/System76 hardware
  services.openssh.enable = true;
  services.flatpak.enable = true;
  services.printing.enable = true;
  services.power-profiles-daemon.enable = true;
  services.blueman.enable = true;

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

  # ============================================================================
  # 5. KEYRING & SECURITY
  # ============================================================================
  services.gnome.gnome-keyring.enable = true;
  
  # Ensures the GDM login properly triggers the keyring unlock
  security.pam.services.gdm.enableGnomeKeyring = true;
  security.pam.services.cosmic-greeter.enableGnomeKeyring = true;

  # ============================================================================
  # 6. HARDWARE & DRIVERS
  # ============================================================================
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

  # ZSA / Razer udev rules
  services.udev.extraRules = ''
    KERNEL=="hidraw*", ATTRS{idVendor}=="16c0", MODE="0664", GROUP="plugdev"
    KERNEL=="hidraw*", ATTRS{idVendor}=="3297", MODE="0664", GROUP="plugdev"
    SUBSYSTEM=="usb", ATTR{idVendor}=="3297", GROUP="plugdev"
  '';

  # ============================================================================
  # 7. SYSTEM PACKAGES
  # ============================================================================
  environment.systemPackages = with pkgs; [
    # Development
    git vim neovim zed-editor-fhs vscode-fhs ghostty
    gcc gnumake valgrind nodejs_20 python3
    
    # Browsers
    google-chrome brave
    inputs.zen-browser.packages.${pkgs.system}.default

    # CLI & Utilities
    wget curl fastfetch btop yazi zip unzip wl-clipboard imagemagick
    
    # Apps
    vesktop bitwarden-desktop xournalpp telegram-desktop todoist-electron libreoffice-qt-fresh
    
    # Extra
    protonup-qt polychromatic gnomeExtensions.appindicator
  ];

  # ============================================================================
  # 8. MISC / MAINTENANCE
  # ============================================================================
  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1"; # Force Wayland for Electron/Chrome apps
    COSMIC_DATA_CONTROL_ENABLED = "1";
  };

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 30d";
  };

  system.stateVersion = "25.05";
}
