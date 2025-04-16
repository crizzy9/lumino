{
  nixConfig = {
    trusted-substituters = [
      "https://cachix.cachix.org"
      "https://nixpkgs.cachix.org"
      "https://nix-community.cachix.org"
    ];
    trusted-public-keys = [
      "cachix.cachix.org-1:eWNHQldwUO7G2VkjpnjDbWwy4KQ/HNxht7H4SSoMckM="
      "nixpkgs.cachix.org-1:q91R6hxbwFvDqTSDKwDAV4T5PxqXGxswD8vhONFMeOE="
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
  };

  inputs = import ./utils/inputs.nix;

  outputs =
    { ... }@inputs:
    let
      helpers = import ./utils/systems.nix inputs;
      inherit (helpers) mkMerge mkNixos mkDarwin;
      getHostDirs = path:
        let
          isDir = name: inputs.nixpkgs.lib.filesystem.isDirectory (path + "/${name}");
          dirNames = inputs.nixpkgs.lib.attrNames (inputs.nixpkgs.lib.filterAttrs (name: _: isDir name) (builtins.readDir path));
        in
          dirNames;
      nixosHosts = getHostDirs ./hosts/nixos;
      nixConfigs = builtins.map (hostname:
        mkNixos hostname inputs.nixpkgs [
          inputs.home-manager.nixosModules.home-manager
        ]
      ) nixosHosts;

      darwinHosts = builtins.filter (name: name != "default.nix") (getHostDirs ./hosts/darwin);
      darwinConfigs = builtins.map (hostname: 
        mkDarwin hostname inputs.nixpkgs-darwin [] []
      ) darwinHosts;
    in
    mkMerge (nixConfigs ++ darwinConfigs);
}
