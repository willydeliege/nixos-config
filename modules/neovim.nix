{ pkgs, ... }:
{

  programs.neovim = {
    enable = true;
    defaultEditor = true;
    vimAlias = true;
    viAlias = true;

  };
  environment.systemPackages = with pkgs; [
    # needed by noviM
    # Language servers
    nil
    lua-language-server
    markdown-oxide
    # Formatters
    stylua
    nixfmt
    prettier
    # treesitters and compilation
    tree-sitter
    rustc
    cargo
    gcc
    nodejs
    emscripten
    pkg-config
    openssl
  ];
}
