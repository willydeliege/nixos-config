{ pkgs, ... }:
{

  home.packages = with pkgs; [
    neovim
    libreoffice-qt6-fresh
    unzip
    imagemagick
    ghostscript
    mermaid-cli
    tectonic
    ungoogled-chromium
  ];
  programs.chromium = {
    enable = true;
    package = pkgs.ungoogled-chromium;
  };
  programs.btop.enable = true;
  programs.calibre.enable = true;
}
