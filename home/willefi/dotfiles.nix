{ config, ... }:
{
  xdg.configFile."sway".source =
    config.lib.file.mkOutOfStoreSymlink /home/willefi/nixos-config/home/willefi/config/sway;
}
