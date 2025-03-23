# Lumino OS

## Overview

This repository contains a modern NixOS installer built using Bubble Tea, a Go library for creating terminal applications. The installer reads a global settings file, detects system types, prompts for profile selection, generates necessary configurations, and handles NixOS installation. It features a user-friendly interface created with Bubble Tea and Lipgloss.

## Features

- **Profile Selection**: Choose from predefined profiles for different system types (desktop, laptop, server, etc.).
- **User Configuration**: Input your username and hostname for personalized setup.
- **Configuration Generation**: Automatically generates NixOS configuration files based on user input and selected profile.
- **Modern TUI**: A visually appealing terminal user interface using Bubble Tea and Lipgloss.
- **Cross-Platform**: Designed to work across various hardware configurations, including Raspberry Pi, WSL, and macOS.

## Directory Structure

```
.
├── cmd/                # Main application entry point
│   └── frost/          # Installer application
├── internal/           # Internal packages
│   ├── installer/      # Configuration handling
│   └── ui/             # User interface components
├── config.yaml         # Global settings and profiles
├── go.mod              # Go module file
└── README.md           # Project documentation
```

## Installation

1. **Clone the repository**:
   ```bash
   git clone https://github.com/crizzy9/.dotfiles.git
   cd .dotfiles
   ```

2. **Install Go dependencies**:
   ```bash
   go mod tidy
   ```

3. **Run the installer**:
   ```bash
   go run cmd/frost/main.go
   ```

## Configuration

The installer uses a `config.yaml` file to define global settings and profiles. Here’s a sample structure:

```yaml
title: "NixOS Configuration"
version: "1.0.0"

settings:
  default_profile: "nixos-home"
  username: "nightwatcher"
  hostname: "nixos"
  theme: "tokyo-night-dark"

profiles:
  nixos-home:
    name: "Home Desktop"
    description: "Full desktop environment with development tools"
    # Additional configuration options...
```

## Usage

1. **Launch the installer**: Run the installer as described in the installation section.
2. **Select a profile**: Use the arrow keys to navigate and press Enter to select a profile.
3. **Enter user information**: Provide your username and hostname when prompted.
4. **Confirm and install**: Review your selections and confirm to generate the NixOS configuration.

## Contributing

Contributions are welcome! Please feel free to submit a pull request or open an issue for any suggestions or improvements.

## License

This project is licensed under the AGPL License. See the LICENSE file for more details.

## Acknowledgments

- [Bubble Tea](https://github.com/charmbracelet/bubbletea) for the terminal UI framework.
- [Lipgloss](https://github.com/charmbracelet/lipgloss) for styling terminal applications.

