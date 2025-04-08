package main

import (
	"fmt"
	"os"

	"github.com/crizzy9/LuminoOS/internal/ui"
	"github.com/crizzy9/LuminoOS/lib/installer"
)

func main() {
	cfg, err := installer.LoadConfig("config.yaml")
	if err != nil {
		fmt.Printf("Error loading config: %v\n", err)
		os.Exit(1)
	}

	app := ui.NewInstaller(cfg)
	if err := app.Run(); err != nil {
		fmt.Printf("Error running installer: %v\n", err)
		os.Exit(1)
	}
}
