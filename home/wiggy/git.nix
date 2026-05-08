{pkgs, ...}: {
  programs.git = {
    settings = {
      user = {
        email = "benjamin.cusack@watts.ai";
        name = "benjamin.cusack";
      };
      credential = {
        gpgEncryptionKey = "8C5AEEA74F7C0737";
        helper = "${pkgs.git-credential-manager}/bin/git-credential-manager";
        credentialStore = "gpg";
      };
    };
    includes = [
      {
        condition = "gitdir:~/pgp-signed/";
        contents = {
          commit.gpgsign = true;
          user.signingkey = "C78EBD0EDF68C212BBF633ED4D1C7275771B2151";
        };
      }
    ];
  };
}
