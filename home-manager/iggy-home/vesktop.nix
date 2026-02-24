{ pkgs, ... }:

{
  programs.vesktop = {
	enable = true;
	settings = {
	  arRPC = true;
	  checkUpdates = false;
	  disableMinSize = true;
	  discordBranch = "stable";
	  minimizeToTray = false;
	  enableSplashScreen = false;
	};
	vencord.settings = {
	  autoUpdate = true;
	  autoUpdateNotification = true;
	  notifyAboutUpdates = false;
	  useQuickCss = true;
	  themeLinks = [
	    https://raw.codeberg.page/AllPurposeMat/Disblock-Origin/DisblockOrigin.theme.css
	  ];
	  winNativeTitleBar = false;
	  disableMinSize = true;
	  plugins = {
	    AlwaysAnimate.enabled = true;
	    AlwaysExpandRoles.enabled = true;
	    AppleMusicRichPresence.enabled = true;
	    BetterGifPicker.enabled = true;
	    BiggerStreamPreview.enabled = true;
	    BlurNSFW.enabled = true;
	    CallTimer.enabled = true;
	    ClearURLs.enabled = true;
	    CopyFileContents.enabled = true;
	    CrashHandler.enabled = true;
	    CustomRPC.enabled = true;
	    DisableCallIdle.enabled = true;
	    DontRoundMyTimestamps.enabled = true;
	    ExpressionCloner.enabled = true;
	    FakeNitro.enabled = true;
	    FavoriteEmojiFirst.enabled = true;
	    FixCodeblockGap.enabled = true;
	    FixSpotifyEmbeds.enabled = true;
	    GameActivityToggle.enabled = true;
	    MessageLogger = {
	      enabled = true;
	      ignoreSelf = true;
	      ignoreBots = true;
	      InlineEdits = true;
	    };
	    NoF1.enabled = true;
	    NSFWGateBypass.enabled = true;
	    PermissionsViewer.enabled = true;
	    petpet.enabled = true;
	    PictureInPicture.enabled = true;
	    PinDMs.enabled = true;
	    PlatformIndicators.enabled = true;
	    ShowHiddenChannels.enabled = true;
	    ShowHiddenThings.enabled = true;
	    SpotifyCrack.enabled = true;
	    TypingIndicator.enabled = true;
	    UserMessagesPronouns.enabled = true;
	    UserVoiceShow.enabled = true;
	    USRBG.enabled = true;
	    VoiceChatDoubleClick.enabled = true;
	    VoiceDownload.enabled = true;
	    VolumeBooster.enabled = true;
	    WebScreenShareFixes.enabled = true;
	    WhoReacted.enabled = true;
	  };
	};
  };
  
}
