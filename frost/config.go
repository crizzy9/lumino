package installer

import (
	"fmt"
	"os"
	"path/filepath"

	"gopkg.in/yaml.v3"
)

type Config struct {
	Title    string             `yaml:"title"`
	Version  string             `yaml:"version"`
	Profiles map[string]Profile `yaml:"profiles"`
	Settings GlobalSettings     `yaml:"settings"`
}

type Profile struct {
	Name        string            `yaml:"name"`
	Description string            `yaml:"description"`
	System      SystemConfig      `yaml:"system"`
	User        UserConfig        `yaml:"user"`
	Hardware    HardwareConfig    `yaml:"hardware"`
	Apps        []string          `yaml:"apps"`
	Environment EnvironmentConfig `yaml:"environment"`
}

type GlobalSettings struct {
	DefaultProfile string            `yaml:"default_profile"`
	Username       string            `yaml:"username"`
	Hostname       string            `yaml:"hostname"`
	Theme          string            `yaml:"theme"`
	Variables      map[string]string `yaml:"variables"`
}

type SystemConfig struct {
	Boot     BootConfig    `yaml:"boot"`
	Network  NetworkConfig `yaml:"network"`
	Services []string      `yaml:"services"`
	Packages []string      `yaml:"packages"`
}

type UserConfig struct {
	Shell       string   `yaml:"shell"`
	HomeManager bool     `yaml:"home_manager"`
	Packages    []string `yaml:"packages"`
}

type HardwareConfig struct {
	GPU         string   `yaml:"gpu"`
	Audio       string   `yaml:"audio"`
	Bluetooth   bool     `yaml:"bluetooth"`
	Peripherals []string `yaml:"peripherals"`
}

type EnvironmentConfig struct {
	Desktop     string   `yaml:"desktop"`
	DisplayMgr  string   `yaml:"display_manager"`
	WaylandApps []string `yaml:"wayland_apps"`
	X11Apps     []string `yaml:"x11_apps"`
}

type BootConfig struct {
	Loader    string `yaml:"loader"`
	Timeout   int    `yaml:"timeout"`
	DefaultOS string `yaml:"default_os"`
}

type NetworkConfig struct {
	Firewall  bool     `yaml:"firewall"`
	Wireless  bool     `yaml:"wireless"`
	Tailscale bool     `yaml:"tailscale"`
	DNS       []string `yaml:"dns"`
}

func LoadConfig(path string) (*Config, error) {
	data, err := os.ReadFile(path)
	if err != nil {
		return nil, fmt.Errorf("read config file: %w", err)
	}

	var cfg Config
	if err := yaml.Unmarshal(data, &cfg); err != nil {
		return nil, fmt.Errorf("parse config: %w", err)
	}

	return &cfg, nil
}

func (c *Config) GetProfileNames() []string {
	var names []string
	for name := range c.Profiles {
		names = append(names, name)
	}
	return names
}

func (c *Config) GetProfile(name string) *Profile {
	if p, ok := c.Profiles[name]; ok {
		return &p
	}
	return nil
}

func (c *Config) SaveGeneratedConfig(profile string, outPath string) error {
	p := c.GetProfile(profile)
	if p == nil {
		return fmt.Errorf("profile %s not found", profile)
	}

	// Generate configuration.nix
	if err := os.MkdirAll(filepath.Dir(outPath), 0755); err != nil {
		return fmt.Errorf("create output directory: %w", err)
	}

	// TODO: Generate actual NixOS configuration based on profile
	config := fmt.Sprintf(`
{ config, pkgs, ... }:

{
  imports = [ ./hardware-configuration.nix ];

  # Basic system configuration
  networking.hostName = "%s";
  users.users.%s = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" ];
    shell = pkgs.%s;
  };

  # System packages
  environment.systemPackages = with pkgs; [
    %s
  ];

  # Services
  services = {
    %s
  };

  # Hardware configuration
  hardware = {
    %s
  };

  # Boot configuration
  boot.loader = {
    %s
  };
}
`, c.Settings.Hostname, c.Settings.Username, p.User.Shell,
		formatPackageList(p.System.Packages),
		formatServices(p.System.Services),
		formatHardware(&p.Hardware),
		formatBootLoader(&p.System.Boot))

	if err := os.WriteFile(outPath, []byte(config), 0644); err != nil {
		return fmt.Errorf("write configuration: %w", err)
	}

	return nil
}

func formatPackageList(packages []string) string {
	var result string
	for _, pkg := range packages {
		result += fmt.Sprintf("\n    %s", pkg)
	}
	return result
}

func formatServices(services []string) string {
	var result string
	for _, svc := range services {
		result += fmt.Sprintf("\n    %s.enable = true;", svc)
	}
	return result
}

func formatHardware(hw *HardwareConfig) string {
	return fmt.Sprintf(`
    pulseaudio.enable = %v;
    bluetooth.enable = %v;
    opengl.enable = true;
    nvidia.prime.sync.enable = %v;`,
		hw.Audio == "pulseaudio",
		hw.Bluetooth,
		hw.GPU == "nvidia")
}

func formatBootLoader(boot *BootConfig) string {
	return fmt.Sprintf(`
    systemd-boot.enable = %v;
    timeout = %d;
    defaultEntry = "%s";`,
		boot.Loader == "systemd-boot",
		boot.Timeout,
		boot.DefaultOS)
}
