{ pkgs, lib, config, ... }: {
  nixpkgs.config.allowUnfree = true;
  environment.systemPackages = with pkgs; [
    dconf
    discord
    file
    firefox
    git
    guake
    htop
    kitty
    pavucontrol
    pulseaudio
    runelite
    spotify
    tree
    wget
    vim
    vscode
    xclip
  ];
}
