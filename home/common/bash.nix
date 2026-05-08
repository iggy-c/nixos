{...}: {
  programs.readline = {
    enable = true;
    extraConfig = "set completion-ignore-case on";
  };

  programs.bash = {
    enable = true;
    shellAliases = {
      sudo = "sudo ";
      ssh = "kitten ssh";
      rs = "nh os switch /etc/nixos/";
      srs = "sudo nixos-rebuild switch";
      ls = "eza";
      la = "eza -a";
      li = "eza --icons";
      ll = "eza -l";
      numlock_toggle = "evemu-event /dev/input/event0 --type EV_KEY --code KEY_NUMLOCK --value 1 --sync; evemu-event /dev/input/event0 --type EV_KEY --code KEY_NUMLOCK --value 0 --sync";
      blackhawk = "ssh bc1054@blackhawk.ece.uah.edu";
      todo = "nvim ~/Documents/todo.md";
      miniparty = "copyparty -q & cloudflared tunnel --url http://127.0.0.1:3923 && fg";
      sreboot = "systemctl reboot -i";
      icat = "kitten icat";
      config = "cd /etc/nixos";
      se = "sudoedit";
      wipedocker = "docker stop $(docker ps -aq); docker system prune -a; docker volume prune -a";
      killalldocker = "docker ps -aq | xargs docker rm -f";
      note = "nvim ~/Documents/notes/$(date +%F).md";
      stress = "stress-ng --cpu 0";
      grip = "grep -i";
    };
    bashrcExtra = ''
      fff() {
        command fff "$@"
        cd "$(cat "''${XDG_CACHE_HOME:=''${HOME}/.cache}/fff/.fff_d")"
      }
    '';
  };
}
