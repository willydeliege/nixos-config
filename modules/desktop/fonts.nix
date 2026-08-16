{ pkgs, ... }: {

  # Enable font directory and packages
  fonts = {
    packages = with pkgs; [
      # Nerd Fonts (packaged individually in recent versions)
      nerd-fonts.fira-code
      nerd-fonts.jetbrains-mono

      # Standard Fonts
      fira-code
      # NOTE: broken
      # jetbrains-mono

      # Emoji & Symbols
      noto-fonts-color-emoji
      symbola
      font-awesome
    ];

    # Configure fontconfig fallbacks so missing glyphs are automatically found
    fontconfig = {
      defaultFonts = {
        emoji = [ "Noto Color Emoji" ];
        monospace = [
          "JetBrainsMono Nerd Font"
          "FiraCode Nerd Font"
          "Noto Color Emoji"
          "Symbola"
        ];
        sansSerif = [
          "DejaVu Sans"
          "Noto Color Emoji"
          "Symbola"
        ];
        serif = [
          "DejaVu Serif"
          "Noto Color Emoji"
          "Symbola"
        ];
      };
    };
  };

}
