{ pkgs, lib, config, ... }: {
  services.openssh.enable = true;
  services.openssh.passwordAuthentication = false;

  networking = {
    hostName = "salamence"; # Define your hostname.
    wireless.enable = false;  # Enables wireless support via wpa_supplicant.
    networkmanager.enable = false;

    # The global useDHCP flag is deprecated, therefore explicitly set to false here.
    # Per-interface useDHCP will be mandatory in the future, so this generated config
    # replicates the default behaviour.
    useDHCP = false;
    interfaces.enp2s0.useDHCP = true;
    interfaces.enp3s0.useDHCP = false;
    interfaces.wlp4s0.useDHCP = false;
  };
}
