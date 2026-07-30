{ pkgs, ... }:

{
  home.username = "willefi";
  home.homeDirectory = "/home/willefi";

  home.stateVersion = "26.05"; # or your NixOS release

  programs.home-manager.enable = true;
  imports = [
    ./home/willefi/packages.nix
    ./home/willefi/tmux.nix
    ./home/willefi/kitty.nix
    ./home/willefi/git.nix
  ];
  home.shell.enableZshIntegration = true;
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
