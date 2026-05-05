{ inputs, pkgs, ... }:
{
  imports = [
    ./claude.nix
    ./git.nix
    ./programs.nix
    ./zen.nix
  ];
}
