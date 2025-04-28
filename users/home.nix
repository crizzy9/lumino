{ config, pkgs, ... }:
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
    username = "nightwatcher";
    homeDirectory = "/home/nightwatcher";
    stateVersion = "24.11";
  };

  programs.git = {
    enable = true;
    userName = "crizzy9";
    userEmail = "shyampadia@live.com";
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
  };

  programs.home-manager.enable = true;

}
