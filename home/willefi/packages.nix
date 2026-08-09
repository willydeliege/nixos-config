{ pkgs, ... }:
{

  home.packages = with pkgs; [
    ungoogled-chromium
    chafa
    ghostscript
    imagemagick
    libreoffice-qt6-fresh
    neovim
    mermaid-cli
    tectonic
    unzip
    wttrbar
  ];
  programs.btop.enable = true;
  programs.calibre.enable = true;
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
