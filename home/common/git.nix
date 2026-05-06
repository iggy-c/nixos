{pkgs, ...}: {
  programs.git = {
    enable = true;
    settings = {
      credential = {
        helper = "${pkgs.git-credential-manager}/bin/git-credential-manager";
        credentialStore = "gpg";
      };
    };
  };
}
