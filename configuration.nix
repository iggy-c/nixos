{
  config,
  pkgs,
  pkgsRocmCuda,
  pkgsMain,
  ...
}:

{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ./dod.nix
  ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernel.sysctl."kernel.sysrq" = 1;

  boot.extraModulePackages = with config.boot.kernelPackages; [
    v4l2loopback
  ];
  boot.extraModprobeConfig = ''
    options v4l2loopback devices=1 video_nr=1 card_label="OBS Cam" exclusive_caps=1
  '';

  networking.hostName = "iggy-laptop"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  swapDevices = [{
    device = "/swapfile";
    size = 16 * 1024; # 16GB
  }];

  time.timeZone = "America/Chicago";
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  security = {
    polkit.enable = true;
    pam.services.hyprlock.enable = true;
  };

  programs.hyprlock.enable = true;
  
  services = {
    xserver.xkb = {
      layout = "us";
      variant = "";
    };

    xserver.enable = true;
    usbmuxd.enable = true;
    printing.enable = true;
    gvfs.enable = true;
    udisks2.enable = true;
    devmon.enable = true;
    gnome.gnome-keyring.enable = true;
    playerctld.enable = true;
    openssh.enable = true;      
    udev.packages = with pkgs; [
      platformio-core
    ];

    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };

    mpd = {
      enable = true;
      musicDirectory = "${config.users.users.iggy.home}/Music";
      extraConfig = ''
        audio_output {
          type "pipewire"
          name "PipeWire Sound Server"
        }
      '';
    };

    # mute on lid open
    acpid = {
      enable = true;
      lidEventCommands = ''
        export PATH=$PATH:/run/current-system/sw/bin
        wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 0%
        wpctl set-mute @DEFAULT_AUDIO_SINK@ 1
      '';
    };

    displayManager.sddm = {
      enable = true;
      autoNumlock = true;
      theme = "where_is_my_sddm_theme";
      package = pkgs.kdePackages.sddm;
      extraPackages = with pkgs; [
        where-is-my-sddm-theme
	kdePackages.qt5compat
      ];
    };

    pcscd.enable = true;

# disabled until there is a fix for password getting disabled
# https://github.com/NixOS/nixpkgs/issues/171136
#    fprintd = {
#      enable = true;
#      tod = {
#        enable = true;
# driver = pkgs.libfprint-2-tod1-goodix;
#      };
#    };
#  };

  xdg.portal = {
    enable = true;
    extraPortals = [pkgs.xdg-desktop-portal-gtk ];
  };

  programs.nautilus-open-any-terminal = {
    enable = true;
    terminal = "kitty";
  };

  # Power management
  # Disable if devices take long to unsuspend (keyboard, mouse, etc)
  powerManagement.powertop.enable = true;
  services = {
    power-profiles-daemon.enable = false;
    tlp = {
      enable = true;
      settings = {
        CPU_BOOST_ON_AC = 1;
        CPU_BOOST_ON_BAT = 0;
        CPU_SCALING_GOVERNOR_ON_AC = "performance";
        CPU_SCALING_GOVERNOR_ON_BAT = "powersave";
        STOP_CHARGE_THRESH_BAT0 = 80;
      };
    };
  };

  #nvidia shit
  hardware.graphics = {
    enable = true;
  };
  hardware.nvidia = {
    modesetting.enable = true;
    open = true;
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable;

    prime = {
      offload = {
        enable = true;
        enableOffloadCmd = true;
      };

      amdgpuBusId = "PCI:6:0:0";
      nvidiaBusId = "PCI:1:0:0";
    };
  };
  services.xserver.videoDrivers = [
    "modesetting"
    "nvidia"
  ];

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
    settings = {
      General = {
        Experimental = true; # shows battery level
        FastConnectable = true;
      };
      Policy = {
        AutoEnable = true;
      };
    };
  };

  fonts = {
    enableDefaultPackages = true;
    enableGhostscriptFonts = true;
    fontconfig.defaultFonts = {
      serif = [ "Noto Serif" ];
      sansSerif = [ "Noto Sans" ];
      monospace = [ "FiraMono Nerd Font" ];
    };
    packages = with pkgs; [
      nerd-fonts.fira-code
      corefonts
      vista-fonts
    ];
  };

  programs.steam = {
    enable = true;
  };
  hardware.steam-hardware.enable = true;

  # User groups
  users.groups.nixusers = { };
  # User accounts
  users.users = {
    iggy = {
      isNormalUser = true;
      description = "personal account";
      extraGroups = [
        "networkmanager"
        "wheel"
        "docker"
        "libvirtd"
        "nixusers"
        "dialout"
      ];
      packages = with pkgs; [
        gh
        prismlauncher
      ];
    };
    wiggy = {
      isNormalUser = true;
      description = "work account";
      extraGroups = [
        "networkmanager"
        "wheel"
        "docker"
        "libvirtd"
        "nixusers"
        "dialout"
      ];
      packages = with pkgs; [
        pkgsMain.code-cursor
        claude-code
        keepassxc
        dbeaver-bin
        goose-cli
      ];
    };
  };
  nix.settings.trusted-users = [
    "iggy"
    "wiggy"
    "root"
    "@nixusers"
  ];

  programs.firefox = {
    enable = true;
    preferences = {
      "browser.aboutConfig.showWarning" = false;
      "browser.gesture.swipe.left" = "scrollLeft";
      "browser.gesture.swipe.right" = "scrollRight";
      "browser.tabs.inTitlebar" = 0;
      "browser.download.panel.shown" = true;
      "browser.download.autohideButton" = false;
    };
  };
  programs.obs-studio = {
    enable = true;
    enableVirtualCamera = true;
  };

  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };
  environment.sessionVariables.NIXOS_OZONE_WL = "1";
  programs.dwl.enable = true;

  programs.git = {
    enable = true;
    config = {
      user.name = "iggy";
      user.email = "bcus9126@gmail.com";
      init.defaultBranch = "main";
      diff.tool = "vimdiff";
      merge.tool = "vimdiff";
      difftool.prompt = "false";
    };
  };

  programs.starship.enable = true;
  programs.bash.enable = true;
  # programs.bash.blesh.enable = true;
  # programs.zsh.enable = true;

  virtualisation.docker.enable = true;
  # virtualisation.podman.enable = true;
  virtualisation.libvirtd = {
    enable = true;
    qemu.swtpm.enable = true;
  };
  virtualisation.spiceUSBRedirection.enable = true;
  services.spice-vdagentd.enable = true;

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  programs.nh = {
    enable = true;
  };

  # nix ld
  programs.nix-ld = {
    enable = true;
    # libraries = with pkgs; [
    #
    # ]
    # uncomment above when using more packages
    # https://wiki.nixos.org/wiki/Nix-ld
  };

  home-manager = {
    users.iggy =
      { ... }:
      {
        home = {
          username = "iggy";
          homeDirectory = "/home/iggy";
          stateVersion = "25.11";
        };
      };
    users.wiggy =
      { ... }:
      {
        home = {
          username = "wiggy";
          homeDirectory = "/home/wiggy";
          stateVersion = "25.11";
        };
      };
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  services.flatpak.enable = true;

  environment.systemPackages = with pkgs; [

    # terminal tools
    wget
    caligula
    dysk
    pulseaudio
    tree
    evemu
    micro
    fzf
    eza
    lshw
    pkgsRocmCuda.btop
    blahaj
    lavat
    pipes
    cbonsai
    yq
    jq
    bat
    fastfetch
    screen
    nmap
    speedtest-rs
    ncdu
    zip
    unzip
    unrar
    imagemagick
    rename # the perl one
    lazydocker
    socat
    tio
    net-tools
    ripgrep
    silver-searcher
    pwgen
    lsof
    nixfmt-rfc-style
    avrdude
    avrdudess
    libimobiledevice
    usbutils
    can-utils
    acpi
    killall
    bluetui
    wev
    geteduroam
    shellcheck
    fff

    # languages
    python3
    nodejs_22
    clang-tools
    clang
    cargo
    rustup
    bun
    gnumake
    mono
    rust-analyzer
    nil
    gcc

    # desktop environment
    hyprpaper
    waybar
    quickshell
    hyprshot
    hyprpicker
    hypridle
    libnotify
    kdePackages.kio-admin
    kdePackages.systemsettings
    kdePackages.dolphin
    kdePackages.qt6ct
    pavucontrol
    mako
    rofi
    brightnessctl
    bluez
    spice
    wl-clipboard
    linuxKernel.packages.linux_zen.v4l2loopback
    where-is-my-sddm-theme

    # apps
    kdePackages.gwenview
    kdePackages.kdenlive
    kdePackages.okular
    kdePackages.partitionmanager
    kdePackages.kcalc
    inav-configurator
    mission-planner
    libreoffice-qt-fresh
    qdirstat
    gimp
    rivalcfg
    freecad
    kicad
    iverilog
    quartus-prime-lite
    typst
    kitty
    nautilus

    # video
    vlc
    handbrake
    ffmpeg
    
    # sound
    rmpc
    spotify
    audacious

    # virtualisation
    gnome-boxes
    qemu
    quickemu
    virt-manager

    # file sharing
    copyparty
    cloudflared
    localsend
    syncthing
    qbittorrent

    # code editors
    zed-editor
    vscode-fhs

    # communication
    telegram-desktop
    pkgsMain.stoat-desktop

    # dod
    pcsclite
    pcsc-tools
    opensc
    cacert
    omnissa-horizon-client

    # dwl
    wmenu
    foot
  ];

  environment.shellAliases = {
    sudo = "sudo ";
    ssh = "kitten ssh";
    rs = "nh os switch /etc/nixos/";
    # rt = "nixos-rebuild test";
    ls = "eza";
    la = "eza -a";
    li = "eza --icons";
    ll = "eza -l";
    numlock_toggle = ''
      	  evemu-event /dev/input/event0 --type EV_KEY --code KEY_NUMLOCK --value 1 --sync; evemu-event /dev/input/event0 --type EV_KEY --code KEY_NUMLOCK --value 0 --sync
        	'';
    blackhawk = "ssh bc1054@blackhawk.ece.uah.edu";
    todo = "nvim ~/Documents/todo.md";
    miniparty = "copyparty -q & cloudflared tunnel --url http://127.0.0.1:3923 && fg";
    sreboot = "systemctl reboot -i";
    icat = "kitten icat";
    config = "sudoedit /etc/nixos/configuration.nix";
    se = "sudoedit";
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.11"; # Did you read the comment?

}
