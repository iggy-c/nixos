{lib, ...}: {
  imports =
    builtins.map (n: ./. + "/${n}")
    (builtins.filter
      (n: n != "default.nix" && builtins.match ".*\\.nix" n != null)
      (builtins.attrNames (builtins.readDir ./.)));

  home = {
    username = "iggy";
    homeDirectory = "/home/iggy";
    stateVersion = "26.05";
  };

  home.activation.createIggyDirs = lib.hm.dag.entryAfter ["writeBoundary"] ''
    mkdir -p $HOME/school $HOME/distrobox
  '';

  home.activation.createUbuntuDistrobox = lib.hm.dag.entryAfter ["writeBoundary"] ''
    distrobox list 2>/dev/null | grep -q "ubuntu" || \
      { $DRY_RUN_CMD distrobox create --name ubuntu --image ubuntu:24.04 --yes || true; }
  '';
}
