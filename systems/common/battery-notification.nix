{pkgs, ...}: {
  systemd.user.services."battery-low" = {
    enable = true;
    description = "Notify user if battery is below 10%";
    partOf = ["graphical-session.target"];
    wantedBy = ["graphical-session.target"];
    serviceConfig = {
      Type = "simple";
      ExecStart =
        pkgs.writeShellScript "battery-low-notification"
        ''
          if (( 10 >= $(${pkgs.lib.getExe pkgs.acpi} -b | head -n 1 | ${pkgs.lib.getExe pkgs.ripgrep} -o "\d+%" | ${pkgs.lib.getExe pkgs.ripgrep} -o "\d+")));
          then ${pkgs.lib.getExe pkgs.libnotify} --urgency=critical "low battery" "$(${pkgs.lib.getExe pkgs.acpi} -b | head -n 1 | ${pkgs.lib.getExe pkgs.ripgrep} -o "\d+%")";
          else echo; fi;
        '';
    };
  };
  systemd.user.timers."battery-low" = {
    wantedBy = ["timers.target"];
    timerConfig = {
      # Every Minute
      OnCalendar = "*-*-* *:*:00";
      Unit = "battery-low.service";
    };
  };
}
