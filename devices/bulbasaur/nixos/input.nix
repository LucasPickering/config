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
            # Cmd key triggers the cmd layer for MacOS bindings
            # keyd doesn't respect the alt<->meta swap from the DE,
            # so this is on alt instead
            # leftalt = "layer(cmd)";
            rightalt = "layer(cmd)";
          };

          "cmd:C" = {
            a = "C-a"; # Select all
            c = "C-c"; # Copy
            v = "C-v"; # Paste
            x = "C-x"; # Cut
            z = "C-z"; # Undo
            s = "C-s"; # Save
            f = "C-f"; # Find
            w = "C-w"; # Close tab
            t = "C-t"; # New tab
            q = "C-q"; # Quit
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
