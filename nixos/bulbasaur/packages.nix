{ pkgs, lib, config, ... }: {
  nixpkgs.config.allowUnfree = true;
  environment.systemPackages = with pkgs; [
    discord
    firefox
    htop
    spotify
    unzip
    usbutils
    vim
    wget
    xclip
    zip

    # Dev tools
    gcc
    ghostty
    git
    git-lfs
    helix
    jq
    mise
    rustup
    watchexec
    zed-editor

    # Games
    runelite
    libnotify # Runelite notifications
  ];
  programs.fish.enable = true;
  programs.steam.enable = true;
}
