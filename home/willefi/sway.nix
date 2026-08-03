{ config, ... }:
{

  # wayland.windowManager.sway = {
  #   enable = false;
  #   config.terminal = "kitty";
  # };
  xdg.configFile."sway".source =
    config.lib.file.mkOutOfStoreSymlink /home/willefi/nixos-config/home/willefi/config/sway;
}
