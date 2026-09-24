{lib, config, ...}: {
  imports =
    builtins.map (n: ./. + "/${n}")
    (builtins.filter
      (n: n != "default.nix" && builtins.match ".*\\.nix" n != null)
      (builtins.attrNames (builtins.readDir ./.)));

  programs.home-manager.enable = true;

  home.sessionVariables = {
    TERMINAL = lib.mkDefault "kitty";
  };

  # Allows nix-shell -p <unfree-pkg> without NIXPKGS_ALLOW_UNFREE=1
  # Using home.file because useGlobalPkgs = true disables the nixpkgs HM module
  home.file.".config/nixpkgs/config.nix".text = ''
    { allowUnfree = true; }
  '';

  xdg = {
    enable = true;
    userDirs = {
      enable = true;
      createDirectories = true;
    };
  };

  home.activation.createCommonDirs = lib.hm.dag.entryAfter ["writeBoundary"] ''
    mkdir -p $HOME/scripts $HOME/notes
  '';

  # for firenvim
  home.activation.firenvimInstall = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    $DRY_RUN_CMD ${config.programs.neovim.finalPackage}/bin/nvim --headless "+call firenvim#install(0)" +qa
'';
}
