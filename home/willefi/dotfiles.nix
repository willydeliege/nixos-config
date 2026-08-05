{ config, ... }:
{
  xdg.configFile."sway".source =
    config.lib.file.mkOutOfStoreSymlink /home/willefi/nixos-config/home/willefi/config/sway;
  xdg.configFile."swaync".source =
    config.lib.file.mkOutOfStoreSymlink /home/willefi/nixos-config/home/willefi/config/swaync;
}
