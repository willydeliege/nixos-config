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
            a = "lettermod(meta, a, 150, 280)";
            s = "lettermod(alt, s, 150, 280)";
            d = "lettermod(control, d, 150, 280)";
            f = "lettermod(shift, f, 150, 280)";

            j = "lettermod(shift, j, 150, 280)";
            k = "lettermod(control, k, 150, 280)";
            l = "lettermod(alt, l, 150, 280)";
            ";" = "lettermod(meta, semicolon, 150, 280)";
          };
        };
      };
    };
  };
}
