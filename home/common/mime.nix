{
  config,
  lib,
  ...
}: let
  assoc = app: types: lib.genAttrs types (_: app);
in {
  xdg.desktopEntries.nvim-kitty = {
    name = "Neovim (kitty)";
    genericName = "Text Editor";
    comment = "Edit text files in Neovim inside kitty";
    exec = "${lib.getExe config.programs.kitty.package} ${lib.getExe
      config.programs.neovim.finalPackage} %F";
    icon = "nvim";
    terminal = false;
    categories = ["Utility" "TextEditor" "Development"];
    mimeType = ["text/plain" "text/markdown" "text/x-markdown"];
    settings.StartupNotify = "false";
  };

  xdg.mimeApps = {
    enable = true;
    defaultApplications =
      assoc "nvim-kitty.desktop" [
        "text/plain"
        "text/markdown"
        "text/x-markdown"
        "text/english"
        "text/x-makefile"
        "text/x-shellscript"
        "application/x-shellscript"
        "text/x-csrc"
        "text/x-chdr"
        "text/x-c++src"
        "text/x-c++hdr"
        "text/x-python"
        "text/x-java"
        "text/rust"
        "text/x-rust"
        "text/x-tex"
        "application/json"
        "application/xml"
        "text/xml"
        "application/toml"
        "application/x-yaml"
      ]
      # documents 
      // assoc "org.pwmt.zathura.desktop" [
        "application/pdf"
        "application/postscript"
        "application/oxps"
        "application/epub+zip"
        "application/x-mobipocket-ebook"
        "application/x-fictionbook"
        "image/vnd.djvu"
        "application/x-cbz"
        "application/x-cbr"
      ]
      # images 
      // assoc "org.kde.gwenview.desktop" [
        "image/png"
        "image/jpeg"
        "image/gif"
        "image/webp"
        "image/svg+xml"
        "image/tiff"
        "image/bmp"
        "image/avif"
        "image/heif"
        "image/jxl"
        "image/x-ico"
      ]
      // assoc "gimp.desktop" ["image/x-xcf"]
      # media — beats rhythmbox, handbrake, mkvtoolnix, picard
      // assoc "vlc.desktop" [
        "audio/mpeg"
        "audio/flac"
        "audio/ogg"
        "audio/opus"
        "audio/wav"
        "audio/x-m4a"
        "audio/x-matroska"
        "application/ogg"
        "video/mp4"
        "video/x-matroska"
        "video/webm"
        "video/quicktime"
        "video/x-msvideo"
        "video/mpeg"
        "video/ogg"
      ]
      # web 
      // assoc "zen-beta.desktop" [
        "text/html"
        "application/xhtml+xml"
        "x-scheme-handler/http"
        "x-scheme-handler/https"
      ]
      # directories & archives
      // assoc "org.kde.dolphin.desktop" [
        "inode/directory"
        "application/zip"
        "application/gzip"
        "application/zstd"
        "application/vnd.rar"
        "application/x-tar"
        "application/x-compressed-tar"
        "application/x-7z-compressed"
        "application/x-bzip2-compressed-tar"
        "application/x-xz-compressed-tar"
      ]
      # office 
      // assoc "writer.desktop" [
        "application/msword"
        "application/vnd.openxmlformats-officedocument.wordprocessingml.document"
        "application/vnd.oasis.opendocument.text"
        "application/rtf"
      ]
      // assoc "calc.desktop" [
        "application/vnd.ms-excel"
        "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"
        "application/vnd.oasis.opendocument.spreadsheet"
        "text/csv"
      ]
      // assoc "impress.desktop" [
        "application/vnd.ms-powerpoint"
        "application/vnd.openxmlformats-officedocument.presentationml.presentation"
        "application/vnd.oasis.opendocument.presentation"
      ]
      // assoc "draw.desktop" ["application/vnd.oasis.opendocument.graphics"]
      // assoc "org.qbittorrent.qBittorrent.desktop" [
        "application/x-bittorrent"
        "x-scheme-handler/magnet"
      ]
      // {
        "x-scheme-handler/claude-cli" = "claude-code-url-handler.desktop";
        "x-scheme-handler/itms" = "sidra.desktop";
      };
  };
}
