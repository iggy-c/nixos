{
  inputs,
  pkgs,
  config,
  ...
}: let
  mkLockedAttrs = builtins.mapAttrs (
    _: value: {
      Value = value;
      Status = "locked";
    }
  );

  mkPluginUrl = id: "https://addons.mozilla.org/firefox/downloads/latest/${id}/latest.xpi";

  mkExtensionEntry = {
    id,
    pinned ? false,
  }: let
    base = {
      install_url = mkPluginUrl id;
      installation_mode = "force_installed";
    };
  in
    if pinned
    then base // {default_area = "navbar";}
    else base;

  mkExtensionSettings = builtins.mapAttrs (
    _: entry:
      if builtins.isAttrs entry
      then entry
      else mkExtensionEntry {id = entry;}
  );
in {
  imports = [
    inputs.zen-browser.homeModules.beta
  ];
  programs.zen-browser = {
    enable = true;

    nativeMessagingHosts = [pkgs.firefoxpwa];

    policies = {
      AutoFillAddressEnabled = false;
      AutofillCreditCardEnabled = false;
      DisableAppUpdate = true;
      DisableFeedbackCommands = true;
      DisableFirefoxStudies = true;
      DisablePocket = true;
      DisableTelemetry = true;
      DontCheckDefaultBrowser = true;
      NoDefaultBookmakrs = true;
      OfferToSaveLogins = true;
      DisableSetDesktopBackground = true;
      EnableTrackingProtection = {
        Value = true;
        Locked = true;
        Cryptomining = true;
        Fingerprinting = true;
      };

      ExtensionSettings = mkExtensionSettings {
        "uBlock0@raymondhill.net" = mkExtensionEntry {
          id = "ublock-origin";
          pinned = true;
        };
        "{74145f27-f039-47ce-a470-a662b129930a}" = "clearurls";
        "firefox-extension@steamdb.info" = "steam-database";
      };

      Preferences = mkLockedAttrs {
        "browser.aboutConfig.showWarning" = false;
        "browser.gesture.swipe.left" = "scrollLeft";
        "browser.gesture.swipe.right" = "scrollRight";
        "browser.tabs.inTitlebar" = 0;
      };
    };

    profiles.default = {
      mods = [
        "1b88a6d1-d931-45e8-b6c3-bfdca2c7e9d6" # Remove Tab X
        "c01d3e22-1cee-45c1-a25e-53c0f180eea8" # Ghost Tabs
        "4ab93b88-151c-451b-a1b7-a1e0e28fa7f8" # No Sidebar Scrollbar
      ];
    };
  };
}
