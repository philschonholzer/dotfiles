{ ... }: {
  flake.modules.homeManager.base = { ... }: {
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
        "codeberg.org" = {
          HostName = "codeberg.org";
          User = "git";
          IdentityFile = "~/.ssh/codeberg_ed25519";
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
          HostName = "Philips-Mac-mini-2202.local";
          User = "philip";
          IdentityFile = "~/.ssh/id_ed25519_macmini";
          ForwardAgent = true;
          # No foot terminfo on the mac; pretend to be a plain
          # xterm-256color over SSH
          SetEnv.TERM = "xterm-256color";
        };
        "tools.apptiva.ch" = {
          HostName = "tools.apptiva.ch";
          User = "root";
          IdentityFile = "~/.ssh/tools-apptiva";
          ForwardAgent = true;
        };
        "*" = {
          IgnoreUnknown = "AddKeysToAgent,UseKeychain";
          AddKeysToAgent = "yes";
          UseKeychain = "yes";
        };
      };
    };
  };
}
