{
  host = "nexus";
  users = ["nightwatcher"];
  videoDriver = "nvidia";
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
}
