{pkgs, ...}: {
  # nix build /etc/nixos/#nixosConfigurations.live-iso.config.system.build.isoImage
  imports = [
    ../common/default.nix
  ];

  nixpkgs.hostPlatform = "x86_64-linux";

  networking.hostName = "live";
  networking.networkmanager.enable = true;

  time.timeZone = "America/Chicago";
  i18n.defaultLocale = "en_US.UTF-8";

  security = {
    polkit.enable = true;
    pam.services.hyprlock.enable = true;
    rtkit.enable = true;
    sudo.wheelNeedsPassword = false;
  };

  programs = {
    hyprlock.enable = true;
  };

  services = {
    gnome.gnome-keyring.enable = true;
    playerctld.enable = true;
    gvfs.enable = true;
    udisks2.enable = true;
    devmon.enable = true;
    pulseaudio.enable = false;

    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };

    xserver.xkb = {
      layout = "us";
      variant = "";
    };

    displayManager = {
      defaultSession = "hyprland";
      autoLogin = {
        enable = true;
        user = "iggy";
      };
      sddm = {
        enable = true;
        wayland.enable = true;
        package = pkgs.kdePackages.sddm;
      };
    };
  };

  xdg.portal = {
    enable = true;
    extraPortals = [pkgs.xdg-desktop-portal-gtk];
    config.hyprland = {
      default = ["hyprland" "gtk"];
      "org.freedesktop.impl.portal.FileChooser" = ["gtk"];
    };
  };

  users.users.iggy = {
    isNormalUser = true;
    extraGroups = ["networkmanager" "wheel"];
    password = "";
  };

  nixpkgs.config.allowUnfree = true;

  environment.sessionVariables.NIXOS_OZONE_WL = "1";
  environment.sessionVariables.TERMINAL = "kitty";

  environment.systemPackages = with pkgs; [
    btop
  ];

  image.fileName = "live-iggy.iso";
  isoImage.squashfsCompression = "zstd -Xcompression-level 6";

  system.stateVersion = "26.05";
}
