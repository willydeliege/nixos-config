{ config, pkgs, ... }:

{
  home.username = "willefi";
  home.homeDirectory = "/home/willefi";

  home.stateVersion = "26.05"; # or your NixOS release

  programs.home-manager.enable = true;

  home.packages = with pkgs; [
    neovim
    libreoffice-fresh
    unzip
  ];
  programs.alacritty = {
    enable = true;
    settings = {
      window.opacity = 0.95; # Optionnel : légère transparence
      env.TERM = "xterm-256color"; # Informe le système des capacités du terminal
      font = {
        size = 13.0;
        normal = {
          family = "FiraCode Nerd Font";
          style = "Regular";
        };
        bold = {
          family = "FiraCode Nerd Font";
          style = "Bold";
        };
        italic = {
          family = "FiraCode Nerd Font";
          style = "Italic";
        };
      };
      colors = {
        primary = {
          background = "#000000";
          foreground = "#ffffff";
        };
        normal = {
          black = "0x7a828e";
          red = "0xff9492";
          green = "0x26cd4d";
          yellow = "0xf0b72f";
          blue = "0x71b7ff";
          magenta = "0xcb9eff";
          cyan = "0x39c5cf";
          white = "0xd9dee3";
        };
        bright = {
          black = "0x9ea7b3";
          red = "0xffb1af";
          green = "0x4ae168";
          yellow = "0xf7c843";
          blue = "0x91cbff";
          magenta = "0xcb9eff";
          cyan = "0x39c5cf";
          white = "0xd9dee3";
        };
      };
    };
  };
  programs.chromium = {
    enable = true;
    package = pkgs.chromium;
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
  programs.gh.enable = true;
  programs.git.enable = true;
  programs.btop.enable = true;
  programs.calibre.enable = true;
}
