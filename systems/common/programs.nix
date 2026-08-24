{pkgs, ...}: {
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
  
  services = {
    interception-tools = {
      enable = true;
      plugins = [ pkgs.interception-tools-plugins.caps2esc ];
      udevmonConfig = ''
      - JOB: "intercept -g $DEVNODE | caps2esc | uinput -d $DEVNODE"
        DEVICE:
          EVENTS:
            EV_KEY: [KEY_CAPSLOCK, KEY_ESC]
      '';
    };
  };
}
