{pkgs, ...}: let
  brightnessctl = "${pkgs.brightnessctl}/bin/brightnessctl";
  rofi = "${pkgs.rofi}/bin/rofi";
  hyprshot = "${pkgs.hyprshot}/bin/hyprshot";
in {
  wayland.windowManager.hyprland = {
    enable = true;
    settings = {
      monitor = [
        ", preferred, auto, auto"
      ];

      exec-once = [
        "dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP DISPLAY"
        "waybar"
        "mako"
        "systemctl --user start hyprpolkitagent"
        "ibus-daemon -rxRd"
        "hyprpaper"
      ];

      general = {
        gaps_in = 0;
        gaps_out = 0;
        border_size = 1;
      };

      decoration = {
        rounding = 0;
        rounding_power = 0;
      };

      env = [
        "TERMINAL, kitty"
        # "ELECTRON_OZONE_PLATFORM_HINT,wayland"
      ];

      misc = {
        middle_click_paste = false;
        force_default_wallpaper = 1;
        disable_hyprland_logo = true;
      };

      input = {
        kb_layout = "us";
        kb_variant = "";
        kb_model = "";
        kb_options = "";
        kb_rules = "";

        follow_mouse = 1;
        accel_profile = "flat";
        sensitivity = 0;

        touchpad = {
          natural_scroll = true;
          clickfinger_behavior = true;
        };
      };
      device = [
        {
          name = "elan0683:00-04f3:320b-touchpad";
          accel_profile = "adaptive";
        }
      ];

      gesture = [
        "3, horizontal, workspace"
      ];

      "$mod" = "SUPER";
      "$terminal" = "kitty";
      "$filemanager" = "nautilus";
      "$menu" = "rofi -modes \"drun,ssh,filebrowser,window\" -show drun";

      bind =
        [
          # main keybinds
          "$mod, RETURN, exec, $terminal"
          "$mod, W, killactive, "
          "$mod SHIFT, escape, exit, "
          "$mod, E, exec, $filemanager"
          "$mod, V, togglefloating,"
          "$mod, F, fullscreen, 0"
          "$mod, M, fullscreen, 1"
          "$mod, space, exec, $menu"
          "$mod, B, exec, ~/scripts/earbuds_toggle.sh"
          "$mod, Q, exec, kitten quick-access-terminal"
          "$mod, escape, exec, qs -c ~/.config/quickshell/lock/"
          "$mod, PERIOD, exec, rofi -modi emoji -show emoji"

          #workspaces
          # Move focus with mod + arrow keys"
          "$mod, left, movefocus, l"
          "$mod, right, movefocus, r"
          "$mod, up, movefocus, u"
          "$mod, down, movefocus, d"
          # Move focus with mod + shift + vim keybinds"
          "$mod CTRL, H, movefocus, l"
          "$mod CTRL, L, movefocus, r"
          "$mod CTRL, K, movefocus, u"
          "$mod CTRL, J, movefocus, d"
          # Switch workspaces alias
          "$mod, J, workspace, 1"
          "$mod, K, workspace, 2"
          "$mod, L, workspace, 3"
          "$mod, SEMICOLON, workspace, 4"
          "$mod, APOSTROPHE, workspace, 5"
          # Move active window alias
          "$mod SHIFT, J, movetoworkspace, 1"
          "$mod SHIFT, K, movetoworkspace, 2"
          "$mod SHIFT, L, movetoworkspace, 3"
          "$mod SHIFT, SEMICOLON, movetoworkspace, 4"
          "$mod SHIFT, APOSTROPHE, movetoworkspace, 5"
          # Example special workspace (scratchpad)
          "$mod, S, togglespecialworkspace, magic"
          "$mod SHIFT, S, movetoworkspace, special:magic"
          "$mod, P, submap, screenshot"
        ]
        ++ (
          # workspaces
          # binds $mod + [shift +] {1..10} to [move to] workspace {1..10}
          builtins.concatLists (
            builtins.genList (
              x: let
                ws = let
                  c = (x + 1) / 10;
                in
                  builtins.toString (x + 1 - (c * 10));
              in [
                "$mod, ${ws}, workspace, ${toString (x + 1)}"
                "$mod SHIFT, ${ws}, movetoworkspace, ${toString (x + 1)}"
              ]
            )
            10
          )
        );

      bindm = [
        # Move/resize windows with mainMod + LMB/RMB and dragging
        "$mod, mouse:273, resizewindow"
        "$mod, mouse:272, movewindow"
      ];

      bindel = [
        ",XF86AudioRaiseVolume, exec, wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"
        ",XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
        ",XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
        ",XF86AudioMicMute, exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"
        ",XF86MonBrightnessUp, exec, brightnessctl -e4 -n2 set 5%+"
        ",XF86MonBrightnessDown, exec, brightnessctl -e4 -n2 set 5%-"
      ];

      animations = {
        enabled = true;

        bezier = [
          #NAME,           X0,   Y0,   X1,   Y1
          "easeOutQuint,   0.23, 1,    0.32, 1"
          "easeInOutCubic, 0.65, 0.05, 0.36, 1"
          "linear,         0,    0,    1,    1"
          "almostLinear,   0.5,  0.5,  0.75, 1"
          "quick,          0.15, 0,    0.1,  1"
        ];

        animation = [
          "global,        0,   1.5,  default"
          "border,        1,   1.5,  easeOutQuint"
          "windows,       1,   1.5,  easeOutQuint"
          "windowsIn,     1,   1.5,  easeOutQuint, popin 87%"
          "windowsOut,    1,   1.5,  linear,       popin 87%"
          "fadeIn,        0,   1.5,  almostLinear"
          "fadeOut,       0,   1.5,  almostLinear"
          "fade,          1,   1.5,  quick"
          "layers,        1,   1.5,  easeOutQuint"
          "layersIn,      1,   1.5,  easeOutQuint, fade"
          "layersOut,     1,   1.5,  linear,       fade"
          "fadeLayersIn,  1,   1.5,  almostLinear"
          "fadeLayersOut, 1,   1.5,  almostLinear"
          "workspaces,    1,   1.5,  almostLinear, fade"
          "workspacesIn,  1,   1.5,  almostLinear, fade"
          "workspacesOut, 1,   1.5,  almostLinear, fade"
          "zoomFactor,    1,   1.5,  quick"
        ];
      };

      #submaps = {
      #  screenshot = {
      #    settings = {
      #      bind = [
      #        ", C, submap, screenshotCopy"
      #        ", S, submap, screenshotSave"
      #      ];
      #    };
      #    screenshotCopy = {
      #      settings = {
      #        bind = [
      #          ", R, exec, hyprshot -m region --clipboard-only"
      #          ", M, exec, hyprshot -m output --clipboard-only"
      #          ", W, exec, hyprshot -m window --clipboard-only"
      #        ];
      #        submap = "reset";
      #      };
      #    };
      #  };
      #};
    };

    extraConfig = ''
      submap = screenshot
        bind = , escape, submap, reset
        bind = , C, submap, screenshotCopy
        bind = , S, submap, screenshotSave
        submap = screenshotCopy
          bind = , R, exec, hyprshot -m region --clipboard-only
          bind = , M, exec, hyprshot -m output --clipboard-only
          bind = , W, exec, hyprshot -m window --clipboard-only
          bind = , R, submap, reset
          bind = , M, submap, reset
          bind = , W, submap, reset
          bind = , escape, submap, reset
          bind = , escape, exec, hyprctl kill hyprshot
        submap = reset
        submap = screenshotSave
          bind = , R, exec, hyprshot -m region -o ~/Pictures/Screenshots -f "screenshot_$(date +%Y-%m-%d_%H-%M-%S).png"
          bind = , M, exec, hyprshot -m region -o ~/Pictures/Screenshots -f "screenshot_$(date +%Y-%m-%d_%H-%M-%S).png"
          bind = , W, exec, hyprshot -m region -o ~/Pictures/Screenshots -f "screenshot_$(date +%Y-%m-%d_%H-%M-%S).png"
          bind = , R, submap, reset
          bind = , M, submap, reset
          bind = , W, submap, reset
          bind = , escape, submap, reset
          bind = , escape, exec, hyprctl kill hyprshot
        submap = reset
      submap = reset
    '';
  };
}
