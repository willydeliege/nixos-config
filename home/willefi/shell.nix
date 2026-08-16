{
  pkgs,
  ...

}:
{
  home.shell.enableZshIntegration = true;
  programs.zsh = {
    enable = true;
    defaultKeymap = "emacs";
    enableCompletion = true;
    autosuggestion.enable = true;
    fastSyntaxHighlighting.enable = true;
    historySubstringSearch = {
      enable = true;
      searchDownKey = [
        "^N"
      ];
      searchUpKey = [
        "^P"
      ];
    };
    dotDir = "/home/willefi/.config/zsh";

    shellAliases = {
      cat = "bat";
      cl = "clear";
      md = "mkdir -p";
      rmf = "rm -rf";
      df = "df -h";
      up = "sudo nixos-rebuild switch --flake .#nixos";
      zshrc = "source ~/.config/zsh/.zshrc";
    };

    initContent = ''

      # Fuzzy finding completions
      source ${pkgs.zsh-fzf-tab}/share/fzf-tab/fzf-tab.plugin.zsh
      # disable sort when completing `git checkout`
      zstyle ':completion:*:git-checkout:*' sort false
      # set descriptions format to enable group support
      # NOTE: don't use escape sequences (like '%F{red}%d%f') here, fzf-tab will ignore them
      zstyle ':completion:*:descriptions' format '[%d]'
      # set list-colors to enable filename colorizing
      zstyle ':completion:*' list-colors ''${(s.:.)LS_COLORS}
      # force zsh not to show completion menu, which allows fzf-tab to capture the unambiguous prefix
      zstyle ':completion:*' menu no
      # preview directory's content with eza when completing cd
      zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza -1 --color=always $realpath'
      # custom fzf flags
      # NOTE: fzf-tab does not follow FZF_DEFAULT_OPTS by default
      zstyle ':fzf-tab:*' fzf-flags --color=fg:1,fg+:2 --bind=tab:accept
      # switch group using `<` and `>`
      zstyle ':fzf-tab:*' switch-group '<' '>'

      # disable beep
      unsetopt BEEP

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

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
    defaultOptions = [
      "--reverse"
      "--style=full"
    ];
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
}
