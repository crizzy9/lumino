{ pkgs, lib, ... }:
{
  programs.starship.enable = true;

  # TODO: enable transient prompt for zsh
  # https://starship.rs/advanced-config/#transientprompt-and-transientrightprompt-in-bash
  programs.starship.enableTransience = true; # NOTE: only works for fish

  # programs.starship.settings = pkgs.lib.importTOML ./starship.toml;
  programs.starship.settings = {
    "$schema" = "https://starship.rs/config-schema.json";
    format = lib.concatStrings [
      "[](surface0)"
      "$os"
      "$username"
      "[](bg:peach fg:surface0)"
      "$directory"
      "[](fg:peach bg:green)"
      "$git_branch"
      "$git_status"
      "[](fg:green bg:maroon)"
      "$c"
      "$rust"
      "$golang"
      "$nodejs"
      "$php"
      "$java"
      "$kotlin"
      "$haskell"
      "$python"
      "[](fg:maroon bg:blue)"
      "$docker_context"
      "[](fg:blue bg:purple)"
      "$time"
      "[ ](fg:purple)"
      "$line_break$characte"
    ];
    palette = "catppuccin_mocha";

    # palettes.gruvbox_dark = {
    #   color_fg0 = "#fbf1c7";
    #   color_bg1 = "#3c3836";
    #   color_bg3 = "#665c54";
    #   color_blue = "#458588";
    #   color_aqua = "#689d6a";
    #   color_green = "#98971a";
    #   color_orange = "#d65d0e";
    #   color_purple = "#b16286";
    #   color_red = "#cc241d";
    #   color_yellow = "#d79921";
    # };

    # palettes.tokyo_dark_terminal = {
    #
    # };

    palettes.catppuccin_mocha = {
      # rosewater = "#f5e0dc";
      # flamingo = "#f2cdcd";
      # pink = "#f5c2e7";
      # violet = "#cba6f7";
      red = "#f38ba8";
      maroon = "#eba0ac"; # NOTE: changed teal to maroon
      peach = "#fab387";
      # yellow = "#f9e2af";
      green = "#a6e3a1";
      # teal = "#94e2d5";
      # sky = "#89dceb";
      # sapphire = "#74c7ec";
      blue = "#89b4fa";
      lavender = "#b4befe";
      text = "#cdd6f4";
      # subtext1 = "#bac2de";
      # subtext0 = "#a6adc8";
      # overlay2 = "#9399b2";
      # overlay1 = "#7f849c";
      # overlay0 = "#6c7086";
      # surface2 = "#585b70";
      # surface1 = "#45475a";
      surface0 = "#313244";
      base = "#1e1e2e";
      mantle = "#181825";
      # crust = "#11111b";
    };

    os = {
      disabled = false;
      style = "bg:surface0 fg:text";
    };

    os.symbols = {
      Windows = "󰍲";
      Ubuntu = "󰕈";
      SUSE = "";
      Raspbian = "󰐿";
      Mint = "󰣭";
      Macos = "";
      Manjaro = "";
      Linux = "󰌽";
      Gentoo = "󰣨";
      Fedora = "󰣛";
      Alpine = "";
      Amazon = "";
      Android = "";
      Arch = "󰣇";
      Artix = "󰣇";
      CentOS = "";
      Debian = "󰣚";
      NixOS = " ";
      Redhat = "󱄛";
      RedHatEnterprise = "󱄛";
    };

    username = {
      show_always = true;
      style_user = "bg:surface0 fg:text";
      style_root = "bg:surface0 fg:text";
      format = "[ $user ]($style)";
    };

    directory = {
      style = "fg:mantle bg:peach";
      format = "[ $path ]($style)";
      truncation_length = 3;
      truncation_symbol = "…/";
    };

    directory.substitutions = {
      "~" = " ~";
      ".dotfiles" = " .dotfiles";
      "lumino" = " lumino";
      "dev" = "󰲋 dev";
      "Documents" = "󰈙 Documents";
      "Downloads" = " Downloads";
      "Music" = "󰝚 Music";
      "Pictures" = " Pictures";
    };

    git_branch = {
      symbol = " ";
      style = "bg:maroon";
      format = "[[ $symbol $branch ](fg:base bg:green)]($style)";
    };

    git_status = {
      style = "bg:maroon";
      format = "[[($all_status$ahead_behind )](fg:base bg:green)]($style)";
    };

    nodejs = {
      symbol = "";
      style = "bg:maroon";
      format = "[[ $symbol( $version) ](fg:base bg:maroon)]($style)";
    };

    c = {
      symbol = " ";
      style = "bg:maroon";
      format = "[[ $symbol( $version) ](fg:base bg:maroon)]($style)";
    };

    rust = {
      symbol = "";
      style = "bg:maroon";
      format = "[[ $symbol( $version) ](fg:base bg:maroon)]($style)";
    };

    golang = {
      symbol = "";
      style = "bg:maroon";
      format = "[[ $symbol( $version) ](fg:base bg:maroon)]($style)";
    };

    php = {
      symbol = "";
      style = "bg:maroon";
      format = "[[ $symbol( $version) ](fg:base bg:maroon)]($style)";
    };

    java = {
      symbol = " ";
      style = "bg:maroon";
      format = "[[ $symbol( $version) ](fg:base bg:maroon)]($style)";
    };

    kotlin = {
      symbol = "";
      style = "bg:maroon";
      format = "[[ $symbol( $version) ](fg:base bg:maroon)]($style)";
    };

    haskell = {
      symbol = "";
      style = "bg:maroon";
      format = "[[ $symbol( $version) ](fg:base bg:maroon)]($style)";
    };

    python = {
      symbol = "";
      style = "bg:maroon";
      format = "[[ $symbol( $version) ](fg:base bg:maroon)]($style)";
    };

    docker_context = {
      symbol = "";
      style = "bg:mantle";
      format = "[[ $symbol( $context) ](fg:#83a598 bg:color_bg3)]($style)";
    };

    time = {
      disabled = false;
      time_format = "%R";
      style = "bg:peach";
      format = "[[   $time ](fg:mantle bg:purple)]($style)";
    };

    line_break.disabled = false;

    character = {
      disabled = false;
      success_symbol = "[](bold fg:green)";
      error_symbol = "[](bold fg:red)";
      vimcmd_symbol = "[](bold fg:creen)";
      vimcmd_replace_one_symbol = "[](bold fg:purple)";
      vimcmd_replace_symbol = "[](bold fg:purple)";
      vimcmd_visual_symbol = "[](bold fg:lavender)";
    };
  };
}
