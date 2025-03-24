# TODO: import all settings from a file created using a gum ui bash script
{
  description = "Nightwatcher Dotfiles";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    stylix.url = "github:danth/stylix";
    hyprland.url = "github:hyprwm/Hyprland";
    # hyprland.url = "git+https://github.com/hyprwm/Hyprland?submodules=1";
    hyprland-plugins = {
      url = "github:hyprwm/hyprland-plugins";
      inputs.hyprland.follows = "hyprland";
    };
    split-monitor-workspaces = {
      url = "github:Duckonaut/split-monitor-workspaces";
      inputs.hyprland.follows = "hyprland"; # <- make sure this line is present for the plugin to work as intended
    };
    # Hyprspace = {
    #   url = "github:KZDKM/Hyprspace";
    #   inputs.hyprland.follows = "hyprland";
    # };
  };

  outputs = { nixpkgs, home-manager, ... }@inputs:
  let
    lib = nixpkgs.lib;
    systems = [ "x86_64-linux" "aarch64-linux" ];
    forAllSystems = nixpkgs.lib.genAttrs systems;

    # Helper function to create system config
    mkSystem = {
      hostname,
      system ? "x86_64-linux",
      username,
      extraModules ? [],
    }: lib.nixosSystem {
      inherit system;
      specialArgs = {
        inherit inputs system username hostname;
      };
      modules = [
        # Core modules
        ./hosts/${hostname}/configuration.nix
        # Common modules
        inputs.stylix.nixosModules.stylix
        home-manager.nixosModules.home-manager
        # Home-manager configuration
        {
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            backupFileExtension = "backup";
            extraSpecialArgs = {
              inherit inputs username hostname;
              pkgs = nixpkgs.legacyPackages.${system};
            };
            users.${username} = {
              imports = [ 
                ./hosts/${hostname}/home.nix
                inputs.hyprland.homeManagerModules.default
              ] ++ extraModules;
            };
          };
        }
      ] ++ extraModules;
    };
  
    # Load host configurations dynamically
    hostConfigs = let
      # Read the hosts directory
      hostDirs = builtins.readDir ./hosts;
      # Filter out non-directories
      hosts = lib.filterAttrs (name: type: type == "directory") hostDirs;
      # Get host configs from installer state if it exists
      settings = if builtins.pathExists ./config/settings.yml
        then builtins.fromTOML (builtins.readFile ./config/settings.yml)
        else {};
    in
      lib.mapAttrs (name: _: {
        system = settings.${name}.system or "x86_64-linux";
        username = settings.${name}.username or "nixos";
        extraModules = settings.${name}.extraModules or [];
      }) hosts;
  
  in {
    nixosConfigurations = lib.mapAttrs (hostname: cfg:
      mkSystem {
        inherit hostname;
        inherit (cfg) system username extraModules;
      }
    ) hostConfigs;
  
    # Development shells and tools
    devShells = forAllSystems (system: {
      default = nixpkgs.legacyPackages.${system}.mkShell {
        packages = with nixpkgs.legacyPackages.${system}; [
          go
          gopls
          go-tools
        ];
      };
    });
  };
}
