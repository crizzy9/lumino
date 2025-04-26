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
    ../modules/shell/yazi/yazi.nix
    ../modules/shell/kitty.nix
    ../modules/shell/atuin.nix
    ../modules/shell/starship.nix
  ];

  home = {
    username = "nightwatcher";
    homeDirectory = "/home/nightwatcher";
    stateVersion = "24.11";
    # stateVersion = "24.05";
  };

  programs.git = {
    enable = true;
    userName = "crizzy9";
    userEmail = "shyampadia@live.com";
  };

  home.packages = with pkgs; [
    vim
    # neovim
    # tmux
    lazygit
    # yazi
  ];

  # home.file = {};
  home.sessionVariables = {
    EDITOR = "nvim";
  };

  # programs.zsh.enable = true;
  programs.home-manager.enable = true;

}
