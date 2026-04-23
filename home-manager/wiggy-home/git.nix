{ ... }:
{
  programs.git = {
    settings = {
      commit.gpgsign = true;
      # gpg.format = "ssh";
      user = {
        signingkey = "C78EBD0EDF68C212BBF633ED4D1C7275771B2151";
	email = "benjamin.cusack@watts.ai";
	name = "benjamin.cusack";
      };

      credential.gpgEncryptionKey = "8C5AEEA74F7C0737";
    };
  };
}
