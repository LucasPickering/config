{ pkgs, config, ... }: {
  environment.systemPackages = with pkgs; [
    multimc
  ];
}
