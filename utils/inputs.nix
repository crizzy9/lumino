{
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
}
