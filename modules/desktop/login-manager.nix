{
  pkgs,
  ...
}:
{
  services.greetd = {
    enable = true;
    useTextGreeter = true; # avoid systemd boot messages interrupt TUI.

    settings.default_session = {
      user = "greeter";
      command = "${pkgs.tuigreet}/bin/tuigreet --time --remember --cmd sway";
    };
  };
}
