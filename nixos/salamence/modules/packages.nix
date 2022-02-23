{ pkgs, lib, config, ... }: {
  nixpkgs.config.allowUnfree = true;
  environment.systemPackages = with pkgs; [
    binutils
    dconf
    file
    htop
    nodejs-16_x
    tree
    wget
    unzip
    vim
    zip
  ];
}
