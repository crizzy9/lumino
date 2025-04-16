{ config, pkgs, ... }:

let
  inherit (import ./settings.nix) host videoDriver;
in
{
  imports = [
    ./hardware-configuration.nix
    ../../modules/core/default.nix
    ../../modules/shell/default.nix
    ../../modules/apps/system-tools.nix
    ../../modules/apps/gaming.nix
    ../../modules/apps/media.nix
    ../../modules/lang/development.nix
    ../../modules/hardware/nvidia.nix
    ../../modules/hardware/bluetooth.nix
    ../../modules/hardware/audio.nix
    ../../modules/hardware/usb.nix
    ../../modules/services/dbus.nix
    ../../modules/services/misc.nix
    ../../modules/services/ratbagd.nix
    ../../modules/services/ssh.nix
    ../../modules/services/tailscale.nix
    ../../modules/services/gnome-keyring.nix
    ../../modules/desktop/hyprland.nix
    ../../modules/desktop/wayland.nix
    ../../modules/styles/stylix.nix
    ../../home/apps/steam.nix
  ];

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
