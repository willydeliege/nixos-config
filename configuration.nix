# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ pkgs, ... }:

{
  # NOTE: set to true after finishing config
  security.sudo.wheelNeedsPassword = false;
  # Activer les fonctionnalités expérimentales (Flakes et commandes Nix modernes)
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];
  # Optimisation et nettoyage automatique du store Nix
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than +5";
  };
  nix.settings.auto-optimise-store = true; # Fusionne les fichiers identiques pour gagner de la place

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Use latest kernel
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Do not touch
  system.stateVersion = "26.05";

}
