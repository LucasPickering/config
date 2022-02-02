{ pkgs, lib, config, ... }: {
  nixpkgs.config.allowUnfree = true;
  environment.systemPackages = with pkgs; [
    binutils
    dconf
    discord
    file
    firefox
    guake
    htop
    pavucontrol
    pulseaudio
    runelite
    spotify
    tdesktop # telegram
    tree
    wget
    unzip
    vim
    xclip
    zip
  ];
}