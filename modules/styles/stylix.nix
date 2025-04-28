{ pkgs, ... }:
# let
#   themePath = "../../themes/tokyo-night-dark.yaml";
# in
{
  # move to home manager
  stylix = {
    enable = true;
    image = ../../assets/wallpapers/light/lofi-light.jpg;
    # https://github.com/tinted-theming/schemes/blob/spec-0.11/base16/tokyo-night-dark.yaml
    # base16Scheme = "./${themePath}";
    base16Scheme = "${pkgs.base16-schemes}/share/themes/tokyodark-terminal.yaml";
    polarity = "dark";
    opacity.terminal = 0.9;
    cursor.package = pkgs.bibata-cursors;
    cursor.name = "Bibata-Modern-Ice";
    cursor.size = 24;
    fonts = {
      # monospace = {
      #   package = pkgs.nerdfonts.override { fonts = [ "JetBrainsMono" ]; };
      #   name = "JetBrainsMono Nerd Font Mono";
      # };
      sizes = {
        applications = 12;
        terminal = 15;
        desktop = 11;
        popups = 12;
      };

      serif = {
        package = pkgs.dejavu_fonts;
        name = "DejaVu Serif";
      };

      sansSerif = {
        package = pkgs.dejavu_fonts;
        name = "DejaVu Sans";
      };

      monospace = {
        package = pkgs.dejavu_fonts;
        name = "DejaVu Sans Mono";
      };

      emoji = {
        package = pkgs.noto-fonts-emoji;
        name = "Noto Color Emoji";
      };

    };
  };

  # fonts = {
  #
  #   serif = {
  #     package = pkgs.dejavu_fonts;
  #     name = "DejaVu Serif";
  #   };
  #
  #   sansSerif = {
  #     package = pkgs.dejavu_fonts;
  #     name = "DejaVu Sans";
  #   };
  #
  #   monospace = {
  #     package = pkgs.dejavu_fonts;
  #     name = "DejaVu Sans Mono";
  #   };
  #
  #   noto-fonts-emoji = {
  #     package = pkgs.noto-fonts-emoji;
  #     name = "Noto Color Emoji";
  #   };
  #
  #   symbola = {
  #     package = pkgs.symbola;
  #     name = "Symbola";
  #   };
  #
  #   # material-icons = {
  #   #   package = pkgs.material-icons;
  #   #   name = "Material Icons";
  #   # };
  #
  #   # packages = with pkgs; [
  #   #   noto-fonts-emoji
  #   #   noto-fonts-cjk-sans
  #   #   font-awesome
  #   #   symbola
  #   #   material-icons
  #   # ];
  # };
}
