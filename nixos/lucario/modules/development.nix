{ pkgs, config, ... }: {
  services.lorri.enable = true;

  home-manager.users.lucas = { programs.direnv.enable = true; };
  virtualisation.docker.enable = true;

  environment.systemPackages = with pkgs; [
    docker
    docker-compose
    gcc
    git
    python3
    rustup
    vscode
  ];
}
