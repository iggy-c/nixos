{...}: {
  imports =
    builtins.map (n: ./. + "/${n}")
    (builtins.filter
      (n: n != "default.nix" && builtins.match ".*\\.nix" n != null)
      (builtins.attrNames (builtins.readDir ./.)));
}
