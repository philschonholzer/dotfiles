inputs: {
  programs.ssh = {
    enable = true;
    includes = ["~/.colima/ssh_config"];

    matchBlocks = {
      "Github" = {
        host = "github.com";
        hostname = "github.com";
        user = "git";
        # identityFile removed - uses yubikey-agent instead
      };
      "Bitbucket" = {
        host = "bitbucket.org";
        hostname = "bitbucket.org";
        user = "git";
        identityFile = "~/.ssh/id_rsa_bb";
      };
      "Infomaniak" = {
        host = "phischer";
        hostname = "91.214.190.25";
        user = "debian";
        identityFile = "~/.ssh/infomaniak_ed25519";
        forwardAgent = true;
      };
      "MacMini" = {
        host = "macmini";
        hostname = "192.168.1.65";
        user = "philip";
        identityFile = "~/.ssh/id_ed25519_macmini";
        forwardAgent = true;
      };
      "Default" = {
        host = "*";
        extraOptions = {
          IgnoreUnknown = "AddKeysToAgent,UseKeychain";
          AddKeysToAgent = "yes";
          UseKeychain = "yes";
        };
      };
    };
  };
}
