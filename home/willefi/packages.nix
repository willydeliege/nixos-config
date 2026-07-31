{ pkgs, ... }:
{

  home.packages = with pkgs; [
    ghostscript
    imagemagick
    libreoffice-qt6-fresh
    neovim
    mermaid-cli
    tectonic
    ungoogled-chromium
    unzip
    wttrbar
  ];
  programs.chromium = {
    enable = true;
    package = pkgs.ungoogled-chromium;
  };
  programs.btop.enable = true;
  programs.calibre.enable = true;
}
