{ config, pkgs, lib, ... }:
let
  # Change it to userSettings
  inherit (import ./settings.nix) host;
in
{
  imports = [
    # hardware
    ../../../modules/hardware/kernel.nix
    ../../../modules/hardware/bluetooth.nix
    ../../../modules/hardware/audio.nix
    ../../../modules/hardware/usb.nix
    ../../../modules/hardware/nvidia.nix
    # core
    ../../../modules/core/boot.nix
    ../../../modules/core/i18n.nix
    # user config
    ../../../users/nightwatcher.nix
  ];

  time.timeZone = "America/Los_Angeles";

  networking.hostName = host;
  networking.networkmanager.enable = true;

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the GNOME Desktop Environment.
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  environment.shells = with pkgs; [ zsh bash ];
  users.defaultUserShell = pkgs.zsh;
  programs.zsh.enable = true;

  # Install firefox.
  programs.firefox.enable = true;
  # programs.git.enable = true;

  environment.systemPackages = with pkgs; [
    # apps
    inkscape
    gimp
    mplayer
    firefox
    obsidian
    spotify
  ];

  # home-manager config
  # home-manager.sharedModules = [
  #   (_: {
  #     home.packages = with pkgs; [
  #       git
  #     ];
  #     programs.git = {
  #       enable = true;
  #       userName = "crizzy9";
  #       userEmail = "shyampadia@live.com";
  #     };
  #   })
  # ];

}
