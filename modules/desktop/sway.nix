{ pkgs, ... }:

{
  programs.sway = {
    enable = true;

    package = pkgs.sway;
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
  environment.systemPackages = with pkgs; [
    # Brightness
    brightnessctl
    # File manager
    thunar
    # Network manager
    networkmanagerapplet
    # Useful Wayland tools
    xdg-utils
    # Vol light on screen
    swayosd
    # Eye confort
    wlsunset
    # Audio
    pavucontrol
    playerctl
    # Bluetooth
    blueman
    # Launcher
    rofi
    # Status bar
    waybar
    # Autotiling
    autotiling
    # Notifications
    swaynotificationcenter
    libnotify
    # Navigation
    swayr
    # Locking / idle
    swaylock
    swayidle
    # Screenshots
    grim
    slurp
    # Clipboard
    wl-clipboard
    cliphist

    (python3.withPackages (ps: with ps; [ i3ipc ]))
  ];
}
