{
  inputs,
  config,
  pkgs,
  lib,
  modulesPath,
  ...
}:
{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  system.stateVersion = "24.11";

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
    # nix
    nh
    nurl

    # essentials
    eza
    fastfetch
    tmux
    fd
    ripgrep
    fzf
    vim
    neovim
    yazi
    lazygit
    tldr
    bat
    glow
    atuin
    zsh-fzf-tab

    # tools
    git
    tree
    jc
    jq
    yq
    sqlite
    rsync
    wget
    iperf3
    lsof
    fatrace
    unzip
    gnumake
    ncdu
    nmap
    iotop
    powertop
    btop
    trash-cli
    ffmpeg

    # utils
    lm_sensors
    moreutils
    pciutils
    usbutils
    lshw
    ncdu
    bluez
    bluez-tools

  ];

}
