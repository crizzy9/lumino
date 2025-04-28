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
    # ../../../modules/shell/zsh/zsh.nix
    # ../../../modules/shell/neovim/neovim.nix
    # ../../../modules/shell/tmux/tmux.nix
    # ../../../modules/shell/yazi/yazi.nix
    # ../../../modules/shell/kitty.nix
    # ../../../modules/shell/atuin.nix
    # ../../../modules/shell/starship.nix

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
    # stateVersion = "25.05";
    stateVersion = "24.11";
    # stateVersion = "24.05";
  };

  programs.git = {
    enable = true;
    userName = "crizzy9";
    userEmail = "shyampadia@live.com";
  };

  home.packages = with pkgs; [
    # vim
    # neovim
    # tmux
    # lazygit
    # yazi
  ];


  # fonts.packages = [
  #   pkgs.nerd-fonts.jetbrains-mono
  # ];

  xdg = {
    userDirs = {
      enable = true;
      createDirectories = true;
    };
  };

  home.file = {};

  home.sessionVariables = {
    EDITOR = "nvim";
  };

  # programs.zsh.enable = true;
  programs.home-manager.enable = true;

}
