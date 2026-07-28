{
  ...
}:
{

  # Set your time zone.
  time.timeZone = "Europe/Brussels";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "fr";
    variant = "us";
    options = "caps:swapescape";
  };

  # Configure console keymap
  console.keyMap = "us";

  # Home row mode
  services.keyd = {
    enable = true;
    keyboards = {
      default = {
        settings = {
          main = {
            a = "lettermod(meta, a, 150, 200)";
            s = "lettermod(alt, s, 150, 200)";
            d = "lettermod(control, d, 150, 200)";
            f = "lettermod(shift, f, 150, 200)";

            j = "lettermod(shift, j, 150, 200)";
            k = "lettermod(control, k, 150, 200)";
            l = "lettermod(alt, l, 150, 200)";
            ";" = "lettermod(meta, semicolon, 150, 200)";
          };
        };
      };
    };
  };
}
