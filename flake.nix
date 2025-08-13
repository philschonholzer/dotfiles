{
  description = "My Beelink setup";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    omarchy-nix = {
      url = "github:henrysipp/omarchy-nix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };
    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    omarchy-nix,
    ...
  } @ inputs: {
    # Used with `nixos-rebuild --flake .#<hostname>`
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ./configuration.nix
        omarchy-nix.nixosModules.default
        home-manager.nixosModules.home-manager
        {
          omarchy = {
            full_name = "Philip Schoenholzer";
            email_address = "philip@schoenholzer.com";
            theme = "nord";
            monitors = ["DP-3, 5120x2160, 0x0, 1.6"];
            quick_app_bindings = [
              "SUPER, B, exec, firefox"
              "SUPER, A, exec, $webapp=https://chat.mistral.ai/chat --profile-directory=Privat"
              "SUPER SHIFT, A, exec, $webapp=https://chatgpt.com --profile-directory=Privat"
              "SUPER, Y, exec, $webapp=https://youtube.com/ --profile-directory=Privat"
              "SUPER, M, exec, $webapp=https://mail.missiveapp.com/# --profile-directory=Work"
              "SUPER SHIFT, M, exec, $webapp=https://calendar.google.com/ --profile-directory=Work"
              "SUPER, T, exec, $webapp=https://trello.com/ --profile-directory=Work"

              "SUPER, return, exec, $terminal"
              "SUPER, F, exec, $fileManager"
              "SUPER, N, exec, $terminal -e nvim"
              "SUPER, D, exec, $terminal -e lazydocker"
              "SUPER, G, exec, $messenger"
              "SUPER, O, exec, obsidian -disable-gpu"
              "SUPER, slash, exec, $passwordManager"
            ];
          };

          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            users.philip = {
              imports = [
                ./home.nix
                omarchy-nix.homeManagerModules.default
              ];
            };
          };
        }
      ];
    };
  };
}
