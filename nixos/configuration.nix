{ config, pkgs, ... }:

let
    unstable = import <nixos-unstable> { config.allowUnfree = true; };
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

  # Enable experimental features
  nix.settings.experimental-features = [ "nix-command" ];

  # Remove local documentation
  documentation.nixos.enable = false;

  # Set your time zone.
  time.hardwareClockInLocalTime = true;
  time.timeZone = "Europe/Bucharest";

  # Select internationalisation properties.
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

  # Define the user account.
  users.users.gergoszaszvaradi = {
    isNormalUser = true;
    description = "gergoszaszvaradi";
    extraGroups = [ "networkmanager" "wheel" ];
    shell = pkgs.zsh;
  };

  # Enable the X11 windowing system.
  services.xserver.enable = true;
  services.xserver.excludePackages = [ pkgs.xterm ];

  # Enable the GNOME Desktop Environment.
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;
  services.xserver.displayManager.gdm.wayland = false;
  services.xserver.videoDrivers = [ "amdgpu" ];

  # Remove gnome default applications
  services.gnome.core-utilities.enable = false;
  environment.gnome.excludePackages = [ pkgs.gnome-tour ];

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Enable sound with pipewire.
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    wireplumber.enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # Xbox Controller
  hardware.xone.enable = true;

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

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = (with pkgs; [
    wget
    git
    fzf
    ripgrep
    jq
    global
    anydesk
    lm_sensors
    nautilus
    nautilus-python
    gnome-system-monitor
    unstable.ghostty
    xclip
    emacs-gtk
    stow
    zed-editor
    unrar
    wine
    winetricks
    bottles
    lutris
    parsec-bin
    # inputs.umu.packages.${system}.umu
    widevine-cdm
    unstable.multiviewer-for-f1
    mixxx

    # GNOME extensions
    gnomeExtensions.appindicator
    gnomeExtensions.clipboard-indicator
    gnomeExtensions.custom-hot-corners-extended
    gnomeExtensions.dash-to-panel
    gnomeExtensions.emoji-copy
    gnomeExtensions.random-wallpaper
    gnomeExtensions.vitals

    # Development
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
    yazi
    distrobox

    # Other
    nerdfonts
    trufflehog
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
    "ca.desrt.dconf-editor"
    "com.axosoft.GitKraken"
    "com.brave.Browser"
    "com.discordapp.Discord"
    "com.github.ADBeveridge.Raider"
    "com.github.PintaProject.Pinta"
    "com.github.finefindus.eyedropper"
    "com.github.tchx84.Flatseal"
    "com.mattjakeman.ExtensionManager"
    "com.mojang.Minecraft"
    "com.mongodb.Compass"
    "com.spotify.Client"
    "com.stremio.Stremio"
    "com.ultimaker.cura"
    "com.uploadedlobster.peek"
    "de.haeckerfelix.Fragments"
    "io.github.f3d_app.f3d"
    "io.github.seadve.Mousai"
    "io.github.zen_browser.zen"
    "me.timschneeberger.jdsp4linux"
    "org.audacityteam.Audacity"
    "org.blender.Blender"
    "org.fedoraproject.MediaWriter"
    "org.gimp.GIMP"
    "org.gnome.Calculator"
    "org.gnome.Calendar"
    "org.gnome.Characters"
    "org.gnome.Evince"
    "org.gnome.FileRoller"
    "org.gnome.GHex"
    "org.gnome.Logs"
    "org.gnome.Loupe"
    "org.gnome.Decibels"
    "org.gnome.SimpleScan"
    "org.gnome.TextEditor"
    "org.gnome.Weather"
    "org.gnome.baobab"
    "org.gnome.clocks"
    "org.gnome.font-viewer"
    "org.libreoffice.LibreOffice"
    "org.prismlauncher.PrismLauncher"
  ];

  # Update flatpak packages on activation
  services.flatpak.update.onActivation = true;

  # Garbage collection
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 7d";
  };

  # Enable auto-upgrade
  system.autoUpgrade = {
    enable = true;
    flags = [
      "-I nixos-config=/home/gergoszaszvaradi/.dotfiles/nixos/configuration.nix"
      "--update-input"
      "nixpkgs"
      "-L" # print build logs
    ];
    dates = "18:00";
    randomizedDelaySec = "45min";
  };

  # Fix suspend on Gigabyte motherboard
  systemd.services.suspend = {
    enable = true;
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "/bin/sh -c \"echo GPP0 > /proc/acpi/wakeup && echo XHC0 > /proc/acpi/wakeup\"";
    };
    wantedBy = [ "multi-user.target" ];
  };

  # dconf settings
  programs.dconf = {
    enable = true;
    profiles.user.databases = [
      {
        lockAll = false;
        settings = {
          "org/gnome/shell" = {
            app-picker-layout = "'[]'";
            favorite-apps = "['app.zen_browser.zen.desktop', 'com.mitchellh.ghostty.desktop', 'org.gnome.Nautilus.desktop']";
          };
          "org/gnome/desktop/wm/preferences" = {
            button-layout = "'appmenu:minimize,maximize,close'";
          };
          "org/gnome/desktop/interface" = {
            clock-show-date = true;
            clock-show-seconds = true;
            clock-show-weekday = true;
            color-scheme = "'prefer-dark'";
            enable-hot-corners = false;
          };
          "org/gnome/desktop/app-folders" = {
            folder-children = "'[]'";
          };
          "org/gnome/desktop/peripherals/keyboard" = {
            numlock-state = true;
            remember-numlock-state = true;
          };
          "org/gnome/mutter" = {
            edge-tiling = true;
          };
          "org/gnome/nautilus/preferences" = {
            default-folder-viewer = "'icon-view'";
            migrated-gtk-settings = true;
            search-filter-time-type = "'last_modified'";
          };
          "com/raggesilver/BlackBox" = {
            fill-tabs = true;
            font = "'CaskaydiaCove Nerd Font 11'";
            headerbar-drag-area = true;
            remember-window-size = true;
            terminal-padding = "(uint32 5, uint32 5, uint32 5, uint32 5)";
            theme-dark = "'Japanesque'";
            window-height = "uint32 753";
            window-width = "uint32 1320";
          };
          "com/github/stunkymonkey/nautilus-open-any-terminal" = {
            terminal = "'ghostty'";
          };
          "org/gnome/shell/extensions/appindicator" = {
            legacy-tray-enabled = true;
          };
          "org/gnome/shell/extensions/custom-hot-corners-extended/misc" = {
            panel-menu-enable = false;
          };
          "org/gnome/shell/extensions/custom-hot-corners-extended/monitor-0-bottom-left-0" = {
            action = "'toggle-overview'";
            barrier-size-h = "i 98";
          };
          "org/gnome/shell/extensions/custom-hot-corners-extended/monitor-1-bottom-left-0" = {
            action = "'toggle-overview'";
            barrier-size-h = "i 98";
          };
          "org/gnome/shell/extensions/dash-to-panel" = {
            panel-element-positions-monitors-sync = true;
            panel-anchors = "'{\"0\":\"MIDDLE\",\"1\":\"MIDDLE\"}'";
            panel-element-positions="'{\"0\":[{\"element\":\"showAppsButton\",\"visible\":false,\"position\":\"stackedTL\"},{\"element\":\"activitiesButton\",\"visible\":true,\"position\":\"stackedTL\"},{\"element\":\"leftBox\",\"visible\":true,\"position\":\"stackedTL\"},{\"element\":\"taskbar\",\"visible\":false,\"position\":\"stackedTL\"},{\"element\":\"centerBox\",\"visible\":false,\"position\":\"stackedBR\"},{\"element\":\"dateMenu\",\"visible\":true,\"position\":\"centerMonitor\"},{\"element\":\"rightBox\",\"visible\":true,\"position\":\"stackedBR\"},{\"element\":\"systemMenu\",\"visible\":true,\"position\":\"stackedBR\"},{\"element\":\"desktopButton\",\"visible\":false,\"position\":\"stackedBR\"}],\"1\":[{\"element\":\"showAppsButton\",\"visible\":false,\"position\":\"stackedTL\"},{\"element\":\"activitiesButton\",\"visible\":true,\"position\":\"stackedTL\"},{\"element\":\"leftBox\",\"visible\":true,\"position\":\"stackedTL\"},{\"element\":\"taskbar\",\"visible\":false,\"position\":\"stackedTL\"},{\"element\":\"centerBox\",\"visible\":false,\"position\":\"stackedBR\"},{\"element\":\"dateMenu\",\"visible\":true,\"position\":\"centerMonitor\"},{\"element\":\"rightBox\",\"visible\":true,\"position\":\"stackedBR\"},{\"element\":\"systemMenu\",\"visible\":true,\"position\":\"stackedBR\"},{\"element\":\"desktopButton\",\"visible\":false,\"position\":\"stackedBR\"}]}'";
            panel-positions="'{\"0\":\"TOP\",\"1\":\"TOP\"}'";
            panel-sizes = "'{\"0\":32,\"1\":32}'";
          };
          "org/gnome/shell/extensions/space-iflow-randomwallpaper" = {
            auto-fetch = false;
            change-type = "i 2";
            sources = "['1726986491471']";
            fetch-on-startup = true;
            hide-panel-icon = true;
          };
          "org/gnome/shell/extensions/space-iflow-randomwallpaper/sources/general/1726986491471" = {
            name = "'Wallpapers'";
            type = "i 4";
          };
          "org/gnome/shell/extensions/space-iflow-randomwallpaper/sources/localFolder/1726986491471" = {
            folder = "'/home/gergoszaszvaradi/Pictures/Wallpapers'";
          };
          "org/gnome/shell/extensions/vitals" = {
            hot-sensors="['_processor_usage_', '_memory_usage_', '__temperature_avg__', '_temperature_amdgpu_junction_']";
            show-fan = false;
            show-gpu = true;
            show-network = false;
            show-voltage = false;
          };
        };
      }
    ];
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.05"; # Did you read the comment?
}
