{
  pkgs,
  lib,
  ...
}: let
  font-name = "FiraCode Nerd Font Mono";
  font-pkg = pkgs.fira;
in {
  programs.kitty = {
    enable = true;
    themeFile = lib.mkDefault "gruvbox-dark";
    shellIntegration.enableBashIntegration = true;
    shellIntegration.enableZshIntegration = true;
    settings = {
      confirm_os_window_close = lib.mkDefault (-1);
    };
    font.package = font-pkg;
    font.name = font-name;
    font.size = lib.mkDefault 12;
    quickAccessTerminalConfig = {
      lines = lib.mkDefault 5;
      background_opacity = lib.mkDefault 0.9;
    };
  };
}
