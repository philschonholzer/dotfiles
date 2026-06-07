inputs: {
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    includes = [ "~/.colima/ssh_config" ];

    settings = {
      "github.com" = {
        HostName = "github.com";
        User = "git";
        IdentityFile = "~/.ssh/github_ed25519";
      };
      "bitbucket.org" = {
        HostName = "bitbucket.org";
        User = "git";
        IdentityFile = "~/.ssh/id_rsa_bb";
      };
      "phischer" = {
        HostName = "91.214.190.25";
        User = "debian";
        IdentityFile = "~/.ssh/infomaniak_ed25519";
        ForwardAgent = true;
      };
      "phischer-build" = {
        HostName = "193.108.54.25";
        User = "debian";
        IdentityFile = "~/.ssh/infomaniak-phischer-build-server";
        ForwardAgent = true;
      };
      "macmini" = {
        HostName = "192.168.1.65";
        User = "philip";
        IdentityFile = "~/.ssh/id_ed25519_macmini";
        ForwardAgent = true;
      };
      "*" = {
        IgnoreUnknown = "AddKeysToAgent,UseKeychain";
        AddKeysToAgent = "yes";
        UseKeychain = "yes";
      };
    };
  };
}
