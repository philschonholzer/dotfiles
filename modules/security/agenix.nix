{ inputs, ... }: {
  imports = [
    inputs.agenix-rekey.flakeModule
  ];

  perSystem = { ... }: {
    agenix-rekey = {
      nixosConfigurations = {
        inherit (inputs.self.nixosConfigurations) beelink macbook-intel;
      };
      homeConfigurations = {
        inherit (inputs.self.homeConfigurations) macbook-m2 philip;
      };
    };
  };
}
