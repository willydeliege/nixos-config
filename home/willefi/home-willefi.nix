{ pkgs, ... }:

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
    ./foot.nix
    ./git.nix
    ./browser.nix
    ./dotfiles.nix
    ./shell.nix
    ./swaynotificationcenter.nix
  ];
  services.udiskie = {
    enable = true;
    settings = {
      # workaround for
      # https://github.com/nix-community/home-manager/issues/632
      program_options = {
        # replace with your favorite file manager
        file_manager = "${pkgs.thunar}/bin/thunar";
      };
    };
  };
}
