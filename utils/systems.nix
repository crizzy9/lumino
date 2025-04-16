inputs:
let
  homeManagerCfg = userPackages: extraImports: {
    home-manager.useGlobalPkgs = false;
    home-manager.extraSpecialArgs = {
      inherit inputs;
    };
    home-manager.users.spadia.imports = [
      inputs.agenix.homeManagerModules.default
      inputs.nix-index-database.hmModules.nix-index
    ] ++ extraImports;
    home-manager.backupFileExtension = "bak";
    home-manager.useUserPackages = userPackages;
  };
in
{
  mkDarwin = machineHostname: nixpkgsVersion: extraHmModules: extraModules: {
    darwinConfigurations.${machineHostname} = inputs.nix-darwin.lib.darwinSystem {
      system = "aarch64-darwin";
      specialArgs = {
        inherit inputs;
      };
      modules = [
        ./hosts/darwin
        ./hosts/darwin/${machineHostname}
        inputs.home-manager-darwin.darwinModules.home-manager
        (inputs.nixpkgs-darwin.lib.attrsets.recursiveUpdate (homeManagerCfg true extraHmModules) {
          home-manager.users.notthebee.home.homeDirectory =
            inputs.nixpkgs-darwin.lib.mkForce "/Users/" + machineHostname;
        })
      ];
    };
  };
  mkNixos = machineHostname: nixpkgsVersion: extraModules: rec {
    # deploy.nodes.${machineHostname} = {
    #   hostname = machineHostname;
    #   profiles.system = {
    #     user = "root";
    #     sshUser = "lumino";
    #     path = inputs.deploy-rs.lib.x86_64-linux.activate.nixos nixosConfigurations.${machineHostname};
    #   };
    # };
    nixosConfigurations.${machineHostname} = nixpkgsVersion.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = {
        inherit inputs;
        # vars = import ./hosts/nixos/${machineHostname}/vars.nix;
        settings = import ./hosts/nixos/${machineHostname}/settings.nix;
      };
      modules = [
        # ./machines/nixos/_common
        ./hosts/nixos
        ./hosts/nixos/${machineHostname}
        inputs.agenix.nixosModules.default
        ./users/notthebee
        (homeManagerCfg false [ ])
      ] ++ extraModules;
    };
  };
  mkMerge = inputs.nixpkgs.lib.lists.foldl' (
    a: b: inputs.nixpkgs.lib.attrsets.recursiveUpdate a b
  ) { };
}
