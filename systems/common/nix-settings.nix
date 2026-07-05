{...}: {
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];
  nix.settings.keep-outputs = true;
  nix.settings.keep-derivations = true;

  nixpkgs.config.allowUnfree = true;

  programs.nh.enable = true;
  programs.nix-ld.enable = true;
}
