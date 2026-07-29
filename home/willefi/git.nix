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
    delta = {
      enable = true;
      options = {
        navigate = true;
        line-numbers = true;
        # Active la mise en valeur précise des caractères modifiés
        word-diff = true;
      };
    };
  };
}
