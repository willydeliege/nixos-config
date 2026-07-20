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
  programs.chromium.enable = true;
  programs.freetube = {
    enable = true;
    settings = {
      currentLocale = "fr-FR";
      hideChannelHome = true;
      enableSubtitlesByDefault = true;
      useSponsorBlock = true;
      region = "FR";
      defaultQuality = "360";
    };
  };
  programs.gh.enable = true;
  programs.git.enable = true;
  programs.btop.enable = true;
  programs.calibre.enable = true;
}
