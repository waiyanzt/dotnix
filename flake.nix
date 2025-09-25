{
  description = "My NixOS Flake-based Setup";

  inputs = {
    # The primary source for all NixOS packages and modules
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-25.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
  };

  # This section defines what we are building with the ingredients.
  outputs = { self, nixpkgs-stable, nixpkgs-unstable, ... }: {
    # We are building a NixOS system configuration.
    # 'nixos' is the hostname we will refer to it by. You can change this.
    nixosConfigurations.nixos = nixpkgs-stable.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = {
        pkgs-unstable = import nixpkgs-unstable { system = "x86_64-linux"; };
        inputs = self.inputs;
      };


      # These are the modules that make up our system configuration.
      modules = [
        ./hardware-configuration.nix
        ./configuration.nix
      ];
    };
  };
}
