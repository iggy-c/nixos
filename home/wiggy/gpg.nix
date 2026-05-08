{
  pkgs,
  config,
  ...
}: {
  programs.gpg.enable = true;

  services.gpg-agent = {
    enable = true;
    defaultCacheTtl = 3600;
    maxCacheTtl = 86400;
    pinentry.package = pkgs.pinentry-curses;
  };

  programs.password-store = {
    enable = true;
    settings.PASSWORD_STORE_DIR = "${config.home.homeDirectory}/.local/share/pass";
  };
}
