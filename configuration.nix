{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      # ./home.nix
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "iggy-laptop"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

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

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  services.gvfs.enable = true;
  services.udisks2.enable = true;
  services.devmon.enable = true;
  security.polkit.enable = true;
  services.gnome.gnome-keyring.enable = true;
  services.fprintd.enable = true;

  services.greetd = {
  	enable = true;
  	settings = {
  	  default_session = {
  	    command = "${pkgs.tuigreet}/bin/tuigreet --time --remember --user-menu --cmd Hyprland";
  	    user = "greeter";
  	  };
  	};
  };
  systemd.services.greetd.serviceConfig = {
    Type = "idle";
    StandardInput = "tty";
    StandardOutput = "tty";
    StandardError = "journal"; # Without this errors will spam on screen
    # Without these bootlogs will spam on screen
    TTYReset = true;
    TTYVHangup = true;
    TTYVTDisallocate = true;
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
          STOP_CHARGE_THRESH_BAT0 = 90;
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
  services.xserver.videoDrivers = [ "modesetting" "nvidia" ];

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
    settings = {
      General = {
        # Shows battery charge of connected devices on supported
        # Bluetooth adapters. Defaults to 'false'.
        Experimental = true;
        # When enabled other devices can connect faster to us, however
        # the tradeoff is increased power consumption. Defaults to
        # 'false'.
        FastConnectable = true;
      };
      Policy = {
        # Enable all controllers when they are found. This includes
        # adapters present on start as well as adapters that are plugged
        # in later on. Defaults to 'true'.
        AutoEnable = true;
      };
    };
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;
  services.flatpak.enable = true;

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
    ];
  };

  programs.steam = {
  	enable = true;
  };
  hardware.steam-hardware.enable = true;

  # User groups
  users.groups.nixers = {};
  # User accounts
  users.users = {
    iggy = {
      isNormalUser = true;
      description = "personal account";
      extraGroups = [ "networkmanager" "wheel" "docker" "libvirtd" "nixers" ];
      packages = with pkgs; [
        # steam
        gh
        vesktop
      ];
    };
    wiggy = {
      isNormalUser = true;
      description = "work account";
      extraGroups = [ "networkmanager" "wheel" "docker" "libvirtd" "nixers" ];
      packages = with pkgs; [
      	code-cursor
      	keepassxc
      ];
    };
  };
  nix.settings.trusted-users = [ "iggy" "wiggy" "root" "@nixers" ];

  programs.firefox.enable = true;
  
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };
  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  programs.git = {
  	enable = true;
  	config = {
  		user.name = "iggy";
  		user.email = "bcus9126@gmail.com";
  		init.defaultBranch = "main";
  	};
  };

  programs.starship.enable = true;
  programs.bash.enable = true;


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

  # inputs.copyparty.url = "github:9001/copyparty";
  # outputs = { self, nixpkgs, copyparty }: {
  #   nixosConfigurations.yourHostName = nixpkgs.lib.nixosSystem {
  #     modules = [
  #       # load the copyparty NixOS module
  #       copyparty.nixosModules.default
  #       ({ pkgs, ... }: {
  #         # add the copyparty overlay to expose the package to the module
  #         nixpkgs.overlays = [ copyparty.overlays.default ];
  #         # (optional) install the package globally
  #         environment.systemPackages = [ pkgs.copyparty ];
  #         # configure the copyparty module
  #         services.copyparty = {
  #           enable = true;
  #           user = "copyparty";
  #           group = "copyparty";
  #           settings = {
  #             i = "0.0.0.0";
  #             p = [ 3210 3211 ];
  #             no-reload = true;
  #           };
  #           volumes = {
  #             "/" = {
  #           	path = "srv/copyparty";
  #           	access = {
  #                 rw = "*";
  #           	};
  #             };
  #             flags = {
  #           	fk = 4;
  #           	scan = 60;
  #           	e2d = true;
  #           	d2t = true;
  #             };
  #           };
  #         };
  #       })
  #     ];
  #   };
  # };

#   services.copyparty = {
#   	enable = true;
#   	user = "copyparty";
#   	group = "copyparty";
# 
#   	settings = {
#   	  i = "0.0.0.0";
#   	  p = [ 3210 3211 ];
#   	  no-reload = true;
#   	};
# 
#   	volumes = {
#   	  "/" = {
#   		path = "srv/copyparty";
#   		access = {
#   	      rw = "*";
#   		};
#   	  };
#   	  flags = {
#   		fk = 4;
#   		scan = 60;
#   		e2d = true;
#   		d2t = true;
#   	  };
#   	};
#   };

  # nix ld 
  programs.nix-ld = {
  	enable = true;
  	# libraries = with pkgs; [
  	# 	
  	# ]
  	# uncomment above when using more packages
  	# https://wiki.nixos.org/wiki/Nix-ld
  };
  
  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;
  
  environment.systemPackages = with pkgs; [
    # terminal tools
    wget
    git
    caligula
    dysk
    pulseaudio
    tree
    evemu
    vim
    micro
    fzf
    eza
    lshw
    btop
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
    nixfmt
    zip
    unzip
    unrar
    imagemagick
    rename #the perl one
    lazydocker
    socat
    tio

    # nix/nixos 
    home-manager

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

    # desktop environment
    hyprpaper
    waybar
    hyprshot
    hyprlock
    hyprpicker
    hypridle
    libnotify
    bibata-cursors
    kdePackages.kio-admin
    kdePackages.systemsettings
    kdePackages.dolphin
    kdePackages.qt6ct
    pavucontrol
    mako
    brightnessctl
    bluez

    # apps
	kitty
    kdePackages.gwenview
    kdePackages.kdenlive
    kdePackages.okular
    kdePackages.partitionmanager
    handbrake
    geteduroam
    inav-configurator
    libreoffice-qt-fresh
    qdirstat
    prismlauncher
    rofi 
    vscode
    zed-editor
    themechanger
    wl-clipboard
    bluetui
    impala
    bluez
    wev
    syncthing
    gimp
    localsend
    ffmpeg
    killall
    vlc
    rivalcfg
    obs-studio
    obsidian #find an alternative
    qbittorrent
    eww
    freecad
    goose-cli
    logseq
    kdePackages.kcalc
    tailscale
    ripgrep
    silver-searcher
    notcurses
    openssl
    qemu
    quickemu
    virt-manager
    # lovely-injector
    # r2modman
    toolbox
    telegram-desktop
    # py7zr
    gnome-boxes
    spice
    mission-planner

    # copyparty
    copyparty
    cloudflared
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
  	todo = "micro ~/Documents/todo.txt";
  	miniparty = "copyparty -q & cloudflared tunnel --url http://127.0.0.1:3923 && fg";
  	sreboot = "systemctl reboot -i";
  };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.11"; # Did you read the comment?

}
