{
  description = "crix systems - NixOS + home-manager (flake)";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, ... }@inputs:
    let
      system = "x86_64-linux";

      # 공통 home-manager 통합 모듈 (호스트별 home 파일은 mkHost 인자로 주입)
      hmModule = userHome: {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.backupFileExtension = "hm-backup";
        home-manager.extraSpecialArgs = { inherit inputs; };
        home-manager.users."crix" = import userHome;
      };

      mkHost = { hostModule, userHome }:
        nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = { inherit inputs; };
          modules = [
            hostModule
            home-manager.nixosModules.home-manager
            (hmModule userHome)
          ];
        };
    in {
      nixosConfigurations = {
        columbia = mkHost {
          hostModule = ./hosts/columbia;
          userHome   = ./home/crix/columbia.nix;
        };

        # 골격: hardware-configuration.nix 및 DE 확정 후 완성 필요
        integrity = mkHost {
          hostModule = ./hosts/integrity;
          userHome   = ./home/crix/integrity.nix;
        };

        lakebook = mkHost {
          hostModule = ./hosts/lakebook;
          userHome   = ./home/crix/lakebook.nix;
        };
      };
    };
}
