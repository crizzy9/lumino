{ config, pkgs, builtins, ... }:

let
  inherit (import ./settings.nix) host users videoDriver modules;
in
{
  imports = builtins.map(module: builtins.map(m: ./modules/${module}/${m}) module) modules;

  networking.hostName = host;
  networking.networkmanager.enable = true;

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  programs.thunar.enable = true;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  system.stateVersion = "24.05";
}
