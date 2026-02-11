{ inputs, pkgs, ... }:
let
  locked = "locked";
  lock-false = {
    Value = false;
    Status = locked;
  };
  lock-true = {
    Value = true;
    Status = locked;
  };
in
{
  imports = [
    inputs.zen-browser.homeModules.twilight
  ];
  programs.zen-browser = {
    enable = true;

    nativeMessagingHosts = [ pkgs.firefoxpwa ];

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

      profiles."Default".settings = {
        "zen.urlbar.replace-newtab" = lock-false;
        "zen.glance.enabled" = lock-true;
        "zen.mods.no-sidebar-scrollbar" = lock-true;
        "zen.mods.ghost-tabs" = lock-true;
        "zen.site-data-panel.show-callout" = lock-false;
        "zen.swipe.is-fast-swipe" = lock-true;
        "zen.view.compact.enable-at-startup" = lock-true;
        "zen.view.use-single-toolbar" = lock-false;
        "zen.tabs.show-newtab-vertical" = lock-false;
        "zen.browser.tabs.closeWindowWithLastTab" = lock-true;
        "zen.view.experimental-no-window-controls" = lock-true;
        "zen.view.hide-window-controls" = lock-true;
        "zen.urlbar.behavior" = {
          Value = "floating-on-type";
          Status = locked;
        };
        "sidebar.visibility" = {
          Value = "hide-sidebar";
          Status = locked;
        };
        "zen.theme.gradient.show-custom-colors" = lock-true;
        "zen.theme.widget.linux.transparency" = lock-true;
        "zen.theme.dim-pending" = lock-true;
        # "browser.gesture.swipe.left" = { "cmd_scrollLeft" "locked" };
        # "browser.gesture.swipe.Right" = { "cmd_scrollRight" "locked" };
      };


      ExtensionSettings = {
        "uBlock0@raymondhill.net" = {
          # ublock
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi";
          installation_mode = "force_installed";
        };
      };

      Preferences = {
        "browser.ml.enable" = lock-false;
        "browser.warnOnQuitShortcut" = lock-true;
        "browser.ctrlTab.sortByRecentlyUsed" = lock-false;
        "media.videocontrols.picture-in-picture.video-toggle.enabled" = lock-false;
      };
    };
  };
}
