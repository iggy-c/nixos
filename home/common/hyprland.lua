-- @placeholder@ strings get subbed by default.nix


-- compositor settings

hl.config({
    general = {
        gaps_in = 0,
        gaps_out = 0,
        border_size = 1,
    },

    decoration = {
        rounding = 0,
        rounding_power = 0,
    },

    misc = {
        force_default_wallpaper = 1, -- no anime girl
        disable_hyprland_logo = true,
        disable_splash_rendering = true,
        enable_anr_dialog = false, -- no application-not-responding dialog
        middle_click_paste = false,
    },

    -- see https://wiki.hypr.land/Configuring/Layouts/Dwindle-Layout/ for more
    dwindle = {
        preserve_split = false,
        force_split = 2,
        split_width_multiplier = 1.5, -- 16:9
    },

    -- see https://wiki.hypr.land/Configuring/Layouts/Master-Layout/ for more
    master = {
        new_status = "master",
    },

    -- https://wiki.hypr.land/Configuring/Basics/Variables/#input
    input = {
        kb_layout = "us",
        kb_variant = "",
        kb_model = "",
        kb_options = "",
        kb_rules = "",

        follow_mouse = 1,
        accel_profile = "adaptive",
        sensitivity = 0.2,

        touchpad = {
            natural_scroll = true,
            clickfinger_behavior = true,
            tap_to_click = true,
            disable_while_typing = false,
        },
    },

    animations = {
        enabled = true,
    },
})

-- bezier curves

hl.curve("specialWorkSwitch", { type = "bezier", points = { { 0.05, 0.5 }, { 0.1, 1 } } })
hl.curve("emphasizedAccel", { type = "bezier", points = { { 0.3, 0 }, { 0.5, 0.15 } } })
hl.curve("emphasizedDecel", { type = "bezier", points = { { 0.05, 0.5 }, { 0.1, 1 } } })
hl.curve("standard", { type = "bezier", points = { { 0.2, 0 }, { 0, 1 } } })

-- animations

hl.animation({ leaf = "layersIn", enabled = true, speed = 1, bezier = "emphasizedDecel" })
hl.animation({ leaf = "layersOut", enabled = true, speed = 1, bezier = "emphasizedAccel" })
hl.animation({ leaf = "fadeLayers", enabled = true, speed = 1, bezier = "standard" })
hl.animation({ leaf = "windowsIn", enabled = true, speed = 1, bezier = "emphasizedDecel" })
hl.animation({ leaf = "windowsOut", enabled = true, speed = 1, bezier = "emphasizedAccel" })
hl.animation({ leaf = "windowsMove", enabled = true, speed = 1, bezier = "standard" })
hl.animation({ leaf = "workspaces", enabled = true, speed = 1, bezier = "standard" })
hl.animation({
    leaf = "specialWorkspace",
    enabled = false,
    speed = 0,
    bezier = "specialWorkSwitch"
})
hl.animation({ leaf = "fade", enabled = true, speed = 1, bezier = "standard" })
hl.animation({ leaf = "fadeDim", enabled = true, speed = 1, bezier = "standard" })
hl.animation({ leaf = "border", enabled = true, speed = 1, bezier = "standard" })

-- monitor / env / windowrule

-- default monitor configuration; overridden per-host
hl.monitor({ output = "", mode = "preferred", position = "auto", scale = 1 })

-- makes some electron apps work a bit better
hl.env("ELECTRON_OZONE_PLATFORM_HINT", "wayland")

-- see https://wiki.hypr.land/Configuring/Basics/Window-Rules/ for more
hl.window_rule({ match = { class = ".*" }, suppress_event = "maximize" })
-- fix some dragging issues with xwayland
hl.window_rule({
    match = {
        class = "^$",
        title = "^$",
        xwayland = true,
        float = true,
        fullscreen = false,
        pin = false,
    },
    no_focus = true,
})

-- devices

-- keybinds
-- See https://wiki.hypr.land/Configuring/Basics/Binds/ for more

hl.bind("SUPER + RETURN", hl.dsp.exec_cmd("kitty"))
hl.bind("SUPER + SPACE", hl.dsp.exec_cmd("rofi -modes \"drun,ssh,window\" -show drun"))
hl.bind("SUPER + E", hl.dsp.exec_cmd("nautilus"))
hl.bind("SUPER + PERIOD", hl.dsp.exec_cmd("rofi -modi emoji -show emoji"))
hl.bind("SUPER + Q", hl.dsp.exec_cmd("kitten quick-access-terminal"))
hl.bind("SUPER + B", hl.dsp.exec_cmd("~/scripts/earbuds_toggle.sh"))
hl.bind("SUPER + ESCAPE", hl.dsp.exec_cmd("hyprlock --grace 0"))
hl.bind("SUPER + SHIFT + ESCAPE", hl.dsp.exit())

hl.bind("SUPER + W", hl.dsp.window.close())
hl.bind("SUPER + S", hl.dsp.workspace.toggle_special("S"))
hl.bind("SUPER + SHIFT + S", hl.dsp.window.move({ workspace = "special:S" }))
hl.bind("SUPER + V", hl.dsp.window.float({ action = "toggle" }))
hl.bind("SUPER + M", hl.dsp.window.fullscreen({ mode = "maximized" }))
hl.bind("SUPER + F", hl.dsp.window.fullscreen({ mode = "fullscreen" }))

-- move focus with super + arrow keys
hl.bind("SUPER + left", hl.dsp.focus({ direction = "left" }))
hl.bind("SUPER + down", hl.dsp.focus({ direction = "down" }))
hl.bind("SUPER + up", hl.dsp.focus({ direction = "up" }))
hl.bind("SUPER + right", hl.dsp.focus({ direction = "right" }))

