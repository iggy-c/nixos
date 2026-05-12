{pkgs, ...}: {
  programs.git = {
    enable = true;
    settings = {
      diff.tool = "nvimdiff";
      difftool.prompt = false;
      fetch.recurseSubbmodules = true;
    };
  };
}
