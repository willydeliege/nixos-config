{ pkgs, ... }:
{

  home.packages = with pkgs; [
    chafa
    ghostscript
    imagemagick
    libreoffice
    neovim
    mermaid-cli
    tectonic
    unzip
    wttrbar
  ];
  programs.btop.enable = true;
  programs.calibre.enable = true;
  services.kdeconnect = {
    enable = true;
    indicator = true;
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
