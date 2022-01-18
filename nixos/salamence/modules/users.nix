{ config, pkgs, lib, ... }: {
  users.mutableUsers = false;

  users.users.root = {
    hashedPassword = "*";
  };
  users.users.lucas = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "docker" ];
    hashedPassword = lib.fileContents /etc/nixos/secrets/lucas-pass;
    shell = pkgs.fish;
  };

  security.sudo = { enable = true; };
}
