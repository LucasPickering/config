{ pkgs, config, ... }: {
#  imports = [
#    (fetchTarball "https://github.com/msteen/nixos-vscode-server/tarball/master")
#  ];

  services.lorri.enable = true;
#  services.vscode-server.enable = true;
  services.code-server.enable = true;
  home-manager.users.lucas = { programs.direnv.enable = true; };
  virtualisation.docker.enable = true;

  environment.systemPackages = with pkgs; [
    code-server
    docker
    docker-compose
    docker-machine
    git
    python3
    rustup
    tmux
  ];
}
