{
  description = "iggyFlake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs";
    nixpkgs-main.url = "github:nixos/nixpkgs/master";
    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    zen-browser.url = "github:0xc000022070/zen-browser-flake";
    treefmt-nix.url = "github:numtide/treefmt-nix";

    # work
    claude-desktop.url = "github:k3d3/claude-desktop-linux-flake";
    claude-desktop.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = {
    nixpkgs,
    nixpkgs-unstable,
    nixpkgs-main,
    home-manager,
    treefmt-nix,
    ...
  } @ inputs: let
    system = "x86_64-linux";
    pkgsWithUnfree = import nixpkgs {
      inherit system;
      config.allowUnfree = true;
    };
  in {
    formatter.${system} = treefmt-nix.lib.mkWrapper nixpkgs.legacyPackages.${system} ./treefmt.nix;

    nixosConfigurations.iggy-laptop = nixpkgs.lib.nixosSystem {
      specialArgs = {
        inherit inputs;
        pkgsUnstable = import nixpkgs-unstable {
          inherit system;
          config.allowUnfree = true;
        };
        pkgsMain = import nixpkgs-main {
          inherit system;
          config.allowUnfree = true;
        };
        pkgsRocmCuda = import nixpkgs {
          inherit system;
          config = {
            allowUnfree = true;
            rocmSupport = true;
            cudaSupport = true;
          };
        };
      };
      modules = [
        ./systems/iggy-laptop
        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.backupFileExtension = "hm-bak";
          home-manager.sharedModules = [./home/common];
          home-manager.extraSpecialArgs = {inherit inputs;};
          home-manager.users.iggy = ./home/iggy;
          home-manager.users.wiggy = ./home/wiggy;
        }
        {
          nixpkgs.overlays = [
            (final: prev: {
              quartus-prime-lite-unwrapped = prev.quartus-prime-lite-unwrapped.overrideAttrs (_: {
                version = "20.1.0.711";
                # hashes inline here
              });
            })
          ];
        }
      ];
    };

    homeConfigurations = let
      pkgs = pkgsWithUnfree;
    in {
      "iggy" = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        extraSpecialArgs = {inherit inputs;};
        modules = [
          ./home/common
          ./home/iggy
        ];
      };
      "wiggy" = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        extraSpecialArgs = {inherit inputs;};
        modules = [
          ./home/common
          ./home/wiggy
        ];
      };
    };
  };
}
