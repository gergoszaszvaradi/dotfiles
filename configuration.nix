{ config, pkgs, ... }:

let
  username = "gergoszaszvaradi";
  dotfilesLocation = "/home/${username}/.dotfiles";
  unstable = import <nixos-unstable> { config.allowUnfree = true; };
  gergoszaszvaradi = import <gergoszaszvaradi> { config.allowUnfree = true; };
  nix-flatpak = fetchGit { url = "https://github.com/gmodena/nix-flatpak.git"; rev = "5e54c3ca05a7c7d968ae1ddeabe01d2a9bc1e177"; };
in
{
  imports =
    [
      "/etc/nixos/hardware-configuration.nix"
      "${nix-flatpak}/modules/nixos.nix"
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelParams = [ "amdgpu.dc=1" ];

  # Networking
  networking.hostName = "nixos";
  networking.networkmanager.enable = true;
  networking.hosts = {
    "192.168.1.3" = [ "wacky" ];
    "192.168.1.4" = [ "3d-printer" ];
  };

  # Remove local documentation
  documentation.nixos.enable = false;

  # Set your time zone.
  time.hardwareClockInLocalTime = true;
  time.timeZone = "Europe/Bucharest";

  # Select internationalisation properties.
  i18n = {
    defaultLocale = "en_GB.UTF-8";
    extraLocaleSettings = {
      LC_ADDRESS = "en_GB.UTF-8";
      LC_IDENTIFICATION = "en_GB.UTF-8";
      LC_MEASUREMENT = "en_GB.UTF-8";
      LC_MONETARY = "en_GB.UTF-8";
      LC_NAME = "en_GB.UTF-8";
      LC_NUMERIC = "en_GB.UTF-8";
      LC_PAPER = "en_GB.UTF-8";
      LC_TELEPHONE = "en_GB.UTF-8";
      LC_TIME = "en_GB.UTF-8";
    };
  };

  # Define the user account.
  users.users.${username} = {
    isNormalUser = true;
    description = username;
    extraGroups = [ "networkmanager" "wheel" "scanner" "lp" ];
    shell = pkgs.zsh;
  };

  # Display manager and desktop environment
  services.xserver = {
    enable = true;
  };
  services.displayManager.ly.enable = true;
  programs.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
  };
  fonts.packages = with pkgs; [
    nerd-fonts.adwaita-mono
    nerd-fonts.caskaydia-cove
  ];
  # services.xserver.videoDrivers = [ "amdgpu" ];

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    wireplumber.enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # Printing
  services.printing = {
    enable = true;
    drivers = (with pkgs; [
      gutenprint
    ]);
  };

  # Xbox Controller
  hardware.xone.enable = true;

  # Logitech devices
  hardware.logitech.wireless.enable = true;

  # Enable podman with docker compatibility
  virtualisation.podman = {
    enable = true;
    dockerCompat = true;
  };

  # Add virt-manager
  virtualisation.libvirtd.enable = true;
  programs.virt-manager.enable = true;

  # Enable ZSH
  programs.zsh = {
    enable = true;
    enableCompletion = false;
  };

  # Add steam
  programs.steam.enable = true;

  # Nautilus open terminal extension
  programs.nautilus-open-any-terminal = {
    enable = true;
    terminal = "ghostty";
  };
  environment = {
    sessionVariables.NAUTILUS_4_EXTENSION_DIR = "${pkgs.nautilus-python}/lib/nautilus/extensions-4";
    pathsToLink = [
      "/share/nautilus-python/extensions"
    ];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Packages
  environment.systemPackages = (with pkgs; [
    # Core
    wget
    git
    gh
    fzf
    ripgrep
    file
    jq
    global

    # Utilities
    solaar
    unrar
    vial
    distrobox
    trufflehog
    raider
    pinta
    eyedropper
    peek
    f3d
    mousai
    ghex
    loupe
    evince
    decibels
    baobab
    libreoffice
    jamesdsp
    zenity
    sway-contrib.grimshot

    # General
    brave
    discord
    spotify
    stremio
    fragments
    audacity
    blender
    gimp
    anydesk
    nautilus
    nautilus-python
    gnome-system-monitor
    unstable.multiviewer-for-f1
    gergoszaszvaradi.mixxx
    vlc

    # GNOME Apps
    gnome-calculator
    gnome-calendar
    gnome-font-viewer
    gnome-logs
    gnome-weather
    gnome-clocks
    file-roller
    simple-scan
    mediawriter

    # Development
    unstable.ghostty
    emacs-gtk
    unstable.zed-editor
    postman
    podman-compose
    gnumake
    libgcc
    clang
    clang-tools
    cmake
    pkg-config
    gdb
    gf
    go
    python3
    nodePackages.nodejs
    lazygit
    arduino

    # Gaming
    wine
    winetricks
    lutris
    parsec-bin
    widevine-cdm
    prismlauncher

    # Sway
    waybar
    wofi
    swaylock-effects
    swaynotificationcenter
    playerctl
    adwaita-icon-theme
  ]);

  # Enable flatpak
  services.flatpak.enable = true;

  # Add flathub and flathub-beta remotes
  services.flatpak.remotes = [
    {
      name = "flathub"; location = "https://flathub.org/repo/flathub.flatpakrepo";
    }
    {
      name = "flathub-beta"; location = "https://flathub.org/beta-repo/flathub-beta.flatpakrepo";
    }
  ];

  # Install flatpak packages
  services.flatpak.packages = [
    "com.github.tchx84.Flatseal"
    "com.mojang.Minecraft"
    "com.ultimaker.cura"
    "io.github.zen_browser.zen"
  ];

  # Update flatpak packages on activation
  services.flatpak.update.onActivation = true;

  services.udev.extraRules = ''KERNEL=="hidraw*", SUBSYSTEM=="hidraw", ATTRS{serial}=="*vial:f64c2b3c*", MODE="0660", GROUP="users", TAG+="uaccess", TAG+="udev-acl"'';

  # Garbage collection
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 7d";
  };

  # Enable auto-upgrade
  system.autoUpgrade = {
    enable = true;
    dates = "18:00";
    randomizedDelaySec = "45min";
  };

  systemd.services = {
    # Symlink configuration files
    dotfiles = {
      enable = true;
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        Type = "oneshot";
        ExecStart = "/bin/sh -c 'shopt -s dotglob; for file in ${dotfilesLocation}/home/*; do FILE_NAME=$(basename \"$file\"); if [ \"$FILE_NAME\" = \".config\" ]; then for dir in $file/*; do if [ -d \"$dir\" ]; then TARGET=\"/home/${username}/.config/$(basename \"$dir\")\"; if [ ! -e \"$TARGET\" ]; then ln -s \"$dir\" \"$TARGET\"; fi; fi; done; else TARGET=\"/home/${username}/$(basename \"$file\")\"; if [ ! -e \"$TARGET\" ]; then ln -s \"$file\" \"$TARGET\"; fi; fi; done'";
      };
    };
    # Fix suspend on Gigabyte motherboard
    suspend = {
      enable = true;
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        Type = "oneshot";
        ExecStart = "/bin/sh -c \"echo GPP0 > /proc/acpi/wakeup && echo XHC0 > /proc/acpi/wakeup\"";
      };
    };
  };

  # system.stateVersion = "24.05"; # original version
  system.stateVersion = "25.05";
}
