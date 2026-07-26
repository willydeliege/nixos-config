{
  pkgs,
  ...
}:
{
  # Ensure OpenGL is enabled for hardware acceleration
  # Enable Hardware Video Acceleration
  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
      intel-vaapi-driver # Specialized video acceleration driver for Skylake (i965)
      libvdpau-va-gl # VDPAU backend wrapper for compatibility
    ];
  };

  # Force the system to use the correct i965 backend driver globally
  environment.variables = {
    LIBVA_DRIVER_NAME = "i965";
  };
}
