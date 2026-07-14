{
  pkgs,
  config,
  ...
}: {
  programs.readline = {
    enable = true;
    extraConfig = "set completion-ignore-case on";
  };

  programs.bash = {
    enable = true;

    shellAliases = config.programs.zsh.shellAliases;

    bashrcExtra = ''
      fff() {
        command fff "$@"
        cd "$(cat "''${XDG_CACHE_HOME:=''${HOME}/.cache}/fff/.fff_d")"
      }
    '';
  };

  programs.zsh = {
    enable = true;

    setOptions = [
      "noautomenu"
    ];

    completionInit = "autoload -Uz compinit && compinit -C";

    # append zshrc
    initContent = ''
      zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
      source ~/.p10k.zsh
      bindkey "^R" history-incremental-search-backward
      unsetopt share_history
    '';

    shellAliases = {
      sudo = "sudo ";
      ssh = "kitten ssh";
      rs = "nh os switch /etc/nixos/";
      srs = "sudo nixos-rebuild switch";
      ls = "eza";
      la = "eza -a";
      li = "eza --icons";
      ll = "eza -lg";
      numlock_toggle = "evemu-event /dev/input/event0 --type EV_KEY --code KEY_NUMLOCK --value 1 --sync; evemu-event /dev/input/event0 --type EV_KEY --code KEY_NUMLOCK --value 0 --sync";
      blackhawk = "ssh bc1054@blackhawk.ece.uah.edu";
      todo = "nvim ~/Documents/todo.md";
      miniparty = "copyparty -q & cloudflared tunnel --url http://127.0.0.1:3923 && fg";
      sreboot = "systemctl reboot -i";
      icat = "kitten icat";
      conf = "cd /etc/nixos";
      se = "sudoedit";
      wipedocker = "docker stop $(docker ps -aq); docker system prune -a; docker volume prune -a";
      killalldocker = "docker ps -aq | xargs docker rm -f";
      note = "nvim ~/Documents/Notes/$(date +%F).md";
      notes = "nvim ~/Documents/Notes";
      stress = "stress-ng --cpu 0";
      grip = "grep -i";
      fvf = "fzf --bind 'enter:become(vim {})'";
      ros-humble = "distrobox enter ubuntu-22-04 -- bash -c 'source /opt/ros/humble/setup.bash && exec bash'";
    };

    plugins = [
      {
        name = "powerlevel10k";
        src = pkgs.zsh-powerlevel10k;
        file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
      }
    ];
  };
}
