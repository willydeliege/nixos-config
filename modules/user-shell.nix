{ pkgs, ... }: {

  programs.zsh.enable = true;
  programs.fzf.fuzzyCompletion = true;
  programs.fzf.keybindings = true;
  users.defaultUserShell = pkgs.zsh;
  environment.shells = [ pkgs.zsh ];
  programs.nix-index = {
    enable = true;
    enableZshIntegration = true;
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users."willefi" = {
    isNormalUser = true;
    description = "willefi";
    extraGroups = [
      "networkmanager"
      "wheel"
      "audio"
      "video"
      "input"
      "nordvpn"
    ];
    packages = with pkgs; [
      #  thunderbird
      fastfetch
    ];
  };
  environment.systemPackages = with pkgs; [
    # Better less
    bat
    # Terminal
    foot
    alacritty
    # cli tools
    fd
    fzf
    ripgrep
    stow
    wget
    jq
    # TUI
    yazi
    # Multiplexer
    zellij
    sesh
    btop
    # emacs related
    cmake
    gnumake
    go-grip
    graphviz
    pandoc
    shfmt
    shellcheck
  ];
  programs.tmux.enable = true;
  security.wrappers.btop = {
    owner = "root";
    group = "root";
    capabilities = "cap_perfmon+ep";
    source = "${pkgs.btop}/bin/btop";
  };
  programs.zoxide.enable = true;
  programs.java = {
    enable = true;
    # Par défaut, cela installe la version LTS actuelle (ex: openjdk 21)
    # Vous pouvez spécifier une version précise si nécessaire (ex: pkgs.jdk21)
    # package = pkgs.jdk;
  };
}
