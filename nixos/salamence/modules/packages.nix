{ pkgs, lib, config, ... }: {
  nixpkgs.config.allowUnfree = true;
  environment.systemPackages = with pkgs; [
    binutils
    dconf
    file
    htop
    tree
    wget
    unzip
    vim
    zip
  ];
}
