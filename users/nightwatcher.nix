{ config, pkgs, ... }:

{
  nix.settings.trusted-users = [ "nightwatcher" ];

  users.users.nightwatcher = {
    # homeMode = "755";
    isNormalUser = true;
    description = "nightwatcher";
    extraGroups = [
      "networkmanager"
      "wheel"
      "libvirtd"
      "scanner"
      "lp"
      "users"
      "video"
      "podman"
      "input"
    ];
    shell = pkgs.zsh;
    ignoreShellProgramCheck = true;
    packages = with pkgs; [
      # firefox
      # obsidian
      # yazi
      # tldr
      # bat
      # spotify
      # nh
      # lazygit
    ];
  };
}
