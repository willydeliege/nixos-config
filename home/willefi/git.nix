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

  programs.delta = {
    enable = true;
    enableGitIntegration = true;
    options = {
      navigate = true;
      line-numbers = true;
      word-diff = true;
    };
  };
}
