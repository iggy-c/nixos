{ ... }:
{

  programs.vesktop = {
    enable = true;
  };
  
  imports = [
    ./programs.nix
    ./vesktop.nix
    ./zen.nix
  ];
  
}
