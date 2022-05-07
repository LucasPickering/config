{ pkgs, config, ... }: {
  environment.systemPackages = with pkgs; [
    libnotify
    multimc
    runelite
  ];
}
