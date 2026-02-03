{
  nix.extraOptions = ''
    experimental-features = flakes nix-command
  '';

  # Set USB wakeup
  hardware.usb.wakeupDisabled = [
    {
      # Logitech mouse
      vendor = "046d";
      product = "c539";
    }
  ];

  programs.ssh.startAgent = true;
}
