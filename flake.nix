{
  # nixConfig = {
  #   trusted-substituters = [
  #     "https://cachix.cachix.org"
  #     "https://nixpkgs.cachix.org"
  #     "https://nix-community.cachix.org"
  #   ];
  #   trusted-public-keys = [
  #     "cachix.cachix.org-1:eWNHQldwUO7G2VkjpnjDbWwy4KQ/HNxht7H4SSoMckM="
  #     "nixpkgs.cachix.org-1:q91R6hxbwFvDqTSDKwDAV4T5PxqXGxswD8vhONFMeOE="
  #     "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
  #     "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
  #   ];
  # };

  # inputs = import ./utils/inputs.nix;
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-darwin.url = "github:nixos/nixpkgs/nixpkgs-24.11-darwin";
    nixpkgs-darwin-unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-24.11";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager-darwin = {
      url = "github:nix-community/home-manager/release-24.11";
      inputs.nixpkgs.follows = "nixpkgs-darwin";
    };
    home-manager-unstable = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
    stylix.url = "github:danth/stylix";
    hyprland.url = "github:hyprwm/Hyprland";
    hyprland-plugins = {
      url = "github:hyprwm/hyprland-plugins";
      inputs.hyprland.follows = "hyprland";
    };
    split-monitor-workspaces = {
      url = "github:Duckonaut/split-monitor-workspaces";
      inputs.hyprland.follows = "hyprland"; # <- make sure this line is present for the plugin to work as intended
    };
    nix-yazi-plugins = {
      url = "github:lordkekz/nix-yazi-plugins?ref=yazi-v0.2.5";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    { nixpkgs, home-manager, ... }@inputs:
    let
      helpers = import ./utils/systems.nix inputs;
      inherit (helpers) mkMerge mkNixos mkDarwin;
      getHostDirs = path:
        let
          isDir = name: inputs.nixpkgs.lib.filesystem.pathIsDirectory (path + "/${name}");
          dirNames = inputs.nixpkgs.lib.attrNames (inputs.nixpkgs.lib.filterAttrs (name: _: isDir name) (builtins.readDir path));
        in
          dirNames;
      nixosHosts = getHostDirs ./hosts/nixos;
      # nixosHosts = [ "nixos" ];
      nixConfigs = builtins.map (hostname:
        (mkNixos hostname inputs.nixpkgs [
          inputs.home-manager.nixosModules.home-manager
        ])
      ) nixosHosts;

      darwinHosts = builtins.filter (name: name != "default.nix") (getHostDirs ./hosts/darwin);
      darwinConfigs = builtins.map (hostname: 
        (mkDarwin hostname inputs.nixpkgs-darwin [] [])
      ) darwinHosts;
    in
    mkMerge (nixConfigs ++ darwinConfigs);
}
