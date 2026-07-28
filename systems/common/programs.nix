{...}: {
  programs = {
    hyprland = {
      enable = true;
      xwayland.enable = true;
    };

    obs-studio = {
      enable = true;
      enableVirtualCamera = true;
    };
  };

  xdg.terminal-exec = {
    enable = true;
    settings.default = ["kitty.desktop"];
  };
}
