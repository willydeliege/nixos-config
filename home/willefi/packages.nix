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
  ];
  programs.gh.enable = true;
  programs.btop.enable = true;
  programs.calibre.enable = true;
}
