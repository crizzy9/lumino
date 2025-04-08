package ui

import (
	"fmt"
	"os"
	"strings"

	"github.com/charmbracelet/bubbles/list"
	"github.com/charmbracelet/bubbles/spinner"
	"github.com/charmbracelet/bubbles/textinput"
	tea "github.com/charmbracelet/bubbletea"
	"github.com/charmbracelet/lipgloss"
	"github.com/crizzy9/dotfiles/internal/installer"
)

var (
	titleStyle = lipgloss.NewStyle().
			Bold(true).
			Foreground(lipgloss.Color("#7e9cd8")).
			MarginLeft(2)

	subtitleStyle = lipgloss.NewStyle().
			Foreground(lipgloss.Color("#957fb8")).
			MarginLeft(2)

	itemStyle = lipgloss.NewStyle().
			PaddingLeft(4)

	selectedItemStyle = lipgloss.NewStyle().
				PaddingLeft(2).
				Foreground(lipgloss.Color("#7aa2f7"))

	paginationStyle = list.DefaultStyles().PaginationStyle.PaddingLeft(4)
	helpStyle       = list.DefaultStyles().HelpStyle.PaddingLeft(4).PaddingBottom(1)
)

type state int

const (
	stateInit state = iota
	stateProfileSelect
	stateUserConfig
	stateConfirm
	stateInstalling
	stateDone
)

type item struct {
	title       string
	description string
}

func (i item) Title() string       { return i.title }
func (i item) Description() string { return i.description }
func (i item) FilterValue() string { return i.title }

type model struct {
	config   *installer.Config
	state    state
	list     list.Model
	username textinput.Model
	hostname textinput.Model
	spinner  spinner.Model
	err      error
	width    int
	height   int
	profile  string
	quitting bool
}

func NewInstaller(cfg *installer.Config) *tea.Program {
	m := model{
		config:   cfg,
		state:    stateInit,
		spinner:  spinner.New(spinner.WithStyle(lipgloss.NewStyle().Foreground(lipgloss.Color("#7aa2f7")))),
		username: textinput.New(),
		hostname: textinput.New(),
	}

	var items []list.Item
	for name, profile := range cfg.Profiles {
		items = append(items, item{title: name, description: profile.Description})
	}

	m.list = list.New(items, list.NewDefaultDelegate(), 0, 0)
	m.list.Title = "Select NixOS Profile"
	m.list.SetShowTitle(false)
	m.list.Styles.Title = titleStyle
	m.list.Styles.PaginationStyle = paginationStyle
	m.list.Styles.HelpStyle = helpStyle

	m.username.Placeholder = "Enter username"
	m.username.Focus()
	m.hostname.Placeholder = "Enter hostname"

	return tea.NewProgram(m)
}

func (m model) Init() tea.Cmd {
	return tea.Batch(
		spinner.Tick,
		textinput.Blink,
	)
}

func (m model) Update(msg tea.Msg) (tea.Model, tea.Cmd) {
	switch msg := msg.(type) {
	case tea.WindowSizeMsg:
		m.width = msg.Width
		m.height = msg.Height
		m.list.SetWidth(msg.Width)
		m.list.SetHeight(msg.Height - 4)
		return m, nil

	case tea.KeyMsg:
		switch msg.String() {
		case "ctrl+c", "q":
			m.quitting = true
			return m, tea.Quit

		case "enter":
			switch m.state {
			case stateInit:
				m.state = stateProfileSelect
				return m, nil

			case stateProfileSelect:
				if i, ok := m.list.SelectedItem().(item); ok {
					m.profile = i.title
					m.state = stateUserConfig
					return m, nil
				}

			case stateUserConfig:
				if m.username.Value() != "" && m.hostname.Value() != "" {
					m.state = stateConfirm
					return m, nil
				}

			case stateConfirm:
				m.state = stateInstalling
				return m, tea.Batch(
					spinner.Tick,
					func() tea.Msg {
						// Generate NixOS configuration
						err := m.config.SaveGeneratedConfig(m.profile, "/etc/nixos/configuration.nix")
						if err != nil {
							return err
						}
						return nil
					},
				)
			}
		}
	}

	var cmd tea.Cmd
	switch m.state {
	case stateProfileSelect:
		m.list, cmd = m.list.Update(msg)
		return m, cmd

	case stateUserConfig:
		if m.username.Focused() {
			m.username, cmd = m.username.Update(msg)
			return m, cmd
		}
		m.hostname, cmd = m.hostname.Update(msg)
		return m, cmd

	case stateInstalling:
		m.spinner, cmd = m.spinner.Update(msg)
		return m, cmd
	}

	return m, nil
}

func (m model) View() string {
	if m.quitting {
		return "Thanks for using NixOS Installer!\n"
	}

	var s strings.Builder

	switch m.state {
	case stateInit:
		s.WriteString(titleStyle.Render("Welcome to NixOS Installer"))
		s.WriteString("\n\n")
		s.WriteString(subtitleStyle.Render("Press ENTER to continue"))

	case stateProfileSelect:
		s.WriteString(m.list.View())

	case stateUserConfig:
		s.WriteString(titleStyle.Render("System Configuration"))
		s.WriteString("\n\n")
		s.WriteString(fmt.Sprintf("Username: %s\n", m.username.View()))
		s.WriteString(fmt.Sprintf("Hostname: %s\n", m.hostname.View()))

	case stateConfirm:
		s.WriteString(titleStyle.Render("Confirm Installation"))
		s.WriteString("\n\n")
		s.WriteString(itemStyle.Render(fmt.Sprintf("Profile: %s\n", m.profile)))
		s.WriteString(itemStyle.Render(fmt.Sprintf("Username: %s\n", m.username.Value())))
		s.WriteString(itemStyle.Render(fmt.Sprintf("Hostname: %s\n", m.hostname.Value())))
		s.WriteString("\nPress ENTER to begin installation...")

	case stateInstalling:
		s.WriteString(titleStyle.Render("Installing NixOS"))
		s.WriteString("\n\n")
		s.WriteString(fmt.Sprintf("%s Generating configuration...\n", m.spinner.View()))

	case stateDone:
		s.WriteString(titleStyle.Render("Installation Complete!"))
		s.WriteString("\n\n")
		s.WriteString(subtitleStyle.Render("Your NixOS system is ready. Please reboot to start using it."))
	}

	return s.String()
}
