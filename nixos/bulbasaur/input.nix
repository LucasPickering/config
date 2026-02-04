{
  # Remap keys
  services.keyd = {
    enable = true;
    keyboards = {
      default = {
        # Device info from `lsusb`
        ids = [ "4355:0081" ];
        settings = {
          main = {
            capslock = "esc";
          };
        };
      };
    };
  };

  # Set USB wakeup
  # Device info from `lsusb`
  hardware.usb.wakeupDisabled = [
    {
      # Logitech mouse
      vendor = "046d";
      product = "c539";
    }
  ];
}
