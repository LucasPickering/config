{ pkgs, lib, config, ... }: {
  # Enable IP forwarding so we can share internet with the RPi
  boot.kernel.sysctl."net.ipv4.ip_forward" = 1;

  networking = {
    hostName = "lucario"; # Define your hostname.
    wireless.enable = false;  # Enables wireless support via wpa_supplicant.
    networkmanager.enable = false;

    # The global useDHCP flag is deprecated, therefore explicitly set to false here.
    # Per-interface useDHCP will be mandatory in the future, so this generated config
    # replicates the default behaviour.
    useDHCP = false;
    interfaces.enp3s0.useDHCP = true; # Real ethernet
    interfaces.eno1.useDHCP = false; # Not sure what this is
    interfaces.wlp4s0.useDHCP = false; # WiFi
    # RPi USB interface
    interfaces.enp0s20f0u2i1 = {
      useDHCP = false;
      ipv4.addresses = [
        {
          address = "192.168.100.1";
          prefixLength = 24;
        }
      ];
    };

    # Route traffic from the RPi through to the internet
    firewall.extraCommands = "
      iptables -A FORWARD -i enp0s20f0u2 -o enp3s0 -j ACCEPT
      iptables -A FORWARD -i enp3s0 -o enp0s20f0u2 -m state --state ESTABLISHED,RELATED -j ACCEPT
      iptables -t nat -A POSTROUTING -o enp3s0 -j MASQUERADE
    ";
  };
}
