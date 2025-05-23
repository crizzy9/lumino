{ pkgs, ... }:
let
  yazi-plugins = pkgs.fetchFromGitHub {
    owner = "yazi-rs";
    repo = "plugins";
    rev = "main";
    hash = "sha256-4krck4U/KWmnl32HWRsblYW/biuqzDPysrEn76buRck=";
  };
in
{
  # the auto complete is not taking home manager it thinks this nixpkgs and not home-manager how to switch ?
  programs.yazi = {
    enable = true;
    plugins = {
      git = "${yazi-plugins}/git.yazi";
      smart-filter = "${yazi-plugins}/smart-filter.yazi";
      # https://yazi-rs.github.io/docs/tips/#smart-enter
      # smart-enter = "${yazi-plugins}/smart-enter.yazi";
      diff = "${yazi-plugins}/diff.yazi";
      glow = pkgs.fetchFromGitHub {
        owner = "Reledia";
        repo = "glow.yazi";
        rev = "main";
        hash = "sha256-4krck4U/KWmnl32HWRsblYW/biuqzDPysrEn76buRck=";
      };
      eza-preview = pkgs.fetchFromGitHub {
        owner = "sharklasers996";
        repo = "eza-preview.yazi";
        rev = "main";
        hash = "sha256-4krck4U/KWmnl32HWRsblYW/biuqzDPysrEn76buRck=";
      };
      # lazygit = pkgs.fetchFromGitHub {
      #   owner = "Lil-Dank";
      #   repo = "lazygit.yazi";
      #   rev = "c82794fb410cca36b23b939d32126a6a9705f94d";
      #   hash = "sha256-m2zITkjGrUjaPnzHnnlwA6d4ODIpvlBfIO0RZCBfL0E=";
      # };
      # starship = pkgs.fetchFromGitHub {
      #   owner = "Rolv-Apneseth";
      #   repo = "starship.yazi";
      #   rev = "main";
      #   hash = "sha256-4krck4U/KWmnl32HWRsblYW/biuqzDPysrEn76buRck=";
      # };
      # rsync = pkgs.fetchFromGitHub {
      #   owner = "GianniBYoung";
      #   repo = "rsync.yazi";
      #   rev = "3f431aa388a645cc95b8292659949a77c280ed8b";
      #   hash = "sha256-xQHuMGg0wQQ16VbYKKnPLdLqKB6YgUlTpOOuxNNfhj8=";
      # };
      # video-ffmpeg = "";
      # rich-preview = "";
    };
    # require("starship"):setup()
    initLua = ''
      require("git"):setup()
    '';
    flavors = {
      tokyo-night = pkgs.fetchFromGitHub {
        owner = "BennyOe";
        repo = "tokyo-night.yazi";
        rev = "024fb096821e7d2f9d09a338f088918d8cfadf34";
        hash = "sha256-IhCwP5v0qbuanjfMRbk/Uatu31rPNVChJn5Y9c5KWYQ=";
      };
    };
    # keymap = {
    #   manager.keymap = [
    #     {
    #       on = "E";
    #       run = "plugin eza-preview";
    #       desc = "Toggle tree/list view";
    #     }
    #   ];
    #   manager.prepend_keymap = [
    #     {
    #       on = ["g" "i"];
    #       run = "plugin lazygit";
    #       desc = "run lazygit";
    #     }
    #     {
    #       on = "F";
    #       run = "plugin smart-filter";
    #       desc = "Smart filter";
    #     }
    #   ];
    # };
    theme = {
      flavor = { use = "tokyo-night"; };
    };
    settings = {
      log.enable = true;
      plugin = {
        prepend_previewers = [
          { name = "*/"; run = "eza-preview"; }
          { name = "*.md"; run = "glow"; }
          { name = "*.(py|sh|java|yml|go|toml|conf|json|csv)"; run = "bat"; }
        ];
      };
      manager = {
        show_hidden = true;
        sort_by = "modified";
        sort_dir_first = true;
        sort_reverse = true;
      };
      # yazi = ''
      #   [plugin]
      #   prepend_previewers = [
      #     { name = "*.md", run = "glow" },
      #   ]
      # '';
    };
  };

}
