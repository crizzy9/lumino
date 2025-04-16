{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    # hardware related
    pciutils # for things like lspci
    usbutils
    lshw
    ncdu

    # monitoring
    powertop
    btop

    # essential system packages
    vim
    wget
    git
    tree
    ripgrep
    zsh
    neofetch
    trash-cli
    
    # utilities
    yq
    jq
    ffmpeg
    fd
    glow
  ];
}
