{
  description = "iggyFlake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
    # nixpkgs-unstable.url = "nixpkgs/nixos-unstable";
    
    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    
    zen-browser.url = "github:0xc000022070/zen-browser-flake";
  };

  outputs =
    { nixpkgs, home-manager, ... }@inputs:
    {
      nixosConfigurations.iggy-laptop = nixpkgs.lib.nixosSystem {
        specialArgs = {
          pkgsRocmCuda = import nixpkgs {
          	system = "x86_64-linux";
          	config = {
          		allowUnfree = true;
          		rocmSupport = true;
          		cudaSupport = true;
          	};
          };
        };
        modules = [
          ./configuration.nix
          home-manager.nixosModules.home-manager
          {
          	home-manager.useGlobalPkgs = true;
          	home-manager.useUserPackages = true;
          	home-manager.sharedModules = [( import ./home-manager/global-home )];
          	home-manager.extraSpecialArgs = { inherit inputs; };
          	home-manager.users.iggy = ./home-manager/iggy-home;
          	home-manager.users.wiggy = ./home-manager/wiggy-home;
          }
        ];
        specialArgs = {
        	inherit inputs;
        };
      };
    };
}
