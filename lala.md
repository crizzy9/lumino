I am trying to update my nixos configuration but upon running rebuild switch it is giving me the following error. Also another thing to note is when i set home.sessionVariables those variables are not being set

```
error:
       … while calling the 'head' builtin
         at /nix/store/707m8gfbdyxhg1sgkiw5x9zh84ya012r-source/lib/attrsets.nix:1534:13:
         1533|           if length values == 1 || pred here (elemAt values 1) (head values) then
         1534|             head values
             |             ^
         1535|           else

       … while evaluating the attribute 'value'
         at /nix/store/707m8gfbdyxhg1sgkiw5x9zh84ya012r-source/lib/modules.nix:1084:7:
         1083|     // {
         1084|       value = addErrorContext "while evaluating the option `${showOption loc}':" value;
             |       ^
         1085|       inherit (res.defsFinal') highestPrio;

       … while evaluating the option `system.build.toplevel':

       … while evaluating definitions from `/nix/store/707m8gfbdyxhg1sgkiw5x9zh84ya012r-source/nixos/modules/system/activation/top-level.nix':

       … while evaluating the option `assertions':

       … while evaluating definitions from `/nix/store/a7sqm1zagxghg4abldh5qn7mhbxljbax-source/nixos/common.nix':

       (stack trace truncated; use '--show-trace' to show the full, detailed trace)

       error: access to absolute path '/nix/store/modules' is forbidden in pure evaluation mode (use '--impure' to override)

```

This is my current folder structure
```
hosts/nixos/default.nix
hosts/nixos/nixos/default.nix
users/home.nix
utils/systems.nix
modules/shell/
modules/core/
modules/services/
modules/hardware/
modules/apps/
flake.nix
```

This is my flake.nix
```nix
{
  nixConfig = {
    trusted-substituters = [
      "https://cachix.cachix.org"
      "https://nixpkgs.cachix.org"
      "https://nix-community.cachix.org"
    ];
    trusted-public-keys = [
      "cachix.cachix.org-1:eWNHQldwUO7G2VkjpnjDbWwy4KQ/HNxht7H4SSoMckM="
      "nixpkgs.cachix.org-1:q91R6hxbwFvDqTSDKwDAV4T5PxqXGxswD8vhONFMeOE="
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
  };

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-darwin.url = "github:nixos/nixpkgs/nixpkgs-24.11-darwin";
    nixpkgs-darwin-unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-24.11";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager-darwin = {
      url = "github:nix-community/home-manager/release-23.11";
      inputs.nixpkgs.follows = "nixpkgs-darwin";
    };
    home-manager-unstable = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
  };

  outputs =
    { nixpkgs, home-manager, ... }@inputs:
    let
      helpers = import ./utils/systems.nix inputs;
      inherit (helpers) mkMerge mkNixos mkDarwin;
      getHostDirs = path:
        let
	  isDir = name: inputs.nixpkgs.lib.filesystem.pathIsDirectory (path + "/${name}");
          dirNames = inputs.nixpkgs.lib.attrNames (inputs.nixpkgs.lib.filterAttrs (name: _: isDir name) (builtins.readDir path));
        in
          dirNames;
      # nixosHosts = getHostDirs ./hosts/nixos;
      nixosHosts = [ "nixos" ];
      nixConfigs = builtins.map (hostname:
        (mkNixos hostname inputs.nixpkgs [
          inputs.home-manager.nixosModules.home-manager
        ])
      ) nixosHosts;

      darwinHosts = builtins.filter (name: name != "default.nix") (getHostDirs ./hosts/darwin);
      darwinConfigs = builtins.map (hostname: 
        (mkDarwin hostname inputs.nixpkgs-darwin [] [])
      ) darwinHosts;
    in
    mkMerge (nixConfigs ++ darwinConfigs);
}
```

This is my utils/systems.nix
```nix
inputs:
let
  homeManagerCfg = userPackages: extraImports: {
    home-manager.useGlobalPkgs = false;
    home-manager.extraSpecialArgs = {
      inherit inputs;
    };
    home-manager.users.nightwatcher.imports = [
      ../users/home.nix
    ] ++ extraImports;
    home-manager.backupFileExtension = "bak";
    home-manager.useUserPackages = userPackages;
  };
