{ pkgs, inputs, ... }:
let 
  system = pkgs.stdenv.hostPlatform.system;

in
{
  home.packages = [
    inputs.claude-desktop.packages.${system}.claude-desktop-with-fhs
  ];

  imports = [
    ./programs.nix
    ./zen.nix
  ];
}
