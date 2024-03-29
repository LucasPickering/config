{ pkgs, lib, config, ... }: {
  nixpkgs.config.allowUnfree = true;
  environment.systemPackages = with pkgs; [
    binutils
    dconf
    discord
    file
    firefox
    gimp
    guake
    htop
    imagemagick
    pavucontrol
    pulseaudio
    spotify
    tdesktop # telegram
    tree
    wget
    unzip
    vim
    xclip
    zip
  ];
  programs.steam.enable = true;
}
