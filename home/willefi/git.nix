{ pkgs, ... }:
{
  programs.lazygit = {
    enable = true;
    settings = {
      git.pagers = [
        { pager = "delta --dark --paging=never"; }
      ];
    };
  };

  programs.git = {
    enable = true;
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
  };
}
