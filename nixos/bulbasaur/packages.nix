{ pkgs, lib, config, ... }: {
  nixpkgs.config.allowUnfree = true;
  environment.systemPackages = with pkgs; [
    discord
    firefox
    htop
    spotify
    wget
    unzip
    vim
    xclip
    zip

    # Dev tools
    gcc
    ghostty
    git
    jq
    rustup
    zed-editor

    # Games
    runelite
    libnotify # Runelite notifications
  ];
  programs.fish.enable = true;
  programs.steam.enable = true;
}
