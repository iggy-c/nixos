{...}: {
  programs.git = {
    settings = {
      user = {
        email = "bcus9126@gmail.com";
        name = "iggy";
      };
      safe.directory = ["/etc/nixos"];
      diff.tool = "nvimdiff";
    };
  };
}
