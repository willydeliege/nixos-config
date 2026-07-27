{
  pkgs,
  ...
}:

{
  systemd.targets.hybrid-sleep.enable = true;
  services.upower = {
    enable = true;
    percentageLow = 20;
    percentageCritical = 5;
    percentageAction = 3;
    criticalPowerAction = "HybridSleep"; # Options: PowerOff, Hibernate, HybridSleep, Suspend, Ignore
  };
  # Power managemnt
  services.tlp = {
    enable = true;
    # Power profile daemon
    pd.enable = true;
    settings = {
      TLP_AUTO_SWITCH = 2;
      # CPU governor
      CPU_SCALING_GOVERNOR_ON_AC = "performance";
      CPU_SCALING_GOVERNOR_ON_BAT = "powersave";

      # Intel P-state energy/performance policy
      CPU_ENERGY_PERF_POLICY_ON_AC = "performance";
      CPU_ENERGY_PERF_POLICY_ON_BAT = "balance_power";

      # Turbo Boost
      CPU_BOOST_ON_AC = 1;
      CPU_BOOST_ON_BAT = 0;

      # Min/max CPU performance scaling (percent of available range)
      CPU_MIN_PERF_ON_AC = 0;
      CPU_MAX_PERF_ON_AC = 100;
      CPU_MIN_PERF_ON_BAT = 0;
      CPU_MAX_PERF_ON_BAT = 60;

      # PCIe Active State Power Management
      PCIE_ASPM_ON_AC = "performance";
      PCIE_ASPM_ON_BAT = "powersupersave";

      # Runtime power management for PCI(e) devices
      RUNTIME_PM_ON_AC = "on";
      RUNTIME_PM_ON_BAT = "auto";

      # USB autosuspend (exclude your mouse/keyboard/dock if needed)
      USB_AUTOSUSPEND = 1;
      USB_DENYLIST = "8087:0a2b"; # example: exclude a device by vendor:product ID

      # SATA/NVMe link power management
      SATA_LINKPWR_ON_AC = "max_performance";
      SATA_LINKPWR_ON_BAT = "min_power";

      # Audio codec power saving (Realtek ALC on this model)
      SOUND_POWER_SAVE_ON_AC = 0;
      SOUND_POWER_SAVE_ON_BAT = 1;

      # WiFi power saving (Intel wireless card on most 840 G3 units)
      WIFI_PWR_ON_AC = "off";
      WIFI_PWR_ON_BAT = "on";
      # If WiFi drops on battery, change the line above to:
      # WIFI_PWR_ON_BAT = "off";

      # Disk APM level
      DISK_APM_LEVEL_ON_AC = "254 254";
      DISK_APM_LEVEL_ON_BAT = "128 128";

    };
  };

  # Brighness auto change

  # Native systemd services targeting power status events
  systemd.services.brightness-on-ac = {
    description = "Set screen brightness to 80% when on AC power";
    wantedBy = [ "multi-user.target" ];
    after = [ "systemd-udevd.service" ];
    unitConfig.ConditionPathExists = "/sys/class/power_supply/AC/online";
    script = ''
      if [ "$(${pkgs.coreutils}/bin/cat /sys/class/power_supply/AC/online)" = "1" ]; then
        ${pkgs.brightnessctl}/bin/brightnessctl set 80%
      fi
    '';
  };

  systemd.services.brightness-on-bat = {
    description = "Set screen brightness to 30% when on Battery power";
    wantedBy = [ "multi-user.target" ];
    after = [ "systemd-udevd.service" ];
    unitConfig.ConditionPathExists = "/sys/class/power_supply/AC/online";
    script = ''
      if [ "$(${pkgs.coreutils}/bin/cat /sys/class/power_supply/AC/online)" = "0" ]; then
        ${pkgs.brightnessctl}/bin/brightnessctl set 30%
      fi
    '';
  };

  # Hook the systemd actions securely to hardware state changes
  services.udev.packages = [
    (pkgs.writeTextFile {
      name = "brightness-power-rules";
      destination = "/etc/udev/rules.d/99-brightness-power.rules";
      text = ''
        ACTION=="change", SUBSYSTEM=="power_supply", ATTR{online}=="1", RUN+="${pkgs.systemd}/bin/systemctl start brightness-on-ac.service"
        ACTION=="change", SUBSYSTEM=="power_supply", ATTR{online}=="0", RUN+="${pkgs.systemd}/bin/systemctl start brightness-on-bat.service"
      '';
    })
  ];
}
