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
    "amd_pstate=guided"
  ];
  services.logind.settings.Login.HandleLidSwitch = "suspend-then-hibernate";

  networking.hostName = "big-red-dot";

  networking.networkmanager.enable = true;

  swapDevices = [
    {
      device = "/swapfile";
      size = 16 * 1024; # 16GB
    }
  ];

  # time.timeZone = "America/Chicago";
  services.automatic-timezoned.enable = true;
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

    upower.enable = true;

    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
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

  services.udev.extraRules = ''
    SUBSYSTEM=="usb", ATTR{idVendor}=="1209", ATTR{idProduct}=="0d3[0-9]", MODE="0666", ENV{ID_MM_DEVICE_IGNORE}="1"
    SUBSYSTEM=="usb", ATTR{idVendor}=="0483", ATTR{idProduct}=="df11", MODE="0666"
  '';

  programs.steam.enable = true;
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
      shell = pkgs.zsh;
    };
    wiggy = {
      isNormalUser = true;
      description = "work account";
      shell = pkgs.zsh;
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

  programs.dwl.enable = true;
  programs.hyprlock.enable = true;

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

  zramSwap.enable = true;

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

  environment.systemPackages = with pkgs; [
    # terminal tools
    evemu
    pkgsRocmCuda.btop
    blahaj
    lavat
    pipes
    cbonsai
    nmap
    lazydocker
    pwgen
    avrdude
    avrdudess
    libimobiledevice
    usbutils
    can-utils
    acpi
    killall
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
    quickshell
    hyprpicker
    libnotify
    kdePackages.kio-admin
    kdePackages.systemsettings
    kdePackages.dolphin
    kdePackages.qt6ct
    brightnessctl
    bluez
    spice
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
    inav-configurator
    mission-planner
    libreoffice-qt-fresh
    onlyoffice-desktopeditors
    qdirstat
    gimp
    rivalcfg
    kicad
    iverilog
    typst
    prusa-slicer
    # bambu-studio 
    # ^ causing issues
    chromium

    # video
    handbrake

    # sound
    rmpc
    spotify
    rhythmbox
    picard
    fmodex
    mkvtoolnix

    # virtualisation
    gnome-boxes
    qemu
    quickemu
    virt-manager
    distrobox

    # file sharing
    localsend
    syncthing

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

  system.stateVersion = "26.05";
}
