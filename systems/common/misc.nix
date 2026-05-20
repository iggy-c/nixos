{pkgs, ...}: {
  fonts = {
    enableDefaultPackages = true;
    enableGhostscriptFonts = true;
	fontconfig.enable = true;
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

  services.flatpak.enable = true;

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

  programs.nautilus-open-any-terminal = {
    enable = true;
    terminal = "kitty";
  };
}
