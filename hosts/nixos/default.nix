{
  inputs,
  config,
  pkgs,
  lib,
  modulesPath,
  ...
}:
{
  imports =
    [
      (modulesPath + "/installer/scan/not-detected.nix")
    ];

  system.stateVersion = "24.11";
  # system.stateVersion = "24.05";

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 90d";
  };
  nix.optimise.automatic = true;
  nix.optimise.dates = [ "weekly" ];

  nix.settings.experimental-features = lib.mkDefault [
    "nix-command"
    "flakes"
  ];

  nixpkgs = {
    config = {
      allowUnfree = true;
      allowUnfreePredicate = (_: true);
    };
  };

  environment.systemPackages = with pkgs; [
    wget
    iperf3
    eza
    fastfetch
    tmux
    rsync
    iotop
    ncdu
    nmap
    jq
    ripgrep
    sqlite
    lm_sensors
    pciutils
    jc
    moreutils
    lsof
    fatrace
    neovim
    yazi
    lazygit
    (python312.withPackages (ps: with ps; [pip]))
  ];

}
