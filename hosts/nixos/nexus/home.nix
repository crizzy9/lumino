{ config, pkgs, ... }:

let
  # Change it to userSettings
  inherit (import ./settings.nix) username host gitUsername gitEmail;
in
{
  home.username = "${username}";
  home.homeDirectory = "/home/${username}";
  home.stateVersion = "24.05";

  imports = [
    (import ../../home/tools/git.nix {
      inherit gitUsername;
      inherit gitEmail;
    })
    (import ../../home/shell/zsh/zsh.nix {
      inherit config;
      inherit host;
      inherit username;
    })
    ../../modules/lang/python.nix
    ../../home/terminal/kitty.nix
    ../../home/shell/starship.nix
    ../../home/desktop/wm/hyprland.nix
    ../../home/desktop/waybar/waybar.nix
    ../../home/desktop/launchers/rofi.nix
    ../../home/apps/neovim/neovim.nix
    ../../home/apps/tmux/tmux.nix
    ../../home/apps/yazi/yazi.nix
    ../../home/apps/atuin.nix
  ];

  home.packages = with pkgs; [
    hello
    zsh-fzf-tab
    atuin
    # pkgs.blesh
    (nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
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

  # stylix.targets.kitty.enable = false;
  stylix.targets.neovim.enable = false;
  stylix.targets.rofi.enable = false;
  stylix.targets.waybar.enable = false;
  stylix.targets.hyprland.enable = false;

  home.file = {};

  home.sessionVariables = {
    EDITOR = "nvim";
  };

  programs.home-manager.enable = true;
}
