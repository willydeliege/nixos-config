{ pkgs, ... }:
{
  programs.foot = {
    enable = true;
    server.enable = true;
    # L'intégration du shell (zsh) est activée par défaut avec le module foot de Home Manager
    settings = {
      main = {
        term = "xterm-256color";
        font = "FiraCode Nerd Font:size=13";
        # Opacité de 95% calculée en hexadécimal (0.95 * 255 = 242 -> f2)
        # Format ARGB : f2 (alpha) + 000000 (noir)
      };

      colors-dark = {
        background = "000000";
        foreground = "ffffff";
        # Couleurs normales (ansi)
        regular0 = "7a828e"; # black
        regular1 = "ff9492"; # red
        regular2 = "26cd4d"; # green
        regular3 = "f0b72f"; # yellow
        regular4 = "71b7ff"; # blue
        regular5 = "cb9eff"; # magenta
        regular6 = "39c5cf"; # cyan
        regular7 = "d9dee3"; # white

        # Couleurs brillantes (brights)
        bright0 = "9ea7b3"; # black
        bright1 = "ffb1af"; # red
        bright2 = "4ae168"; # green
        bright3 = "f7c843"; # yellow
        bright4 = "91cbff"; # blue
        bright5 = "cb9eff"; # magenta
        bright6 = "39c5cf"; # cyan
        bright7 = "d9dee3"; # white
      };
    };
  };
}
