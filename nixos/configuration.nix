{ config, pkgs, inputs, ... }:

{
  nix.settings.experimental-features = [ "nix-command" "flakes"];

   # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Use latest kernel.
  boot.kernelPackages = pkgs.linuxPackages_latest;

# List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = [
    pkgs.yazi
    pkgs.vim
    pkgs.wget
    pkgs.curl
    pkgs.git
    pkgs.fastfetch
    pkgs.telegram-desktop
    pkgs.wl-clipboard
    pkgs.zoxide
    pkgs.eza
    pkgs.nodejs_20
    pkgs.python3
    pkgs.gcc
    pkgs.zoom-us
    # pkgs.mako
    pkgs.rofi
    pkgs.libnotify
    pkgs.todoist-electron
    pkgs.btop
    pkgs.vimix-cursors
    pkgs.swayosd
    pkgs.waybar
    pkgs.kanshi
    pkgs.vesktop
    pkgs.ghostty
    pkgs.neovim
    pkgs.zed-editor
    pkgs.protonup-qt
    pkgs.brave
    pkgs.spotify
    pkgs.mesa
    pkgs.hyprlock
    pkgs.hypridle
    pkgs.swww
    pkgs.hyprshot
    pkgs.pavucontrol
    pkgs.kdePackages.dolphin
    pkgs.networkmanagerapplet
    pkgs.wlogout
    pkgs.playerctl
    pkgs.swaynotificationcenter
    pkgs.blueman
    inputs.zen-browser.packages.${pkgs.system}.default
  ];
  # Brave/chromium browsers dont launch without this
  programs.chromium.enable = true;

  programs.steam.enable = true;
  programs.fish.enable = true;
  users.users.ztzy.shell = pkgs.fish;

  # Hyprland!! shoutout vaxry thats the GOAT
  programs.hyprland = {
    enable = true; 
    xwayland.enable = true;
    # only add nvidiaPatches if needed
    # nvidiaPatches = true;
  };

  environment.sessionVariables = {
    # If your cursor becoms inivisble
    # WLR_NO_HARDWARE_CURSORS = "1";
    # Hint electron apps to use wayland
    NIXOS_OZONE_WL = "1";
  };

  hardware.graphics = {
    enable = true;
    # nvidia.modesetting.enable = true;
  };

      # Enable the XDG portal service
    xdg.portal = {
      enable = true;

      extraPortals = with pkgs; [
        xdg-desktop-portal-gtk
      ];
    };
  
	# Garbage collection
  nix.gc = {
		automatic = true;
		dates = "weekly";
		options = "--delete-older-than 30d";
	};

  # programs.firefox.enable = true;

  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
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

  systemd.services.battery-charge-threshold = {
    description = "Battery config";

    script = ''
      echo 85 > /sys/class/power_supply/BAT0/charge_control_end_threshold
      echo 80 > /sys/class/power_supply/BAT0/charge_control_start_threshold
    '';
    wantedBy = [ "multi-user.target" ];
    serviceConfig.Type = "oneshot";
  };

  # Enable the X11 windowing system.
  # You can disable this if you're only using the Wayland session.
  # services.xserver.enable = true;

  # Bluetooth
  services.blueman.enable = true;

  # Enable the KDE Plasma Desktop Environment.
  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
  };

  services.desktopManager.plasma6.enable = false;
  services.power-profiles-daemon.enable = true;

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.ztzy = {
    isNormalUser = true;
    description = "Marcus";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
    #  thunderbird
    ];
  };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
   programs.gnupg.agent = {
     enable = true;
     enableSSHSupport = true;
   };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.05"; # Did you read the comment?

}
