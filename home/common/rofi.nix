{
  pkgs,
  lib,
  ...
}: {
  programs.rofi = {
    enable = true;
    theme = lib.mkDefault "gruvbox-dark-soft";
    plugins = [pkgs.rofi-emoji];
  };
}
