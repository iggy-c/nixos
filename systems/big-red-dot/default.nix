{
  config,
  pkgs,
  pkgsRocmCuda,
  pkgsUnstable,
  pkgsMain,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
    ./dod.nix
    ../common/default.nix
  ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernel.sysctl."kernel.sysrq" = 1;
  boot.blacklistedKernelModules = ["algif_aead"]; # patch vuln

  boot.extraModulePackages = with config.boot.kernelPackages; [
    v4l2loopback
  ];
  boot.extraModprobeConfig = ''
    options v4l2loopback devices=1 video_nr=1 card_label="OBS Cam" exclusive_caps=1
    install algif_aead /bin/false
  '';
  boot.kernelParams = [
    "resume=/dev/disk/by-uuid/8fe45d08-2438-4caa-a45f-60c79cf58a6f"
    "resume_offset=57430016"
  ];
  systemd.sleep.extraConfig = "HibernateDelaySec=2h";
  services.logind.settings.Login.HandleLidSwitch = "suspend-then-hibernate";

  networking.hostName = "big-red-dot";

  networking.networkmanager.enable = true;

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];
  nix.settings.keep-outputs = true;
  nix.settings.keep-derivations = true;

  swapDevices = [
    {
      device = "/swapfile";
      size = 16 * 1024; # 16GB
    }
  ];

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

    upower = {
      enable = true;
    };

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

    displayManager = {
      defaultSession = "hyprland";
      sddm = {
        enable = true;
        autoNumlock = true;
        theme = "where_is_my_sddm_theme";
        wayland.enable = true;
        package = pkgs.kdePackages.sddm;
        extraPackages = with pkgs; [
          kdePackages.qt5compat
        ];
      };
    };
    pcscd.enable = true;

    power-profiles-daemon.enable = false;
    tlp = {
      enable = true;
      settings = {
        CPU_BOOST_ON_AC = 1;
        CPU_BOOST_ON_BAT = 0;
        CPU_SCALING_GOVERNOR_ON_AC = "performance";
        CPU_SCALING_GOVERNOR_ON_BAT = "powersave";
        CPU_ENERGY_PERF_POLICY_ON_AC = "performance";
        CPU_ENERGY_PERF_POLICY_ON_BAT = "power";
        PLATFORM_PROFILE_ON_AC = "performance";
        PLATFORM_PROFILE_ON_BAT = "low-power";
        START_CHARGE_THRESH_BAT0 = 0;
        STOP_CHARGE_THRESH_BAT0 = 100;
      };
    };
  };

  xdg.portal = {
    enable = true;
    extraPortals = [pkgs.xdg-desktop-portal-gtk];
    config = {
      hyprland = {
        default = [
          "hyprland"
          "gtk"
        ];
        "org.freedesktop.impl.portal.FileChooser" = ["gtk"];
      };
    };
  };

  programs.nautilus-open-any-terminal = {
    enable = true;
    terminal = "kitty";
  };

  hardware.graphics = {
    enable = true;
  };
  hardware.nvidia = {
    modesetting.enable = true;
    open = true;
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable;

    # Save/restore GPU state on suspend/resume via systemd hooks.
    # Without this, the driver re-initializes from undefined state on wake,
    # causing slowness proportional to how many GPU-using apps were open.
    powerManagement.enable = true;
    # With PRIME offload mode, allow the dGPU to fully power off (D3cold/RTD3)
    # when no apps are using it, reducing suspend/resume surface area.
    powerManagement.finegrained = true;

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

  services.pulseaudio.enable = false;
  security.rtkit.enable = true;

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
    settings = {
      General = {
        Experimental = true;
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
      serif = ["Noto Serif"];
      sansSerif = ["Noto Sans"];
      monospace = ["FiraMono Nerd Font"];
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
  users.groups.nixusers = {};
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
        kdePackages.kpat
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
        keepassxc
        dbeaver-bin
        goose-cli
        pkgsUnstable.liteparse
        awscli2
        nodejs_24
        tilt
        kubectl
        kubernetes-helm
        k3d
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
  environment.sessionVariables.TERMINAL = "kitty";
  programs.dwl.enable = true;

  programs.bash.enable = true;
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
    settings = {
      global = {
        hide_env_diff = true;
      };
    };
  };

  virtualisation.docker = {
    enable = true;
    daemon.settings = {
      insecure-registries = ["192.168.1.101:5000"];
    };
  };
  virtualisation.libvirtd = {
    enable = true;
    qemu.swtpm.enable = true;
  };
  virtualisation.spiceUSBRedirection.enable = true;
  services.spice-vdagentd.enable = true;

  programs.nh = {
    enable = true;
  };

  programs.nix-ld = {
    enable = true;
  };

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
    rename
    lazydocker
    socat
    tio
    net-tools
    ripgrep
    silver-searcher
    pwgen
    lsof
    alejandra
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
    stress-ng
    nix-du

    # languages
    python3
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
    hyprmon
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
    (where-is-my-sddm-theme.override {
      themeConfig.General = {
        showUsersByDefault = true;
        showSessionsByDefault = true;
        hideCursor = true;
        passwordAllowEmpty = true;
      };
    })

    # apps
    kdePackages.gwenview
    kdePackages.kdenlive
    kdePackages.partitionmanager
    kdePackages.kcalc
    inav-configurator
    mission-planner
    libreoffice-qt-fresh
    onlyoffice-desktopeditors
    qdirstat
    gimp
    rivalcfg
    freecad
    kicad
    iverilog
    typst
    zathura
    kitty
    nautilus
    prusa-slicer
    hyprpolkitagent

    # video
    vlc
    handbrake
    ffmpeg
    yt-dlp

    # sound
    rmpc
    spotify
    rhythmbox
    picard
    fmodex

    # virtualisation
    gnome-boxes
    qemu
    quickemu
    virt-manager
    distrobox

    # file sharing
    copyparty
    cloudflared
    localsend
    syncthing
    qbittorrent

    # code editors
    zed-editor
    vscode-fhs
    arduino-ide

    # communication
    telegram-desktop
    bluebubbles

    # dod
    pcsclite
    pcsc-tools
    opensc
    cacert
    omnissa-horizon-client
    pkgsUnstable.claude-code

    # dwl
    wmenu
    foot
  ];

  system.stateVersion = "25.11";
}
