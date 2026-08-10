{ config, ... }:
{

  xdg.configFile."sway".source =
    config.lib.file.mkOutOfStoreSymlink /home/willefi/nixos-config/home/willefi/config/sway;
  xdg.configFile."swaync".source =
    config.lib.file.mkOutOfStoreSymlink /home/willefi/nixos-config/home/willefi/config/swaync;
  xdg.configFile."waybar".source =
    config.lib.file.mkOutOfStoreSymlink /home/willefi/nixos-config/home/willefi/config/waybar;
  xdg.configFile."sesh".source =
    config.lib.file.mkOutOfStoreSymlink /home/willefi/nixos-config/home/willefi/config/sesh;
  xdg.configFile."nvim".source =
    config.lib.file.mkOutOfStoreSymlink /home/willefi/nixos-config/home/willefi/config/nvim;

}
