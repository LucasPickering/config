{ pkgs, config, ... }: {
  services.lorri.enable = true;

  home-manager.users.lucas = { programs.direnv.enable = true; };
  virtualisation.docker.enable = true;

  environment.systemPackages = with pkgs; [
    docker
    docker-compose
    gcc
    git
    google-cloud-sdk
    kubectl
    kubernetes-helm
    python3
    rustup
    terraform
    vscode
  ];
}
