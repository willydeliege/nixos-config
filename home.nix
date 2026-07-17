{ config, pkgs, ... }:

{
  home.username = "willefi";
  home.homeDirectory = "/home/willefi";

  home.stateVersion = "25.05"; # or your NixOS release

  programs.home-manager.enable = true;

  home.packages = with pkgs; [
    hello
    git
    neovim
  ];
}
