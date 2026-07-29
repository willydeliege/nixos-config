{ pkgs, ... }: {

  programs.zsh.enable = true;
  programs.fzf.fuzzyCompletion = true;
  programs.fzf.keybindings = true;
  users.defaultUserShell = pkgs.zsh;
  environment.shells = [ pkgs.zsh ];

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
    eza
    fd
    fzf
    ripgrep
    stow
    zoxide
    wget
    jq
    # TUI
    yazi
    # Multiplexer
    zellij
    sesh
    btop
  ];
  programs.tmux.enable = true;
  security.wrappers.btop = {
    owner = "root";
    group = "root";
    capabilities = "cap_perfmon+ep";
    source = "${pkgs.btop}/bin/btop";
  };
}
