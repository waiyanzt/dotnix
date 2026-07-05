{
  description = "NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    mcp-nixos = {
      url = "github:utensils/mcp-nixos";
    };

    # Do not make Noctalia follow nixpkgs: its upstream binary cache is built
    # against its own pinned nixpkgs input.
    noctalia = {
      url = "github:noctalia-dev/noctalia";
    };

    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ nixpkgs, home-manager, mcp-nixos, ... }: {
    # NixOS configuration (Thinkpad T14)
    nixosConfigurations.thanatos = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = { inherit inputs; };
      modules = [
        ./nixos
        {
          nixpkgs.overlays = [ mcp-nixos.overlays.default ];
        }
        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.extraSpecialArgs = { inherit inputs; };
          home-manager.users.ztzy = import ./home/ztzy.nix;
        }
      ];
    };
  };
}
