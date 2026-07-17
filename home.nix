{ config, pkgs, ... }:

{
  home.username = "willefi";
  home.homeDirectory = "/home/willefi";

  home.stateVersion = "26.05"; # or your NixOS release

  programs.home-manager.enable = true;

  home.packages = with pkgs; [
    neovim
    unzip
  ];
  programs.freetube = {
    enable = true;
  };
  programs.gh.enable = true;
  programs.git.enable = true;
  programs.btop.enable = true;
  programs.calibre.enable = true;
}
