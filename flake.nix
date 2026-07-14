{
  description = "flake for all systems and home manager";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs";
    nixpkgs-main.url = "github:nixos/nixpkgs/master";
    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    zen-browser.url = "github:0xc000022070/zen-browser-flake";
    treefmt-nix.url = "github:numtide/treefmt-nix";
    sidra.url = "github:wimpysworld/sidra";
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
    overlays = [
      # nixpkgs 26.05 bug: firefoxpwa wrapper touches lib/firefoxpwa/is-packaged-app
      # before creating the directory
      (final: prev: {
        firefoxpwa = prev.firefoxpwa.overrideAttrs (old: {
          buildCommand =
            builtins.replaceStrings
            [''touch "$out/lib/firefoxpwa/is-packaged-app"'']
            [
              ''                mkdir -p "$out/lib/firefoxpwa"
                touch "$out/lib/firefoxpwa/is-packaged-app"''
            ]
            old.buildCommand;
        });
      })
    ];
    pkgsWithUnfree = import nixpkgs {
      inherit system overlays;
      config.allowUnfree = true;
    };
  in {
    formatter.${system} = treefmt-nix.lib.mkWrapper nixpkgs.legacyPackages.${system} ./treefmt.nix;

    nixosConfigurations.big-red-dot = nixpkgs.lib.nixosSystem {
      specialArgs = {
        inherit inputs system;
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
        ./systems/big-red-dot
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
          nixpkgs.overlays =
            overlays
            ++ [
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

    nixosConfigurations.live-iso = nixpkgs.lib.nixosSystem {
      specialArgs = {inherit inputs;};
      modules = [
        "${nixpkgs}/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix"
        ./systems/live-iso
        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.backupFileExtension = "hm-bak";
          home-manager.sharedModules = [./home/common];
          home-manager.extraSpecialArgs = {inherit inputs;};
          home-manager.users.iggy = ./home/iggy;
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