-- hl.bind("SUPER + mouse_up", hl.dsp.focus({ workspace = "-1" }))
-- hl.bind("SUPER + mouse_down", hl.dsp.focus({ workspace = "+1" }))

hl.gesture({
    fingers = 3,
    direction = "right",
    action = function()
        hl.dispatch(hl.dsp.focus({ workspace = "r-1" }))
    end
})
hl.gesture({
    fingers = 3,
    direction = "left",
    action = function()
        hl.dispatch(hl.dsp.focus({ workspace = "r+1" }))
    end,
})
hl.gesture({
    fingers = 3,
    direction = "up",
    action = function()
        if hl.get_active_special_workspace() then
            hl.dispatch(hl.dsp.workspace.toggle_special("S"))
        else
            local win = hl.get_active_window()
            if not (win and win.fullscreen > 0) then
                hl.dispatch(hl.dsp.window.fullscreen({ mode = "maximized" }))
            end
        end
    end,
})
hl.gesture({
    fingers = 3,
    direction = "down",
    action = function()
        local win = hl.get_active_window()
        if win and win.fullscreen > 0 then
            hl.dispatch(hl.dsp.window.fullscreen({ mode = "maximized" }))
        elseif not hl.get_active_special_workspace() then
            hl.dispatch(hl.dsp.workspace.toggle_special("S"))
        end
    end,
})

-- screenshot
hl.bind("SUPER + P", function()
    cmd_base = "hyprshot -m "
    cmd_arg = ""
    cmd_region = ""
    hl.dispatch(hl.dsp.submap("screenshot"))
end)
hl.define_submap("screenshot", function()

    local function try_exec()
        if cmd_arg ~= "" and cmd_region ~= "" then
            hl.exec_cmd(cmd_base .. cmd_region .. " " .. cmd_arg)
            hl.dispatch(hl.dsp.submap("reset"))
        end
    end

    hl.bind("C", function() cmd_arg = "--clipboard-only"; try_exec() end)
    hl.bind("S", function() cmd_arg = "-o ~/Pictures/Screenshots -f \"screenshot_$(date +%Y-%m-%d_%H-%M-%S).png\""; try_exec() end)

    hl.bind("M", function() cmd_region = "output"; try_exec() end)
    hl.bind("W", function() cmd_region = "window"; try_exec() end)
    hl.bind("R", function() cmd_region = "region"; try_exec() end)

    hl.bind("ESCAPE", hl.dsp.submap("reset"))
end)

-- workspaces on JKL;'
hl.bind("SUPER + J", hl.dsp.focus({ workspace = 1 }))
hl.bind("SUPER + K", hl.dsp.focus({ workspace = 2 }))
hl.bind("SUPER + L", hl.dsp.focus({ workspace = 3 }))
hl.bind("SUPER + SEMICOLON", hl.dsp.focus({ workspace = 4 }))
hl.bind("SUPER + APOSTROPHE", hl.dsp.focus({ workspace = 5 }))

hl.bind("SUPER + SHIFT + J", hl.dsp.window.move({ workspace = 1, }))
hl.bind("SUPER + SHIFT + K", hl.dsp.window.move({ workspace = 2, }))
hl.bind("SUPER + SHIFT + L", hl.dsp.window.move({ workspace = 3, }))
hl.bind("SUPER + SHIFT + SEMICOLON",  hl.dsp.window.move({ workspace = 4 }))
hl.bind("SUPER + SHIFT + APOSTROPHE", hl.dsp.window.move({ workspace = 5 }))

-- workspaces 1-10 on SUPER+[1-0], 11-20 on SUPER+ALT+[1-0]
for n = 1, 10 do
    local key = n % 10
    hl.bind("SUPER + " .. key, hl.dsp.focus({ workspace = n }))
    hl.bind("SUPER + SHIFT + " .. key, hl.dsp.window.move({ workspace = n }))
    hl.bind("SUPER + ALT + " .. key, hl.dsp.focus({ workspace = n + 10 }))
    hl.bind("SUPER + ALT + SHIFT + " .. key, hl.dsp.window.move({ workspace = n + 10 }))
end

-- mouse binds
hl.bind("SUPER + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind("SUPER + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- multimedia (work when locked)
hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"), { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"), { locked = true })

hl.bind(
    "XF86AudioRaiseVolume",
    hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"),
    { locked = true, repeating = true }
)
hl.bind(
    "XF86AudioLowerVolume",
    hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"),
    { locked = true, repeating = true }
)
hl.bind("XF86AudioMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"), { locked = true })
hl.bind("XF86AudioMicMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"), { locked = true })

hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("brightnessctl s 10%+"), { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl s 10%-"), { locked = true, repeating = true })

-- integrated monitor
hl.monitor({ output = "eDP-1", mode = "2880x1800", position = "0x0", scale = 1.5 })
hl.workspace_rule({ workspace = "1", monitor = "eDP-1", default = true, persistent = true })
hl.monitor({ output = "", mode = "preferred", position = "auto", scale = 1 })

-- work monitors
hl.monitor({ output = "desc:Dell Inc. DELL P2722H BML6293", mode = "1920x1080", position = "0x-1080", scale = 1 })
hl.monitor({ output = "desc:Dell Inc. DELL P2722H 9RL6293", mode = "1920x1080", position = "1920x-1080", scale = 1, transform = 3 })

hl.on("hyprland.start", function()
    hl.exec_cmd("qs -c ~/waybar-qs")
    hl.exec_cmd("mako")
    hl.exec_cmd("sleep 0.5; hyprctl hyprpaper wallpaper ',~/Pictures/Wallpapers/current-wallpaper.png'")
end)


