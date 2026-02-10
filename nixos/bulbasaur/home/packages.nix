{ pkgs, lib, config, ... }: {
  nix.package = pkgs.nix;
  nixpkgs.config.allowUnfree = true;
  home.packages = with pkgs; [
    discord
    dua
    firefox
    htop
    keyd
    lm_sensors
    spotify
    tailscale
    unzip
    usbutils
    wget
    xclip
    zip

    # Dev tools
    fish
    gcc
    ghostty
    git
    git-lfs
    helix
    jq
    mise
    perf
    rustup
    watchexec
    zed-editor

    # Games
    libnotify # Runelite notifications
    runelite
    steam
  ];
}
