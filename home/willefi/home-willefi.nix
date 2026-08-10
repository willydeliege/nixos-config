{ ... }:

{
  home.username = "willefi";
  home.homeDirectory = "/home/willefi";
  home.stateVersion = "26.05"; # or your NixOS release
  programs.home-manager.enable = true;
  imports = [
    ./packages.nix
    ./tmux.nix
    ./kitty.nix
    ./git.nix
    ./browser.nix
    ./dotfiles.nix
    ./shell.nix
    ./swaynotificationcenter.nix
  ];
}
