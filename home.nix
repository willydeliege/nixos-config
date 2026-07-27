{ config, pkgs, ... }:

{
  home.username = "willefi";
  home.homeDirectory = "/home/willefi";

  home.stateVersion = "26.05"; # or your NixOS release

  programs.home-manager.enable = true;

  home.packages = with pkgs; [
    neovim
    libreoffice-fresh
    unzip
    imagemagick
    ghostscript
    mermaid-cli
    tectonic
  ];
  home.shell.enableZshIntegration = true;
  programs.tmux = {
    enable = true;

    # Raccourcis et options de base
    mouse = true;
    keyMode = "vi";
    baseIndex = 1;
    escapeTime = 10;
    terminal = "tmux-256color";

    # Plugins gérés proprement par Nix
    plugins = with pkgs.tmuxPlugins; [
      sensible
      resurrect
      tmux-fzf
    ];

    # Tout le reste de tes configurations spécifiques, styles et keybindings
    extraConfig = ''
      # Automatically renumber windows when one is closed
      set -g renumber-windows on

      # Fix nvim lags & colors
      set -ag terminal-overrides ",xterm-256color:RGB"
      set-option -g focus-events on

      #-----------------------------------------------------
      # Yazi integration
      #-----------------------------------------------------
      # Enable terminal graphics passthrough for Yazi image previews
      set -g allow-passthrough on
      # Update tracking environment variables
      set -ga update-environment TERM
      set -ga update-environment TERM_PROGRAM

      #-----------------------------------------------------
      # Status line
      #-----------------------------------------------------
      set-option -g status-position top

      # Change status bar background color when prefix is pressed
      set-option -g status-style "fg=colour136,bg=#{?client_prefix,colour224,colour235}"

      # Customize the left side (Session name)
      set-option -g status-left-length 30
      set-option -g status-left "#[fg=green][#S] #[fg=yellow]| "

      # Customize the right side (Date and Time)
      set-option -g status-right-length 50
      set-option -g status-right "#[fg=orange]%Y-%m-%d #[fg=white]%H:%M:%S"

      # Center the window list
      set-option -g status-justify centre

      # Highlight the active window
      set-window-option -g window-status-current-style fg=brightred,bg=default,bright

      # Change session/window list selection highlight (removes default yellow)
      set-window-option -g mode-style "fg=cyan,bg=default,bold"

      # Change command mode line and messaging colors
      set-option -g message-style "fg=colour136,bg=colour235"

      #-----------------------------------------------------
      # Keybindings
      #-----------------------------------------------------
      # Split vertical (gauche/droite)
      bind \\ split-window -h

      # Split horizontal (haut/bas)
      bind - split-window -v

      # Smart pane switching with awareness of Vim splits.
      vim_pattern='(\S+/)?g?\.?(view|l?n?vim?x?|fzf)(diff)?(-wrapped)?'
      is_vim="ps -o state= -o comm= -t '#{pane_tty}' \
          | grep -iqE '^[^TXZ ]+ +''${vim_pattern}'"

      bind-key -n 'C-h' if-shell "$is_vim" 'send-keys C-h'  'select-pane -L'
      bind-key -n 'C-j' if-shell "$is_vim" 'send-keys C-j'  'select-pane -D'
      bind-key -n 'C-k' if-shell "$is_vim" 'send-keys C-k'  'select-pane -U'
      bind-key -n 'C-l' if-shell "$is_vim" 'send-keys C-l'  'select-pane -R'

      tmux_version='$(tmux -V | sed -En "s/^tmux ([0-9]+(.[0-9]+)?).*/\1/p")'
      if-shell -b '[ "$(echo "$tmux_version < 3.0" | bc)" = 1 ]' \
          "bind-key -n 'C-\\' if-shell \"$is_vim\" 'send-keys C-\\'  'select-pane -l'"
      if-shell -b '[ "$(echo "$tmux_version >= 3.0" | bc)" = 1 ]' \
          "bind-key -n 'C-\\' if-shell \"$is_vim\" 'send-keys C-\\\\'  'select-pane -l'"

      bind-key -T copy-mode-vi 'C-h' select-pane -L
      bind-key -T copy-mode-vi 'C-j' select-pane -D
      bind-key -T copy-mode-vi 'C-k' select-pane -U
      bind-key -T copy-mode-vi 'C-l' select-pane -R
      bind-key -T copy-mode-vi 'C-\' select-pane -l

      # sesh keybinds
      bind-key "J" run-shell "sesh connect \"$( \
        sesh list --icons --hide-duplicates | fzf-tmux -p 80%,70% \
          --no-sort --ansi --border-label ' sesh ' --prompt '⚡  ' \
          --header '  ^a all ^t tmux ^g configs ^x zoxide ^d tmux kill ^f find' \
          --bind 'tab:down,btab:up' \
          --bind 'ctrl-a:change-prompt(⚡  )+reload(sesh list --icons)' \
          --bind 'ctrl-t:change-prompt(🪟  )+reload(sesh list -t --icons)' \
          --bind 'ctrl-g:change-prompt(⚙️  )+reload(sesh list -c --icons)' \
          --bind 'ctrl-x:change-prompt(📁  )+reload(sesh list -z --icons)' \
          --bind 'ctrl-f:change-prompt(🔎  )+reload(fd -H -d 2 -t d -L -E .Trash . ~)' \
          --bind 'ctrl-d:execute(tmux kill-session -t {2..})+change-prompt(⚡  )+reload(sesh list --icons)' \
          --preview-window 'right:55%' \
          --preview 'sesh preview {}' \
      )\""
    '';
  };
  programs.kitty = {
    enable = true;
    shellIntegration.enableZshIntegration = true;
    font = {
      name = "FiraCode Nerd Font";
      size = 13;
    };

    settings = {
      # Configuration de la fenêtre et de l'environnement
      background_opacity = "0.95";
      term = "xterm-256color";

      # Palette de couleurs (Primaire)
      background = "#000000";
      foreground = "#ffffff";

      # Couleurs normales (ansi)
      color0 = "#7a828e"; # black
      color1 = "#ff9492"; # red
      color2 = "#26cd4d"; # green
      color3 = "#f0b72f"; # yellow
      color4 = "#71b7ff"; # blue
      color5 = "#cb9eff"; # magenta
      color6 = "#39c5cf"; # cyan
      color7 = "#d9dee3"; # white

      # Couleurs brillantes (brights)
      color8 = "#9ea7b3"; # black
      color9 = "#ffb1af"; # red
      color10 = "#4ae168"; # green
      color11 = "#f7c843"; # yellow
      color12 = "#91cbff"; # blue
      color13 = "#cb9eff"; # magenta
      color14 = "#39c5cf"; # cyan
      color15 = "#d9dee3"; # white
    };
  };
  programs.chromium = {
    enable = true;
    package = pkgs.ungoogled-chromium;
  };
  programs.freetube = {
    enable = true;
    settings = {
      currentLocale = "fr-FR";
      hideChannelHome = true;
      enableSubtitlesByDefault = true;
      useSponsorBlock = true;
      region = "FR";
      defaultQuality = "360";
      checkForUpdates = false;
    };
  };
  programs.gh.enable = true;
  programs.git.enable = true;
  programs.btop.enable = true;
  programs.calibre.enable = true;
}
