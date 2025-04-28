{ pkgs, ... }:
{

  programs.yazi = {
    enable = true;

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

    yaziPlugins = {
      enable = true;
      git.enable = true;
      smart-filter.enable = true;
      glow.enable = true;
      diff.enable = true;
      starship.enable = true;
      # eza-preview.enable = true;
      # lazygit.enable = true;
      jump-to-char = {
        enable = true;
        keys.toggle.on = [ "F" ];
      };
      relative-motions = {
        enable = true;
        show_numbers = "relative_absolute";
        show_motions = true;
      };
    };

  };

}
