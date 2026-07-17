# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ pkgs, ... }:

{
  # Activer les fonctionnalités expérimentales (Flakes et commandes Nix modernes)
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];
  # Optimisation et nettoyage automatique du store Nix
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than +10";
  };
  nix.settings.auto-optimise-store = true; # Fusionne les fichiers identiques pour gagner de la place
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Use latest kernel.
  boot.kernelPackages = pkgs.linuxPackages_latest;

  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
    settings = {
      General = {
        # Enables faster connection speeds, though it increases power consumption.
        FastConnectable = true;
        # Optional: Enables battery charge display and other experimental features.
        Experimental = true;
      };
      Policy = {
        # Automatically enables all controllers when found.
        AutoEnable = true;
      };
    };
  };
  # Set your time zone.
  time.timeZone = "Europe/Brussels";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  programs.sway = {
    enable = true;

    package = pkgs.swayfx;
    # Enables GTK integration (portals, environment variables, etc.)
    wrapperFeatures.gtk = true;
  };

  security.polkit.enable = true;

  services.gnome.gnome-keyring.enable = true;
  # Inject PAM module for greetd
  security.pam.services.greetd = {
    enableGnomeKeyring = true;
    text = ''
      auth     substack     login
      account  include      login
      password substack     login
      session  include      login
    '';
  };
  security.pam.services.swaylock = { };

  xdg.portal = {
    enable = true;
    extraPortals = [
      pkgs.xdg-desktop-portal-wlr
      pkgs.xdg-desktop-portal-gtk
    ];
    config.common.default = "*"; # Force l'utilisation des portails disponibles
  };
  qt = {
    enable = true;
    style = "breeze";
  };

  services.greetd = {
    enable = true;
    useTextGreeter = true;

    settings.default_session = {
      user = "greeter";
      command = "${pkgs.tuigreet}/bin/tuigreet --time --remember --cmd sway";
    };
  };
  # Ensure OpenGL is enabled for hardware acceleration
  hardware.graphics.enable = true;

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "fr";
    variant = "us";
    options = "caps:swapescape";
  };

  # Configure console keymap
  console.keyMap = "us";

  # Enable CUPS to print documents.
  services.printing.enable = false;

  # Power managemnt
  services.tlp = {
    enable = true;
    pd.enable = true;
    settings = {
      CPU_SCALING_GOVERNOR_ON_BAT = "powersave";
    };
  };
  # Home row mode
  services.keyd = {
    enable = true;
    keyboards = {
      default = {
        settings = {
          main = {
            a = "lettermod(meta, a, 150, 200)";
            s = "lettermod(alt, s, 150, 200)";
            d = "lettermod(control, d, 150, 200)";
            f = "lettermod(shift, f, 150, 200)";

            j = "lettermod(shift, j, 150, 200)";
            k = "lettermod(control, k, 150, 200)";
            l = "lettermod(alt, l, 150, 200)";
            ";" = "lettermod(meta, semicolon, 150, 200)";
          };
        };
      };
    };
  };
  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
  };

  documentation = {
    enable = true;
    man.cache.enable = true;
    man.enable = true;
    dev.enable = true; # Optionnel : inclut aussi les manuels de développement
  };
  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users."willefi" = {
    isNormalUser = true;
    description = "willefi";
    extraGroups = [
      "networkmanager"
      "wheel"
      "audio"
      "video"
      "input"
    ];
    packages = with pkgs; [
      #  thunderbird
    ];
  };

  networking.firewall = {
    enable = true;
    allowedTCPPorts = [
      # needed by calibre to connect
      8080
      9090
    ];
    allowedUDPPorts = [
      # needed by calibre for discovery
      54982
      48123
      39001
      44044
      59678
    ];
  };
  environment.etc."xdg/kdeglobals".source =
    "${pkgs.kdePackages.breeze}/share/color-schemes/BreezeDark.colors";
  environment.sessionVariables = {
    # Select platform: "wayland", "xcb", or "eglfs"
    QT_QPA_PLATFORM = "wayland";
    # Select theme integration: "qt5ct", "qt6ct", or "kde"
    QT_QPA_PLATFORMTHEME = "xdgdesktopportal";
  };
  programs.zsh.enable = true;
  programs.fzf.fuzzyCompletion = true;
  programs.fzf.keybindings = true;
  users.defaultUserShell = pkgs.zsh;
  environment.shells = [ pkgs.zsh ];
  # Install firefox.
  programs.firefox.enable = false;
  # Ouvrir les ports nécessaires pour KDE Connect
  programs.kdeconnect.enable = true;
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    vimAlias = true;
    viAlias = true;
  };
  programs.git.enable = true;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    # Better less
    bat
    # Terminal
    foot
    # Launcher
    rofi
    # Status bar
    waybar
    # Notifications
    swaynotificationcenter
    libnotify
    # Locking / idle
    # Navigation
    swayr
    swaylock
    swayidle
    # Screenshots
    grim
    slurp
    # Clipboard
    wl-clipboard
    cliphist
    # Brightness
    brightnessctl
    # Eye confort
    wlsunset
    # Audio
    pavucontrol
    playerctl
    # Bluetooth
    blueman
    # File manager
    thunar
    # Network manager
    networkmanagerapplet
    # Useful Wayland tools
    xdg-utils
    # Theme
    nwg-look
    kdePackages.breeze
    kdePackages.breeze-gtk
    kdePackages.qt6ct
    # Vol light on screen
    swayosd
    #  Browser
    brave
    # cli tools
    eza
    fd
    fzf
    ripgrep
    stow
    zoxide
    wget
    jq
    # TUI
    yazi
    lazygit
    # Multiplexer
    tmux
    sesh
    # needed by noviM
    nil
    nixfmt
    lua-language-server
    stylua
    markdown-oxide
    prettier
    tree-sitter
    rustc
    cargo
    gcc
    (python3.withPackages (ps: with ps; [ i3ipc ]))
    nodejs
    emscripten
    pkg-config
    openssl
  ];
  # Enable font directory and packages
  fonts = {
    packages = with pkgs; [
      # Nerd Fonts (packaged individually in recent versions)
      nerd-fonts.fira-code
      nerd-fonts.jetbrains-mono

      # Standard Fonts
      fira-code
      jetbrains-mono

      # Emoji & Symbols
      noto-fonts-color-emoji
      symbola
    ];

    # Configure fontconfig fallbacks so missing glyphs are automatically found
    fontconfig = {
      defaultFonts = {
        emoji = [ "Noto Color Emoji" ];
        monospace = [
          "JetBrainsMono Nerd Font"
          "FiraCode Nerd Font"
          "Noto Color Emoji"
          "Symbola"
        ];
        sansSerif = [
          "DejaVu Sans"
          "Noto Color Emoji"
          "Symbola"
        ];
        serif = [
          "DejaVu Serif"
          "Noto Color Emoji"
          "Symbola"
        ];
      };
    };
  };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

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
  system.stateVersion = "26.05"; # Did you read the comment?

}
