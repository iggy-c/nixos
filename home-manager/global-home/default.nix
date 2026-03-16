{ pkgs, ... }:
let
  cursor-name = "Bibata-Modern-Ice";
  cursor-pkg = pkgs.bibata-cursors;
  icon-name = "Papirus-Dark";
  icon-pkg = pkgs.papirus-icon-theme;
  font-name = "FiraCode Nerd Font Mono";
  font-pkg = pkgs.fira;
in
{
  programs.home-manager.enable = true;

  programs.readline = {
    enable = true;
    extraConfig = "set completion-ignore-case on";
  };

  programs.bash.enable = true;

  home.pointerCursor = {
    enable = true;
    hyprcursor.enable = true;
    gtk.enable = true;
    x11.enable = true;
    package = cursor-pkg;
    name = cursor-name;
    size = 24;
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

  # programs.hyprlock = {
  #   enable = true;
  #   settings = {
  #     general = {
  #       hide_cursor = true;
  #       ignore_empty_input = true;
  #     };
  #     animations = {
  #       enabled = true;
  #     };
  #     input-field = {
  #       monitor = "";
  #       size = "20%, 5%";
  #       outline_thickness = 0;
  #       inner_color = "rgba(0, 0, 0, 0)";
  #       font_color = "rgb(FFFFFF)";
  #       fade_on_empty = false;
  #       rounding = 0;
  #
  #       font_family = "";
  #       placeholder_text = "";
  #       fail_text = "";
  #
  #       dots_text_format = "*";
  #       dots_size = 0.8;
  #       dots_spacing = 0.3;
  #
  #       position = "0, 0";
  #       halign = "center";
  #       valign = "center";
  #     };
  #   };
  # };

  programs.kitty = {
    enable = true;
    themeFile = "gruvbox-dark";
    shellIntegration.enableBashIntegration = true;
    settings = {
      confirm_os_window_close = -1;
    };
    font.package = font-pkg;
    font.name = font-name;
    font.size = 12;
    quickAccessTerminalConfig = {
	lines = 5;
	background_opacity = 0.9;
    };
  };

  programs.rofi = {
    enable = true;
    theme = "gruvbox-dark-soft";
  };

  imports = [
    ./neovim.nix
    ./hyprland.nix
  ];
}
