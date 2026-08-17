{ ... }:

{
  home.username = "willefi";
  home.homeDirectory = "/home/willefi";
  home.stateVersion = "26.05"; # or your NixOS release
  programs.home-manager.enable = true;
  home.sessionVariables = {
    MANPAGER = "sh -c 'col -bx | bat -l man -p'";
    MANROFFOPT = "-c";
  };

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