in
{
  mkDarwin = machineHostname: nixpkgsVersion: extraHmModules: extraModules: {
    darwinConfigurations.${machineHostname} = inputs.nix-darwin.lib.darwinSystem {
      system = "aarch64-darwin";
      specialArgs = {
        inherit inputs;
      };
      modules = [
        ../hosts/darwin
        ../hosts/darwin/${machineHostname}
        inputs.home-manager-darwin.darwinModules.home-manager
        (inputs.nixpkgs-darwin.lib.attrsets.recursiveUpdate (homeManagerCfg true extraHmModules) {
          home-manager.users.${machineHostname}.home.homeDirectory =
            inputs.nixpkgs-darwin.lib.mkForce "/Users/" + machineHostname;
        })
      ];
    };
  };
  mkNixos = machineHostname: nixpkgsVersion: extraModules: rec {
    nixosConfigurations.${machineHostname} = nixpkgsVersion.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = {
        inherit inputs;
        settings = import ./hosts/nixos/${machineHostname}/settings.nix;
      };
      modules = [
	inputs.home-manager.nixosModules.home-manager
        ../hosts/nixos
        ../hosts/nixos/${machineHostname}
        (homeManagerCfg false [ ])
      ] ++ extraModules;
    };
  };
  mkMerge = inputs.nixpkgs.lib.lists.foldl' (
    a: b: inputs.nixpkgs.lib.attrsets.recursiveUpdate a b
  ) { };
}
```
This is my hosts/nixos/default.nix
```nix
{
  inputs,
  config,
  pkgs,
  lib,
  ...
}:
{
  system.stateVersion = "24.11";

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 90d";
  };
  nix.optimise.automatic = true;
  nix.optimise.dates = [ "weekly" ];

  nix.settings.experimental-features = lib.mkDefault [
    "nix-command"
    "flakes"
  ];

  nixpkgs = {
    config = {
      allowUnfree = true;
      allowUnfreePredicate = (_: true);
    };
  };

  environment.systemPackages = with pkgs; [
    wget
    iperf3
    eza
    fastfetch
    tmux
    rsync
    iotop
    ncdu
    nmap
    jq
    ripgrep
    sqlite
    lm_sensors
    pciutils
    jc
    moreutils
    lsof
    fatrace
    neovim
    yazi
    lazygit
    (python312.withPackages (ps: with ps; [pip]))
  ];

}
```

This is my hosts/nixos/nixos/default.nix where the latter `nixos` is the hostname
```nix
{ config, pkgs, lib, ... }:
{
  boot.initrd.availableKernelModules = [ "vmd" "xhci_pci" "ahci" "nvme" "usbhid" "usb_storage" "sd_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" "btintel" "btusb"];
  boot.extraModulePackages = [ ];
  boot.kernelPackages = pkgs.linuxPackages_latest;

  fileSystems."/" =
    { device = "/dev/disk/by-uuid/1f33b5f1-91a5-4b7b-97bd-c53a0adfbe20";
      fsType = "ext4";
    };

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/A6DB-75DE";
      fsType = "vfat";
      options = [ "fmask=0077" "dmask=0077" ];
    };

  swapDevices = [ ];

  networking.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

  boot = {
    loader.efi.canTouchEfiVariables = true;
    loader.grub.enable = true;
    loader.grub.device = "nodev";
    loader.grub.efiSupport = true;
    loader.grub.useOSProber = true;
  };

  time.timeZone = "America/Los_Angeles";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  networking.hostName = "nixos";
  networking.networkmanager.enable = true;

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the GNOME Desktop Environment.
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # bluetooth
  hardware.enableAllFirmware = true;
  hardware.enableRedistributableFirmware = true;
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
    settings = {
      General = {
      	# Enable = "Source,Sink,Media,Socket";
        Name = "Hello";
        ControllerMode = "dual";
        FastConnectable = "true";
        Experimental = "true";
	KernelExperimental = "true";
      };
      Policy = {
        AutoEnable = "true";
      };
    };
  };

  services.blueman.enable =  true;
  services.dbus.enable = true;

  # Enable sound with pipewire.
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.nightwatcher = {
    isNormalUser = true;
    description = "nightwatcher";
    extraGroups = [ "networkmanager" "wheel" ];
    # packages = with pkgs; [
    #  thunderbird
    # ];
  };

  # Install firefox.
  programs.firefox.enable = true;

}

