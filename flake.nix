{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
    }:
    {
      # TODO: a investiguer
      # packages.x86_64-linux.hello = nixpkgs.legacyPackages.x86_64-linux.hello;
      # packages.x86_64-linux.default = self.packages.x86_64-linux.hello;

      nixosConfigurations = {
        nixos = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            ./hardware-configuration.nix
            ./configuration.nix
            ./modules/power-management.nix
            ./modules/audio.nix
            ./modules/documentation.nix
            ./modules/network.nix
            ./modules/user-shell.nix
            ./modules/neovim.nix
            ./modules/keyboard.nix
            ./modules/desktop/sway.nix
            ./modules/desktop/fonts.nix
            ./modules/desktop/login-manager.nix
            ./modules/desktop/graphics.nix
            ./modules/desktop/theme.nix

            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.backupFileExtension = "backup";

              home-manager.users.willefi = import ./home/willefi/home-willefi.nix;
            }
          ];
        };
      };
    };
}
