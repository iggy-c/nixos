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

  networking.hostName = "default"; # Define your hostname.
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
  
  services.fprintd.enable = true;

  # security.sudo.configFile = ''
  #   %admin: ALL = (root) NOPASSWD: evemu-event
  # '';

  # services.keyd.enable = true;

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
  };

  programs.steam = {
  	enable = true;
  	# extraPackages = [ gamescope ];
  };
  hardware.steam-hardware.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users = {
    iggy = {
      isNormalUser = true;
      description = "personal account";
      extraGroups = [ "networkmanager" "wheel" "docker" ];
      packages = with pkgs; [
        # steam
        gh
        vesktop
      ];
    };
    wiggy = {
      isNormalUser = true;
      description = "work account";
      extraGroups = [ "networkmanager" "wheel" "docker" ];
      packages = with pkgs; [
      	code-cursor
      	keepassxc
      ];
    };
  };

  # programs.home-manager.enable = true;
  programs.firefox.enable = true;
  
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };
  environment.sessionVariables.NIXOS_OZONE_WL = "1";
  
  # wayland.windowManager.hyprland.enable = true;
  programs.git = {
  	enable = true;
  	config = {
  		user.name = "iggy";
  		user.email = "bcus9126@gmail.com";
  		init.defaultBranch = "main";
  	};
  };

  # programs.kitty = {
  	# enable = true;
  	# font.name = font.mono.family;
  	# shellIntegration.enableBashIntegration = true;
  # };
  programs.starship.enable = true;
  programs.bash = {
  	enable = true;
  # 	shellAliases = {
  # 		t = "echo test2 ";
  # 	};
  };

  virtualisation.docker = {
  	enable = true;
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
	kitty
    vim
    wget
    micro
    wofi
    rofi 
    home-manager
    waybar
    git
    hyprpaper
    vscode
    zed-editor
    fzf
    brightnessctl
    kdePackages.dolphin
    kdePackages.qt6ct
    themechanger
    wl-clipboard
    hyprshot
    python3
    eza
    lshw
    btop
    bibata-cursors
    bluetui
    impala
    bluez
    prismlauncher
    hyprpicker
    hyprlock
    wev
    blahaj
    fastfetch
    qdirstat
    syncthing
    gimp
    localsend
    mako
    ffmpeg
    killall
    unzip
    jq
    yq
    bat
    libnotify
    imagemagick
    libreoffice-qt-fresh
    kdePackages.okular
    vlc
    handbrake
    rivalcfg
    screen
    obs-studio
    obsidian #find an alternative
    lavat
    winboat
    kdePackages.kio-admin
    qbittorrent
    cider # how is there still no other option
    kdePackages.systemsettings
    pavucontrol
    eww
    pulseaudio
    tree
    evemu
    caligula
    dysk
    freecad
    kdePackages.gwenview
    geteduroam
    inav-configurator
    bibata-cursors
    kdePackages.kdenlive
  ];

  environment.shellAliases = {
  	sudo = "sudo ";
  	rs = "nixos-rebuild switch";
  	rt = "nixos-rebuild test";
  	ls = "eza";
  	la = "eza -a";
  	li = "eza --icons";
  	ll = "eza -l";
  	numlock_toggle = ''
	  evemu-event /dev/input/event0 --type EV_KEY --code KEY_NUMLOCK --value 1 --sync; evemu-event /dev/input/event0 --type EV_KEY --code KEY_NUMLOCK --value 0 --sync
  	'';
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

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.11"; # Did you read the comment?

}
