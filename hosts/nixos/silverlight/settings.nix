{
  host = "nexus";
  users = ["nightwatcher"];
  videoDriver = "nvidia";
  modules = {
    apps = [
      "atuin"
      "tmux"
      "yazi"
      "neovim"
    ];
    core = [
      "boot"
      "network"
    ];
    desktop = [
      "hyprland"
    ];
  };
}
