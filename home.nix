{ pkgs, ... }:

{
  home.username = "willefi";
  home.homeDirectory = "/home/willefi";

  home.stateVersion = "26.05"; # or your NixOS release

  programs.home-manager.enable = true;
  imports = [
    ./home/willefi/packages.nix
    ./home/willefi/tmux.nix
  ];

  home.shell.enableZshIntegration = true;
  programs.kitty = {
    enable = true;
    shellIntegration.enableZshIntegration = true;
    font = {
      name = "FiraCode Nerd Font";
      size = 13;
    };

    settings = {
      # Configuration de la fenêtre et de l'environnement
      background_opacity = "0.95";
      term = "xterm-256color";

      # Palette de couleurs (Primaire)
      background = "#000000";
      foreground = "#ffffff";

      # Couleurs normales (ansi)
      color0 = "#7a828e"; # black
      color1 = "#ff9492"; # red
      color2 = "#26cd4d"; # green
      color3 = "#f0b72f"; # yellow
      color4 = "#71b7ff"; # blue
      color5 = "#cb9eff"; # magenta
      color6 = "#39c5cf"; # cyan
      color7 = "#d9dee3"; # white

      # Couleurs brillantes (brights)
      color8 = "#9ea7b3"; # black
      color9 = "#ffb1af"; # red
      color10 = "#4ae168"; # green
      color11 = "#f7c843"; # yellow
      color12 = "#91cbff"; # blue
      color13 = "#cb9eff"; # magenta
      color14 = "#39c5cf"; # cyan
      color15 = "#d9dee3"; # white
    };
  };
  programs.chromium = {
    enable = true;
    package = pkgs.ungoogled-chromium;
  };
  programs.freetube = {
    enable = true;
    settings = {
      currentLocale = "fr-FR";
      hideChannelHome = true;
      enableSubtitlesByDefault = true;
      useSponsorBlock = true;
      region = "FR";
      defaultQuality = "360";
      checkForUpdates = false;
    };
  };
}
