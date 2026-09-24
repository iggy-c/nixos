{
  config,
  pkgs,
  lib,
  ...
}: let
  cursor-name = "Bibata-Modern-Ice";
  cursor-pkg = pkgs.bibata-cursors;
  icon-name = "Papirus-Dark";
  icon-pkg = pkgs.papirus-icon-theme;
in {
  home.pointerCursor = {
    enable = true;
    hyprcursor.enable = true;
    gtk.enable = true;
    x11.enable = true;
    package = cursor-pkg;
    name = cursor-name;
    size = lib.mkDefault 24;
  };

  gtk = {
    enable = true;

    cursorTheme = {
      name = cursor-name;
      package = cursor-pkg;
    };

    iconTheme = {
      name = icon-name;
      package = icon-pkg;
    };

    gtk3.extraConfig = {
      "gtk-cursor-theme-name" = cursor-name;
      "gtk-icon-theme-name" = icon-name;
    };

    gtk4.extraConfig = {
      Settings = ''
        gtk-cursor-theme-name=${cursor-name}
        gtk-icon-theme-name=${icon-name}
      '';
    };
  };

  wayland.windowManager.hyprland = {
    enable = true;
    systemd.variables = ["--all"]; # fixes theme in dbus activated apps?
    configType = "lua";
    extraConfig = builtins.readFile ./hyprland.lua;
  };

  services.hyprpaper = {
    enable = true;
    settings = {
      splash = false;
      preload = ["${config.home.homeDirectory}/Pictures/Wallpapers/current-wallpaper.png"];
      wallpaper = [",${config.home.homeDirectory}/Pictures/Wallpapers/current-wallpaper.png"];
    };
  };
}
