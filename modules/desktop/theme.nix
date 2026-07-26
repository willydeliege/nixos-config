{ pkgs, ... }: {

  qt = {
    enable = true;
    style = "breeze";
  };

  environment.etc."xdg/kdeglobals".source =
    "${pkgs.kdePackages.breeze}/share/color-schemes/BreezeDark.colors";
  environment.sessionVariables = {
    # Select platform: "wayland", "xcb", or "eglfs"
    QT_QPA_PLATFORM = "wayland";
    # Select theme integration: "qt5ct", "qt6ct", or "kde"
    QT_QPA_PLATFORMTHEME = "xdgdesktopportal";
  };

  environment.systemPackages = with pkgs; [

    # Theme
    nwg-look
    kdePackages.breeze
    kdePackages.breeze-gtk
    kdePackages.qt6ct
  ];
}
