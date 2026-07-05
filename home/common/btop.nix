{...}: {
  programs.btop = {
    enable = true;
    settings = {
      color_theme = "gruvbox_material_dark";
      theme_background = false;
      vim_keys = true;
      rounded_corners = false;
      update_ms = 100;
    };
  };
}
