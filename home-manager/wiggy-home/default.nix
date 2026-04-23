{ inputs, pkgs, ... }:
{
  # home.packages = [
  #   inputs.docling.packages.x86_64-linux.default
  # ];

  imports = [
    ./claude.nix
    ./git.nix
    ./programs.nix
    ./zen.nix
  ];
}