```

This is my users/home.nix
```nix
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
    ../../modules/shell/zsh/zsh.nix
    ../../modules/shell/neovim/neovim.nix
    ../../modules/shell/tmux/tmux.nix
    ../../modules/shell/yazi/yazi.nix
    ../../modules/shell/kitty.nix
    ../../modules/shell/atuin.nix
    ../../modules/shell/starship.nix
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
    vim
    neovim
    tmux
    lazygit
    yazi
  ];

  # home.file = {};
  home.sessionVariables = {
    EDITOR = "nvim";
  };

  # programs.zsh.enable = true;
  programs.home-manager.enable = true;
}
```

This is my modules/shell/zsh.nix
```nix
{ config, host, username, ... }:
# TODO: add userSettings for dotfiles dir
{
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    shellAliases = {
      ".." = "cd ..";
      # pbcopy = "xclip -selection clipboard";
      # pbpaste = "xclip -selection clipboard -o";
      # pbcopy = "wl-copy";
      # pbpaste = "wl-paste";
      la = "eza -la --icons auto --group-directories-first";
      lsag = "eza -lah --icons auto --git --group-directories-first";
      lsat = "eza -lah --icons auto --git --tree -L 2 --git-ignore";
      lg = "lazygit";
      v = "nvim";
      sv = "sudo nvim";
      sync = "nh os switch --hostname ${host} /home/${username}/.dotfiles"; # rebuild = "sudo nixos-rebuild switch --flake .";
      update = "nh os switch --hostname ${host} --update /home/${username}/.dotfiles"; # update = "nix flake update";
      hs = "home-manager switch --flake .";
      pfg = "nurl $(eval pbpaste) | pbcopy"; # function for prefetch url
      y = "yazi";
      jj = "pbpaste | jq . | pbcopy";
      jjn = "pbpaste | jq . | nvim - +'set syntax=json'";
      jjj = "pbpaste | jq .";
      gs = "git status --short";
      gd = "git diff";
      ga = "git add";
      gaa = "git add --all";
      gfa = "git fetch --all --tags --prune";
      gco = "git checkout";
      gcb = "git checkout -b";
      gcd = "git checkout -D";
      gcmsg = "git commit -m";
      gopull = "git pull origin $\{git_current_branch\}";
      gopush = "git push origin $\{git_current_branch\}";
      gprom = "git pull origin $\{git_main_branch\} --rebase --autostash";
      gprum = "git pull upstream $\{git_main_branch\} --rebase --autostash";
      glom = "git pull origin $\{git_main_branch\}";
      glum = "git pull upstream $\{git_main_branch\}";
      gluc = "git pull upstream $\{git_current_branch\}";
      glgg = "git log --graph --stat";
      glo = "git log --online -graph";
      generations = "nixos-rebuild list-generations";
    };

    history.size = 10000;
    history.path = "${config.xdg.dataHome}/zsh/history";

    initExtra = builtins.readFile ./widgets.zsh;

  };

  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
    nix-direnv.enable = true;
  };

  programs.fzf.enable = true;
  programs.fzf.enableZshIntegration = true;


  programs.zoxide.enable = true;
  programs.zoxide.enableZshIntegration = true;

  programs.eza.enable = true;
  programs.eza.enableZshIntegration = true;

  # TODO: how to add these separately based on shell configuration
  programs.yazi.enableZshIntegration = true;
  programs.kitty.shellIntegration.enableZshIntegration = true;
  programs.starship.enableZshIntegration = true;
  programs.atuin.enableZshIntegration = true;

}
```
