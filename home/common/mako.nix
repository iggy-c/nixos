{...}: {
  home.file = {
    ".config/mako/config" = {
      text = ''
        anchor=top-center
        font=monospace 10
        background-color=#282828FF
        text-color=#EBDBB2FF
        max-history=10
        margin=0,0,0
        padding=1
        border-size=2
        border-color=#D74536FF
        border-radius=0
        default-timeout=6000
        group-by=summary
        icons=1

        [grouped]
        format=<b>%s</b>\n%b

        [app-name="Sidra"]
        invisible=1
      '';
      executable = false;
    };
  };
}
