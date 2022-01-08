{ pkgs, config, ... }: {
  services.lorri.enable = true;

  home-manager.users.lucas = { programs.direnv.enable = true; };

  environment.systemPackages = with pkgs; [
    docker-compose
    git
    python3
    rustup
    vscode
  ];
}
