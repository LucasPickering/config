{ pkgs, lib, config, ... }: {
  hardware.nvidia.package = config.boot.kernelPackages.nvidiaPackages.legacy_470;

  services.xserver = {
    enable = true;
    videoDrivers = [ "nvidia" ];

    desktopManager.plasma5.enable = true;
    displayManager.sddm.enable = true;
    desktopManager.xterm.enable = false;
  };
}
