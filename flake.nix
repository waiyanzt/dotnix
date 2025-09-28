{
  description = "My NixOS Flake-based Setup";

  inputs = {
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-25.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
  };

  outputs = { self, nixpkgs-stable, nixpkgs-unstable, ... } @ inputs:
  let
    # 1. Define the system architecture for reuse.
    system = "x86_64-linux";

    # 2. Create pre-configured package sets.
    #    We import nixpkgs with the config option already applied.
    pkgs-stable = import nixpkgs-stable {
      inherit system;
      config.allowUnfree = true;
    };

    pkgs-unstable = import nixpkgs-unstable {
      inherit system;
      config.allowUnfree = true;
    };

  in
  {
    nixosConfigurations.nixos = nixpkgs-stable.lib.nixosSystem {
      inherit system;

      # 3. Pass our pre-configured packages to our modules.
      specialArgs = {
        inherit pkgs-unstable; # Pass the configured unstable set
        inherit inputs;        # Pass all flake inputs
      };

      # 4. Define all modules for the system here.
      modules = [
				{nixpkgs.pkgs = pkgs-stable; }
        ./hardware-configuration.nix
        ./configuration.nix
        ./fonts.nix
      ];
    };
  };
}
