{ config, pkgs, lib, ... }: {
  users.mutableUsers = false;

  users.users.lucas = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "audio" "docker" ];
    hashedPassword = lib.fileContents /etc/nixos/secrets/lucas-pass;

    shell = pkgs.fish;
  };

  security.sudo = { enable = true; };

  #home-manager.users.lucas = { xdg.enable = true; };
}
