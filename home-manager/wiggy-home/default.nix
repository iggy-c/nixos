{ pkgs, ... }:
{
  imports = [
    ./claude.nix
    ./programs.nix
    ./zen.nix
  ];
}
