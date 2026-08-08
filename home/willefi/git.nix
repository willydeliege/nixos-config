{ pkgs, ... }:
{
  programs.git = {
    enable = true;
    # Global Git ignore rules
    ignores = [
      "*.swp"
      ".DS_Store"
    ];

    settings = {
      user = {
        name = "Frédéric Willem";
        email = "frederic.willem@gmail.com";
      };
      # Convenient Git aliases
      aliases = {
        co = "checkout";
        ci = "commit";
        st = "status";
        br = "branch";
      };
      # Advanced or nested Git configurations
      extraConfig = {
        pull = {
          rebase = true;
        };
      };
    };

    userEmail = "frederic.willem@gmail.com";

  };

  programs.lazygit = {
    enable = true;
    settings = {
      git.diffRenderers = [
        { command = "delta --dark --paging=never"; }
      ];
      gui = {
        theme = {
          activeBorderColor = [ "#63F2F1" ];
          inactiveBorderColor = [ "#585273" ];
          optionsTextColor = [ "#D4BFFF" ];
          selectedLineBgColor = [ "#3E3859" ];
          selectedRangeBgColor = [ "#2D2B40" ];
          cherryPickedCommitBgColor = [ "#585273" ];
          cherryPickedCommitFgColor = [ "#91DDFF" ];
          unstagedChangesColor = [ "#F48FB1" ];
          defaultFgColor = [ "#CBE3E7" ];
          searchingActiveBorderColor = [ "#FFE6B3" ];
        };
      };
    };
  };

  # Git diff pager
  programs.delta = {
    enable = true;
    enableGitIntegration = true;
    options = {
      navigate = true;
      line-numbers = true;
      word-diff = true;
    };
  };

  # github-client cli
  programs.gh = {
    enable = true;
    settings = {
      editor = "nvim";
    };
    gitCredentialHelper = {
      enable = true;
      hosts = [
        "https://github.com"
        "https://gist.github.com"
      ];
    };
  };

  services.kdeconnect = {
    enable = true;
    indicator = true;
  };
}
