{ pkgs, ... }: {
  # Define your hostname.
  networking.hostName = "nixos";
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
    settings = {
      General = {
        # Enables faster connection speeds, though it increases power consumption.
        FastConnectable = true;
        # Optional: Enables battery charge display and other experimental features.
        Experimental = true;
      };
      Policy = {
        # Automatically enables all controllers when found.
        AutoEnable = true;
      };
    };
  };

  networking.firewall = {
    enable = true;
    allowedTCPPorts = [
      # needed by calibre to connect
      8080
      9090
    ];
    allowedUDPPorts = [
      # needed by calibre for discovery
      54982
      48123
      39001
      44044
      59678
    ];
  };
  # Ouvrir les ports nécessaires pour KDE Connect
  programs.kdeconnect.enable = true;
}
