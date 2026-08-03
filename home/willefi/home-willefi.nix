{ pkgs, lib, ... }:

{
  home.username = "willefi";
  home.homeDirectory = "/home/willefi";

  home.stateVersion = "26.05"; # or your NixOS release

  programs.home-manager.enable = true;
  imports = [
    ./packages.nix
    ./tmux.nix
    ./kitty.nix
    ./git.nix
    ./dotfiles.nix
  ];
  home.shell.enableZshIntegration = true;
  programs.fzf.enable = true;
  programs.zsh = {
    enable = true;
    # enableCompletion = true;
    autosuggestion.enable = true;
    fastSyntaxHighlighting.enable = true;
    dotDir = "/home/willefi/.config/zsh";

    plugins = [
      {
        name = "zsh-history-substring-search";
        src = pkgs.zsh-history-substring-search;
        file = "share/zsh-history-substring-search/zsh-history-substring-search.zsh";
      }
      {
        name = "fzf-tab";
        src = pkgs.fetchFromGitHub {
          owner = "Aloxaf";
          repo = "fzf-tab";
          rev = "master";
          sha256 = "sha256-YhTSu0P7mFlVx1zBvbT0jNstkamcZHhPYJHKMAHgyuM=";
        };
        file = "fzf-tab.plugin.zsh";
      }
      {
        name = "fzf-tab-source";
        src = pkgs.fetchFromGitHub {
          owner = "Freed-Wu";
          repo = "fzf-tab-source";
          # Use the latest commit hash or release tag
          rev = "master";
          # Replace this with the actual sha256 hash or leave it empty
          # to let Nix complain and provide the correct hash
          sha256 = "sha256-d7+yKrHp4Vcl5WlQfQ/UMNK5j3wz8Ls168Cuj1LYTgI=";
        };
        # Sourcing the main entry point plugin script
        file = "fzf-tab-source.plugin.zsh";
      }
    ];

    shellAliases = {
      cat = "bat";
      cl = "clear";
      md = "mkdir -p";
      up = "sudo nixos-rebuild switch --flake .#nixos";
      zshrc = "source ~/.config/zsh/.zshrc";
    };

    initContent = ''
      # plugins
      source ${pkgs.zsh-fzf-tab}/share/fzf-tab/fzf-tab.plugin.zsh
      # Bindings historysubstringsearch
      bindkey '^P' history-substring-search-up
      bindkey '^N' history-substring-search-down

      # Config fzf-tab
      zstyle ':completion:*:git-checkout:*' sort false
      zstyle ':completion:*:descriptions' format '[%d]'
      zstyle ':completion:*' menu no
      zstyle ':fzf-tab:*' switch-group ',' '.'
      # sesh
      function sesh-sessions() {
        {
          exec </dev/tty
          exec <&1
          local session
          session=$(sesh list -t -c -z --hide-duplicates | fzf --height 40% --reverse --border-label ' sesh ' --border --prompt '⚡  ')
          zle reset-prompt >/dev/null 2>&1 || true
          [[ -z "$session" ]] && return
          sesh connect $session
        }
      }

      zle -N sesh-sessions
      bindkey -M emacs '\es' sesh-sessions
      bindkey -M vicmd '\es' sesh-sessions
      bindkey -M viins '\es' sesh-sessions
    '';
  };
  programs.starship = {
    enable = true;

    settings = {
      git_status = {
        ahead = "⇡\${count}";
        behind = "⇣\${count}";
        diverged = "⇕⇡\${ahead_count}⇣\${behind_count}";
        untracked = "?\${count}";
        stashed = "\\$\${count}";
        modified = "!\${count}";
        staged = "+\${count}";
        renamed = "»\${count}";
        deleted = "✘\${count}";
        disabled = false;
      };
    };
  };
  programs.eza = {
    enable = true;
    extraOptions = [
      "--group-directories-first"
      "--header"
    ];
    git = true;
    icons = "auto";

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
}
