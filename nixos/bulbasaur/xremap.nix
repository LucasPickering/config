{
  inputs.xremap-flake.url = "github:xremap/nix-flake";
  outputs = inputs@{ nixpkgs, ... }: {
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        inputs.xremap-flake.nixosModules.default
        {
          # This configures the service to only run for a specific user
          services.xremap = {
            enable = true;
            serviceMode = "user";
            userName = "lucas";
          };
          # Modmap for single key rebinds
          services.xremap.config.modmap = [
            {
              name = "Global";
              remap = { "CapsLock" = "Esc"; }; # globally remap CapsLock to Esc
            }
          ];
        }
      ];
    };
  };
}
