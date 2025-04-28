{ config, pkgs, ... }:
let
  # Change it to userSettings
  inherit (import ./settings.nix) username gitUsername gitEmail;
in
{
  nixpkgs = {
    overlays = [ ];
    config = {
      allowUnfree = true;
      allowUnfreePredicate = (_: true);
    };
  };

  imports = [
    ../modules/shell/zsh/zsh.nix
    ../modules/shell/neovim/neovim.nix
    ../modules/shell/tmux/tmux.nix
    # NOT working
    # ../modules/shell/yazi/yazi.nix
    # ../modules/shell/yazi/yazi2.nix
    ../modules/shell/kitty.nix
    ../modules/shell/atuin.nix
    ../modules/shell/starship.nix
  ];

  home = {
    username = username;
    homeDirectory = "/home/${username}";
    stateVersion = "24.11";
  };

  programs.git = {
    enable = true;
    userName = gitUsername;
    userEmail = gitEmail;
  };

  home.packages = with pkgs; [
  ];

  xdg = {
    userDirs = {
      enable = true;
      createDirectories = true;
    };
  };

  # stylix.targets.neovim.enable = false;
  # stylix.targets.rofi.enable = false;
  # stylix.targets.waybar.enable = false;
  # stylix.targets.hyprland.enable = false;

  home.file = {};

  home.sessionVariables = {
    EDITOR = "nvim";
    DOTFILES = "/home/${username}/lumino";
  };

  programs.home-manager.enable = true;

}
