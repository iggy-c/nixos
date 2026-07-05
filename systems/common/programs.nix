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
}
