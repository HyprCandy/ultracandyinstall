#!/bin/bash

# HyprCandy Installer Script
# This script installs Hyprland and related packages from AUR

#set -e  # Exit on any error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
WHITE='\033[1;37m'
MAGENTA='\033[1;35m'
LIGHT_BLUE='\033[1;34m'
LIGHT_GREEN='\033[1;32m'
LIGHT_RED='\033[1;31m'
NC='\033[0m' # No Color

# Global variables
DISPLAY_MANAGER=""
DISPLAY_MANAGER_SERVICE=""
SHELL_CHOICE=""
PANEL_CHOICE=waybar
BROWSER_CHOICE=""

# Function to display multicolored ASCII art
show_ascii_art() {
    clear
    echo
    # HyprCandy in gradient colors
    echo -e "${PURPLE}██╗  ██╗██╗   ██╗██████╗ ██████╗  ${MAGENTA}██████╗ █████╗ ███╗   ██╗██████╗ ██╗   ██╗${NC}"
    echo -e "${PURPLE}██║  ██║╚██╗ ██╔╝██╔══██╗██╔══██╗${MAGENTA}██╔════╝██╔══██╗████╗  ██║██╔══██╗╚██╗ ██╔╝${NC}"
    echo -e "${LIGHT_BLUE}███████║ ╚████╔╝ ██████╔╝██████╔╝${CYAN}██║     ███████║██╔██╗ ██║██║  ██║ ╚████╔╝${NC}"
    echo -e "${BLUE}██╔══██║  ╚██╔╝  ██╔═══╝ ██╔══██╗${CYAN}██║     ██╔══██║██║╚██╗██║██║  ██║  ╚██╔╝${NC}"
    echo -e "${BLUE}██║  ██║   ██║   ██║     ██║  ██║${LIGHT_GREEN}╚██████╗██║  ██║██║ ╚████║██████╔╝   ██║${NC}"
    echo -e "${GREEN}╚═╝  ╚═╝   ╚═╝   ╚═╝     ╚═╝  ╚═╝${LIGHT_GREEN} ╚═════╝╚═╝  ╚═╝╚═╝  ╚═══╝╚═════╝    ╚═╝${NC}"
    echo
    # Installer in different colors
    echo -e "${BLUE}██╗███╗   ██╗███████╗████████╗ ${LIGHT_RED}█████╗ ██╗     ██╗     ███████╗██████╗${NC}"
    echo -e "${BLUE}██║████╗  ██║██╔════╝╚══██╔══╝${LIGHT_RED}██╔══██╗██║     ██║     ██╔════╝██╔══██╗${NC}"
    echo -e "${RED}██║██╔██╗ ██║███████╗   ██║   ${LIGHT_RED}███████║██║     ██║     █████╗  ██████╔╝${NC}"
    echo -e "${RED}██║██║╚██╗██║╚════██║   ██║   ${CYAN}██╔══██║██║     ██║     ██╔══╝  ██╔══██╗${NC}"
    echo -e "${LIGHT_RED}██║██║ ╚████║███████║   ██║   ${CYAN}██║  ██║███████╗███████╗███████╗██║  ██║${NC}"
    echo -e "${CYAN}╚═╝╚═╝  ╚═══╝╚══════╝   ╚═╝   ╚═╝  ╚═╝╚══════╝╚══════╝╚══════╝╚═╝  ╚═╝${NC}"
    echo
    # Decorative line with gradient
    echo -e "${PURPLE}════════════════════${MAGENTA}════════════════════${CYAN}════════════════════${YELLOW}═════════${NC}"
    echo -e "${WHITE}                    Welcome to the HyprCandy Installer!${NC}"
    echo -e "${PURPLE}════════════════════${MAGENTA}════════════════════${CYAN}════════════════════${YELLOW}═════════${NC}"
    echo
}

# Function to print colored output
print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Function to choose display manager
choose_display_manager() {
    print_status "For old users remove rofi-wayland through 'sudo pacman -Rnsd rofi-wayland' then clear cache through 'sudo pacman -Scc'"
    echo -e "${CYAN}Choose your display manager:${NC}"
    echo "1) SDDM with Sugar Candy theme (HyprCandy automatic background set according to applied wallpaper)"
    echo "2) GDM with GDM settings app (GNOME Display Manager and customization app)"
    echo
    
    while true; do
        echo -e "${YELLOW}Enter your choice (1 for SDDM, 2 for GDM):${NC}"
        read -r dm_choice
        case $dm_choice in
            1)
                DISPLAY_MANAGER="sddm"
                DISPLAY_MANAGER_SERVICE="sddm"
                print_status "Selected SDDM with Sugar Candy theme and HyprCandy automatic background setting"
                break
                ;;
            2)
                DISPLAY_MANAGER="gdm"
                DISPLAY_MANAGER_SERVICE="gdm"
                print_status "Selected GDM with GDM settings app"
                break
                ;;
            *)
                print_error "Invalid choice. Please enter 1 or 2."
                ;;
        esac
    done
}

choose_panel() {
    echo -e "${CYAN}Choose your panel: you can also rerun the script to switch from either or regenerate HyprCandy's default panel setup:${NC}"
    echo -e "${GREEN}1) Waybar${NC}"
    echo "   • Light with fast startup/reload for a 'taskbar' like experience"
    echo "   • Highly customizable manually"
    echo "   • Waypaper integration: loads colors through waypaper backgrounds"
    echo "   • Fast live wallpaper application through caching and easier background setup"
    echo ""
    echo -e "${GREEN}2) Hyprpanel${NC}"
    echo "   • Easy to theme through its interface"
    echo "   • Has an autohide feature when only one window is open"
    echo "   • Much slower to relaunch after manually killing (when multiple windows are open)"
    echo "   • Recommended for users who don't mind an always-on panel"
    echo "   • Longer process to set backgrounds and slower for live backgrounds"
    echo ""
    
    read -rp "Enter 1 or 2: " panel_choice
    case $panel_choice in
        1) PANEL_CHOICE="waybar" ;;
        2) PANEL_CHOICE="hyprpanel" ;;
        *) 
            print_error "Invalid choice. Please enter 1 or 2."
            echo ""
            choose_panel  # Recursively ask again
            ;;
    esac
    echo -e "${GREEN}Panel selected: $PANEL_CHOICE${NC}"
}

choose_browser() {
    echo -e "${CYAN}Choose your browser:${NC}"
    echo "1) Brave (Seemless integration with HyprCandy GTK and Qt theme through its Appearance settings, fast, secure and privacy-focused browser)"
    echo "2) Firefox (Themed through python-pywalfox by running pywalfox update in the terminal, open-source browser with a focus on privacy)"
    echo "3) Zen Browser (Themed through zen mods and slightly through python-pywalfox by running pywalfox update in the terminal, open-source browser with a focus on privacy)"
    echo "4) Librewolf (Open-source browser with a focus on privacy, highly customizable manually)"
    echo "5) Other (Please install your own browser post-installation)"
    read -rp "Enter 1, 2, 3, 4 or 5: " browser_choice
    case $browser_choice in
        1) BROWSER_CHOICE="brave" ;;
        2) BROWSER_CHOICE="firefox" ;;
        3) BROWSER_CHOICE="zen-browser-bin" ;;
        4) BROWSER_CHOICE="librewolf" ;;
        5) BROWSER_CHOICE="Other" ;;
        *) print_error "Invalid choice. Please enter 1, 2, 3, 4 or 5." ;;
    esac
    echo -e "${GREEN}Browser selected: $BROWSER_CHOICE${NC}"
}

# Function to choose shell
choose_shell() {
    echo -e "${CYAN}Choose your shell: you can also rerun the script to switch from either or regenerate HyprCandy's default shell setup:${NC}"
    echo "1) Fish - A modern shell with builtin fzf search, intelligent autosuggestions and syntax highlighting (Fisher plugins + Starship prompt)"
    echo "2) Zsh - Powerful shell with extensive customization (Zsh plugins + Oh My Zsh + Starship prompt)"
    echo
    
    while true; do
        echo -e "${YELLOW}Enter your choice (1 for Fish, 2 for Zsh):${NC}"
        read -r shell_choice
        case $shell_choice in
            1)
                SHELL_CHOICE="fish"
                print_status "Selected Fish shell with builtin features, plugins and Starship configuration"
                break
                ;;
            2)
                SHELL_CHOICE="zsh"
                print_status "Selected Zsh with plugins, Oh My Zsh integration and Starship configuration"
                break
                ;;
            *)
                print_error "Invalid choice. Please enter 1 or 2."
                ;;
        esac
    done
}

# Function to install yay
install_yay() {
    print_status "Installing yay..."
    cd /tmp
    git clone https://aur.archlinux.org/yay.git
    cd yay
    makepkg -si --noconfirm
    cd /tmp
    rm -rf yay
    print_success "yay installed successfully!"
}

# Function to install paru
install_paru() {
    print_status "Installing paru..."
    cd /tmp
    git clone https://aur.archlinux.org/paru.git
    cd paru
    makepkg -si --noconfirm
    cd /tmp
    rm -rf paru
    print_success "paru installed successfully!"
}

# Check if AUR helper is installed or install one
check_or_install_aur_helper() {
    if command -v yay &> /dev/null; then
        AUR_HELPER="yay"
        print_status "Found yay - using as AUR helper"
    elif command -v paru &> /dev/null; then
        AUR_HELPER="paru"
        print_status "Found paru - using as AUR helper"
    else
        print_warning "No AUR helper found. You need to install one."
        echo
        echo "Available AUR helpers:"
        echo "1) yay - Yet Another Yogurt (Go-based, fast)"
        echo "2) paru - Paru is based on yay (Rust-based, feature-rich)"
        echo
        while true; do
            echo -e "${YELLOW}Choose which AUR helper to install (1 for yay, 2 for paru):${NC}"
            read -r choice
            case $choice in
                1)
                    # Check if base-devel and git are installed
                    print_status "Ensuring base-devel and git are installed..."
                    sudo pacman -S --needed --noconfirm base-devel git
                    install_yay
                    AUR_HELPER="yay"
                    break
                    ;;
                2)
                    # Check if base-devel and git are installed
                    print_status "Ensuring base-devel and git are installed..."
                    sudo pacman -S --needed --noconfirm base-devel git
                    install_paru
                    AUR_HELPER="paru"
                    break
                    ;;
                *)
                    print_error "Invalid choice. Please enter 1 or 2."
                    ;;
            esac
        done
    fi
}

# Function to build package list based on display manager choice
build_package_list() {
    packages=(
        # Hyprland ecosystem
        "hyprland"
        "hyprcursor"
        "hyprgraphics"
        "hypridle"
        "hyprland-protocols"
        "hyprland-qt-support"
        "hyprlang"
        "hyprlock"
        "hyprpaper"
        "hyprpicker"
        "hyprpolkitagent"
        "hyprsunset"
        "hyprutils"
        "hyprwayland-scanner"
        "xdg-desktop-portal"
        "xdg-desktop-portal-hyprland"
        "xdg-desktop-portal-gtk"
        
        # Packages
        "pacman-contrib"
        "octopi"
        "rebuild-detector"
        "equibop-bin"
        
        # Dependacies
        "meson" 
        "cpio" 
        "cmake"
        
        # GNOME components (always include gnome-control-center and gnome-tweaks)
        #"mutter"
        #"gnome-control-center"
        #"gnome-tweaks"
        "gvfs"
        "gnome-disk-utility"
        "gnome-color-manager"
        #"gnome-weather"
        "gnome-calendar"
        "gnome-system-monitor"
        "gnome-calculator"
        "evince"
        
        # Terminals and file manager
        "kitty"
        "nautilus"
        
        # Qt and GTK theming
        "adw-gtk-theme"
        "qt5ct-kde"
        "qt5ct-wayland"
        "qt5-imageformats"
        "qt5-graphicaleffects"
        "qt5-quickcontrols2"
        "qt6ct-kde"
        "qt6ct-wayland"
        "attica"
        "frameworkintegration" 
        "knewstuff" 
        "syndication" 
        "darkly-bin"
        "archlinux-xdg-menu" 
        "kservice"
        "nwg-look"
        
        # System utilities
        "blueman"
        "nwg-displays"
        "wlogout"
        "uwsm"
        "quickshell"
        "flatpak"
        
        # Application launchers and menus
        "rofi"
        "rofi-emoji"
        "rofi-nerdy"
        "nwg-dock-hyprland"
        
        # Wallpaper and screenshot tools
        "swww"
        "grimblast-git"
        "wob"
        "wf-recorder"
        "slurp"
        "satty"
        
        # System tools
        "brightnessctl"
        "playerctl"
        "power-profiles-daemon"
        
        # Audio system
        "pipewire"
        "pipewire-jack"
        "pipewire-pulse"
        "pipewire-alsa"
        "alsa-utils"
        
        # System monitoring
        "btop"
        "nvtop"
        "htop"
        
        # Customization
        "matugen-bin"
        "hyprviz-bin"
        
        # Editors
        "gedit"
        "neovim"
        "micro"
        
        # Utilities
        "zip"
        "p7zip"
        "wtype"
        "cava"
        "downgrade"
        "ntfs-3g"
        "fuse"
        "video-trimmer"
        "eog"
        "inotify-tools"
        "bc"
        "libnotify"
        "pyprland"
        
        # Fonts and emojis
        "ttf-dejavu-sans-code"
        "ttf-cascadia-code-nerd"
        "ttf-cascadia-mono-nerd"
        "ttf-fantasque-nerd"
        "ttf-firacode-nerd"
        "ttf-jetbrains-mono-nerd"
        "ttf-nerd-fonts-symbols"
        "ttf-nerd-fonts-symbols-common"
        "ttf-nerd-fonts-symbols-mono"
        "ttf-meslo-nerd"
        "powerline-fonts"
        "noto-fonts-emoji"
        "noto-color-emoji-fontconfig"
        "awesome-terminal-fonts"
        
        # Clipboard
        "cliphist"
        
        # Browser and themes
        #"adw-gtk-theme"
        #"adwaita-qt6"   Keeping the libadwaita default which is themed by my matugen setup
        #"adwaita-qt-git"
        "tela-circle-icon-theme-all"
        
        # Cursor themes
        "bibata-cursor-theme-bin"
        "qogir-cursor-theme"
        
        # Entertainment
        "spotify-launcher"
        
        # System info
        "fastfetch"
        
        # GTK development libraries
        "gtkmm-4.0"
        "gtksourceview3"
        "gtksourceview4"
        "gtksourceview5"

        # Fun stuff
        "asciiquarium"
        "tty-clock"
        "cmatrix"
        "pipes.sh"
        
        # Configuration management
        "stow"
    )
    
    # Add display manager specific packages
    if [ "$DISPLAY_MANAGER" = "sddm" ]; then
        packages+=("sddm" "sddm-sugar-candy-git")
        print_status "Added SDDM and Sugar Candy theme to package list"
    elif [ "$DISPLAY_MANAGER" = "gdm" ]; then
        packages+=("gdm" "gdm-settings")
        print_status "Added GDM and GDM settings to package list"
    fi
    
    # Add shell specific packages
    if [ "$SHELL_CHOICE" = "fish" ]; then
        packages+=(
            "fish"
            "fisher"
            "starship"
        )
        print_status "Added Fish shell and modern tools to package list"
    elif [ "$SHELL_CHOICE" = "zsh" ]; then
        packages+=(
            "zsh"
            "zsh-completions"
            "zsh-autosuggestions"
            "zsh-history-substring-search"
            "zsh-syntax-highlighting"
            "starship"
            "oh-my-zsh-git"
        )
        print_status "Added Zsh and Oh My Zsh ecosystem with Starship to package list"
    fi
    
    
    # Add panel based on user choice
    if [ "$PANEL_CHOICE" = "waybar" ]; then
        packages+=(
        "waybar"
        "waypaper"
        "swaync"
        )
        print_status "Added Waybar to package list"
    else
        packages+=(
        "ags-hyprpanel-git"
        "mako"
        )
        print_status "Added Hyprpanel to package list"
    fi

    # Add browser based on user choice
    if [ "$BROWSER_CHOICE" = "brave" ]; then
        packages+=(
            "brave-bin"
        )
        print_status "Added Brave to package list"
    elif [ "$BROWSER_CHOICE" = "firefox" ]; then
        packages+=(
            "firefox"
            "python-pywalfox"
        )
        print_status "Added Firefox to package list"
    elif [ "$BROWSER_CHOICE" = "zen-browser-bin" ]; then
        packages+=(
            "zen-browser-bin"
            "python-pywalfox"
        )
        print_status "Added Zen Browser to package list"
    elif [ "$BROWSER_CHOICE" = "librewolf" ]; then
        packages+=(
            "librewolf"
            "python-pywalfox"
        )
        print_status "Added Librewolf to package list"
    elif [ "$BROWSER_CHOICE" = "Other" ]; then
        print_status "Please install your own browser post-installation"
    fi
}

# Function to install packages
install_packages() {
    print_status "Handling conflicting packages first..."
    if pacman -Qi jack &>/dev/null; then
        print_status "Removing jack package..."
        $AUR_HELPER -Rdd --noconfirm jack
    else
        echo ""
    fi
    
    print_status "Starting installation of ${#packages[@]} packages using $AUR_HELPER..."
    
    # Install packages in batches to avoid potential issues
    local batch_size=10
    local total=${#packages[@]}
    local installed=0
    local failed=()
    
    for ((i=0; i<total; i+=batch_size)); do
        local batch=("${packages[@]:i:batch_size}")
        print_status "Installing batch $((i/batch_size + 1)): ${batch[*]}"
        
        if $AUR_HELPER -S --noconfirm --needed "${batch[@]}"; then
            installed=$((installed + ${#batch[@]}))
            print_success "Batch $((i/batch_size + 1)) installed successfully"
        else
            print_warning "Some packages in batch $((i/batch_size + 1)) failed to install"
            # Try installing packages individually to identify failures
            for pkg in "${batch[@]}"; do
                if ! $AUR_HELPER -S --needed "$pkg"; then
                    failed+=("$pkg")
                    print_error "Failed to install: $pkg"
                else
                    installed=$((installed + 1))
                fi
            done
        fi
        
        # Small delay between batches
        sleep 2
    done
    
    print_status "Installation completed!"
    print_success "Successfully installed: $installed packages"
    
    if [ ${#failed[@]} -gt 0 ]; then
        print_warning "Failed to install ${#failed[@]} packages:"
        printf '%s\n' "${failed[@]}"
        echo
        print_status "You can try installing failed packages manually:"
        echo "$AUR_HELPER -S ${failed[*]}"
    fi

    # Prevent notification daemon conflicts
    if [ "$PANEL_CHOICE" = "waybar" ]; then
        if pacman -Qi mako &>/dev/null; then
            print_status "Removing mako since you chose waybar to avoid conflicts with swaync..."
            $AUR_HELPER -R --noconfirm mako
        else
            echo ""
        fi
    else
        if pacman -Qi swaync &>/dev/null; then
            print_status "Removing swaync since you chose hyprpanel to avoid conflicts with mako..."
            $AUR_HELPER -R --noconfirm swaync
        else
            echo ""
        fi
    fi
    
    # Add flathub repo
    flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
}

# Function to setup Fish shell configuration
setup_fish() {
    print_status "Setting up Fish shell configuration..."
    
    # Set Fish as default shell
    if command -v fish &> /dev/null; then
        print_status "Setting Fish as default shell..."
        chsh -s $(which fish)
        print_success "Fish set as default shell"
    else
        print_error "Fish not found. Please install Fish first."
        return 1
    fi
    
    # Ensure Fisher function exists
mkdir -p ~/.config/fish/functions
curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish -o ~/.config/fish/functions/fisher.fish

# Now install plugins using fisher (must be in a proper Fish shell)
fish -c '
    fisher install jorgebucaran/fisher
    fisher install \
        jorgebucaran/autopair.fish \
        jethrokuan/z \
        patrickf1/fzf.fish \
        franciscolourenco/done
'
    
    # Configure Starship prompt
    if command -v starship &> /dev/null; then
        print_status "Configuring Starship prompt for Fish..."
        
        # Add Starship to Fish config
        echo 'starship init fish | source' >> "$HOME/.config/fish/config.fish"
        
        # Create Starship config
        mkdir -p "$HOME/.config"
        cat > "$HOME/.config/starship.toml" << 'EOF'
# Starship Configuration for HyprCandy
format = """
$username\
$hostname\
$time $directory\
$git_branch\
$git_state\
$git_status\
$git_metrics\
$fill\
$nodejs\
$python\
$rust\
$golang\
$php\
$java\
$kotlin\
$haskell\
$swift\
$cmd_duration $jobs\
$line_break\
$character"""

[fill]
symbol = ""

[username]
style_user = "bold blue"
style_root = "bold red"
format = "[󱞬](grey) [](green) [](grey) [$user](grey) [](green) ($style)"
show_always = true

[directory]
style = "blue"
read_only = " 🔒"
truncation_length = 4
truncate_to_repo = false

[character]
success_symbol = "[󱞪](grey) [](green)"
error_symbol = "[󱞪](grey) [x](red)"
vimcmd_symbol = "[󱞪](grey) [](green)"

[git_branch]
symbol = "[](green) 🌱 "
truncation_length = 4
truncation_symbol = ""
style = "blue"

[git_status]
ahead = "⇡${count}"
diverged = "⇕⇡${ahead_count}⇣${behind_count}"
behind = "⇣${count}"
deleted = "x"

[nodejs]
symbol = "[](green) 💠 "
style = "bold grey"

[python]
symbol = "[](green) 🐍 "
style = "bold yellow"

[rust]
symbol = "[](green) ⚙️ "
style = "bold red"

[time]
format = '[](grey) [\[ $time \]](grey) [](green)($style)'#🕙
time_format = "%T"
disabled = false
style = "bright-white"

[cmd_duration]
format = "[](green) ⏱️ [$duration]($style)"
style = "yellow"

[jobs]
symbol = "[](green) ⚡ "
style = "bold blue"
EOF
        
        print_success "Starship configured for Fish"
    fi
    
    # Add useful Fish functions and aliases
    cat > "$HOME/.config/fish/config.fish" << 'EOF'
# HyprCandy Fish Configuration

# Set environment variables
set -gx HYPRLAND_LOG_WS 1
set -x EDITOR micro
set -x BROWSER firefox
set -x TERMINAL kitty

# Add local bin to PATH
if test -d ~/.local/bin
    set -x PATH ~/.local/bin $PATH
end

# Aliases
alias hyprcandy="cd .hyprcandy && git pull && stow --ignore='Candy' --ignore='Candy-Images' --ignore='Dock-SVGs' --ignore='Gifs' --ignore='Logo' --ignore='transparent.png' --ignore='GJS' --ignore='Candy.desktop' --ignore='HyprCandy.png' --ignore='candy-daemon.js' --ignore='candy-launcher.sh' --ignore='toggle-control-center.sh' --ignore='toggle-media-player.sh' --ignore='toggle-system-monitor.sh' --ignore='toggle-weather-widget.sh' --ignore='toggle-hyprland-settings.sh' --ignore='candy-system-monitor.js' --ignore='resources' --ignore='src' --ignore='meson.build' --ignore='README.md' --ignore='run.log' --ignore='test_layout.js' --ignore='test_media_menu.js' --ignore='toggle.js' --ignore='toggle-main.js' --ignore='~' --ignore='candy-main.js' --ignore='gjs-media-player.desktop' --ignore='gjs-toggle-controls.desktop' --ignore='main.js' --ignore='media-main.js' --ignore='SEEK_FEATURE.md' --ignore='setup-custom-icon.sh' --ignore='weather-main.js' */"
alias ll="ls -alF"
alias la="ls -A"
alias l="ls -CF"
alias ..="cd .."
alias ...="cd ../.."
alias grep="grep --color=auto"
alias fgrep="fgrep --color=auto"
alias egrep="egrep --color=auto"
alias update="sudo pacman -Syu"
alias install="sudo pacman -S"
alias search="pacman -Ss"
alias remove="sudo pacman -R"
alias autoremove="sudo pacman -Rs (pacman -Qtdq)"
alias cls="clear"
alias h="history"
alias j="jobs -l"
alias df="df -h"
alias du="du -h"
alias mkdir="mkdir -pv"
alias wget="wget -c"

# Git aliases
alias g="git clone --depth 1"
alias ga="git add ."
alias gc="git commit -m"
function gp
    # Ensure .config/hypr and wlogout are gitignored before every push
    if not grep -qF ".config/hypr" .gitignore 2>/dev/null
        echo ".config/hypr/hyprviz.conf" >> .gitignore
	    echo ".config/hypr/monitors.conf" >> .gitignore
	    echo ".config/wlogout/style.css" >> .gitignore
        git add .gitignore
        git commit -m "chore: ignore personal config dirs"
    end
    git push
end
alias gl="git pull"
alias gs="git status"
alias gd="git diff"
alias gco="git checkout"
alias gb="git branch"
alias glog="git log --oneline --graph --decorate"

# System information
alias sysinfo="fastfetch"
alias weather="curl wttr.in"

# Fun stuff
alias matrix="cmatrix -a -b -r"
alias pipes="pipes.sh"
alias clock="tty-clock -s -c"
alias sea="asciiquarium"

# Start HyprCandy fastfetch
fastfetch

# Initialize Starship prompt
if type -q starship
    starship init fish | source
end

# Welcome message
function fish_greeting
end

EOF
    
    print_success "Fish shell configuration completed!"
}

# Function to setup Zsh configuration
setup_zsh() {
    print_status "Setting up Zsh shell configuration..."
    
    # Set Zsh as default shell
    if command -v zsh &> /dev/null; then
        print_status "Setting Zsh as default shell..."
        chsh -s $(which zsh)
        print_success "Zsh set as default shell"
    else
        print_error "Zsh not found. Please install Zsh first."
        return 1
    fi
    
    # Install Oh My Zsh if not already installed
    if [ ! -d "$HOME/.oh-my-zsh" ]; then
        print_status "Installing Oh My Zsh..."
        RUNZSH=no sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
        print_success "Oh My Zsh installed"
    fi
    
    # Configure Starship prompt
    if command -v starship &> /dev/null; then
        print_status "Configuring Starship prompt for Zsh..."
        
        # Create Starship config (same as Fish setup)
        mkdir -p "$HOME/.config"
        cat > "$HOME/.config/starship.toml" << 'EOF'
# Starship Configuration for HyprCandy
format = """
$username\
$hostname\
$time $directory\
$git_branch\
$git_state\
$git_status\
$git_metrics\
$fill\
$nodejs\
$python\
$rust\
$golang\
$php\
$java\
$kotlin\
$haskell\
$swift\
$cmd_duration $jobs\
$line_break\
$character"""

[fill]
symbol = ""

[username]
style_user = "bold blue"
style_root = "bold red"
format = "[󱞬](grey) [](green) [](grey) [$user](grey) [](green) ($style)"
show_always = true

[directory]
style = "blue"
read_only = " 🔒"
truncation_length = 4
truncate_to_repo = false

[character]
success_symbol = "[󱞪](grey) [](green)"
error_symbol = "[󱞪](grey) [x](red)"
vimcmd_symbol = "[󱞪](grey) [](green)"

[git_branch]
symbol = "[](green) 🌱 "
truncation_length = 4
truncation_symbol = ""
style = "blue"

[git_status]
ahead = "⇡${count}"
diverged = "⇕⇡${ahead_count}⇣${behind_count}"
behind = "⇣${count}"
deleted = "x"

[nodejs]
symbol = "[](green) 💠 "
style = "bold grey"

[python]
symbol = "[](green) 🐍 "
style = "bold yellow"

[rust]
symbol = "[](green) ⚙️ "
style = "bold red"

[time]
format = '[](grey) [\[ $time \]](grey) [](green)($style)'#🕙
time_format = "%T"
disabled = false
style = "bright-white"

[cmd_duration]
format = "[](green) ⏱️ [$duration]($style)"
style = "yellow"

[jobs]
symbol = "[](green) ⚡ "
style = "bold blue"
EOF
        
        # Create .zshrc with Starship configuration
        cat > "$HOME/.zshrc" << 'EOF'
# HyprCandy Zsh Configuration with Oh My Zsh and Starship

# Oh My Zsh configuration
export ZSH="$HOME/.oh-my-zsh"

# Set environment variables
export HYPRLAND_LOG_WS=1
export EDITOR=micro
export BROWSER=firefox
export TERMINAL=kitty

# Add local bin to PATH
if [ -d "$HOME/.local/bin" ]; then
    export PATH="$HOME/.local/bin:$PATH"
fi

# Initialize Starship prompt
if command -v starship > /dev/null 2>&1; then
    eval "$(starship init zsh)"
fi

# Source Oh My Zsh
source $ZSH/oh-my-zsh.sh

# Aliases

alias hyprcandy="cd .hyprcandy && git pull && stow --ignore='Candy' --ignore='Candy-Images' --ignore='Dock-SVGs' --ignore='Gifs' --ignore='Logo' --ignore='transparent.png' --ignore='GJS' --ignore='Candy.desktop' --ignore='HyprCandy.png' --ignore='candy-daemon.js' --ignore='candy-launcher.sh' --ignore='toggle-control-center.sh' --ignore='toggle-media-player.sh' --ignore='toggle-system-monitor.sh' --ignore='toggle-weather-widget.sh' --ignore='toggle-hyprland-settings.sh' --ignore='candy-system-monitor.js' --ignore='resources' --ignore='src' --ignore='meson.build' --ignore='README.md' --ignore='run.log' --ignore='test_layout.js' --ignore='test_media_menu.js' --ignore='toggle.js' --ignore='toggle-main.js' --ignore='~' --ignore='candy-main.js' --ignore='gjs-media-player.desktop' --ignore='gjs-toggle-controls.desktop' --ignore='main.js' --ignore='media-main.js' --ignore='SEEK_FEATURE.md' --ignore='setup-custom-icon.sh' --ignore='weather-main.js' */"
alias ll="ls -alF"
alias la="ls -A"
alias l="ls -CF"
alias ..="cd .."
alias ...="cd ../.."
alias grep="grep --color=auto"
alias fgrep="fgrep --color=auto"
alias egrep="egrep --color=auto"
alias update="sudo pacman -Syu"
alias install="sudo pacman -S"
alias search="pacman -Ss"
alias remove="sudo pacman -R"
alias autoremove="sudo pacman -Rs $(pacman -Qtdq)"
alias c="clear"
alias h="history"
alias j="jobs -l"
alias df="df -h"
alias du="du -h"
alias mkdir="mkdir -pv"
alias wget="wget -c"

# Git aliases
alias g="git clone --depth 1"
alias ga="git add ."
alias gc="git commit -m"
gp() {
    # Ensure .config/hypr and wlogout are gitignored before every push
    if ! grep -qF ".config/hypr" .gitignore 2>/dev/null; then
        echo ".config/hypr/hyprviz.conf" >> .gitignore
	    echo ".config/hypr/monitors.conf" >> .gitignore
	    echo ".config/wlogout/style.css" >> .gitignore
        git add .gitignore
        git commit -m "chore: ignore personal config dirs"
    fi
    git push
}
alias gl="git pull"
alias gs="git status"
alias gd="git diff"
alias gco="git checkout"
alias gb="git branch"
alias glog="git log --oneline --graph --decorate"

# System information
alias sysinfo="fastfetch"
alias weather="curl wttr.in"

# Fun stuff
alias matrix="cmatrix -a -b -r"
alias pipes="pipes.sh"
alias clock="tty-clock -s -c"
alias sea="asciiquarium"

# Start HyprCandy fastfetch
fastfetch

# Source HyprCandy Zsh setup if it exists
if [ -f ~/.hyprcandy-zsh.zsh ]; then
    source ~/.hyprcandy-zsh.zsh
fi
EOF
        
        print_success "Starship configured for Zsh"
    fi
    
    print_success "Zsh shell configuration completed!"
}
    
# Function to automatically setup Hyprcandy configuration
setup_hyprcandy() {
    
    print_status "Setting up HyprCandy configuration..."
    
    # Check if stow is available
    if ! command -v stow &> /dev/null; then
        print_error "stow is not installed. Cannot proceed with configuration setup."
        return 1
    fi
    
    # Backup previous default config folder if it exists
    PREVIOUS_CONFIG_FOLDER="$HOME/.config/hypr"
    
    if [ ! -d "$PREVIOUS_CONFIG_FOLDER" ]; then
        print_error "Default config folder not found: $PREVIOUS_CONFIG_FOLDER"
        echo -e "${RED}Skipping default config backup${NC}"
    else
        cp -r "$PREVIOUS_CONFIG_FOLDER" "${PREVIOUS_CONFIG_FOLDER}.backup.$(date +%Y%m%d_%H%M%S)"
        echo -e "${GREEN}Previous default config folder backup created${NC}"
    fi
    sleep 1
    
    # Backup previous custom config folder if it exists
    PREVIOUS_CUSTOM_CONFIG_FOLDER="$HOME/.config/hyprcustom"
    
    if [ ! -d "$PREVIOUS_CUSTOM_CONFIG_FOLDER" ]; then
        print_error "Custom config folder not found: $PREVIOUS_CUSTOM_CONFIG_FOLDER"
        echo -e "${RED}Skipping custom config backup${NC}"
    else
        cp -r "$PREVIOUS_CUSTOM_CONFIG_FOLDER" "${PREVIOUS_CUSTOM_CONFIG_FOLDER}.backup.$(date +%Y%m%d_%H%M%S)"
        echo -e "${GREEN}Previous custom config folder backup created${NC}"
    fi
    sleep 1

    # Remove existing .hyprcandy folder
    if [ -d "$HOME/.hyprcandy" ]; then
        echo "🗑️  Removing existing .hyprcandy folder..."
        rm -rf "$HOME/.hyprcandy"
		rm -rf "$HOME/.ultracandy"
        sleep 2
    else
        echo "✅ .hyprcandy dotfiles folder doesn't exist — seems to be a fresh install."
        rm -rf "$HOME/.ultracandy"
        sleep 2
    fi

    # Clone HyprCandy repository
    hyprcandy_dir="$HOME/.hyprcandy"
    echo "🌐 Cloning HyprCandy repository ..." #into $hyprcandy_dir
    git clone --depth 1 https://github.com/HyprCandy/HyprCandyPlus.git "$hyprcandy_dir"
    echo "✅ Cloninig complete"
    
    # Clone overview repository
    #overview_dir="$HOME/.config/quickshell/overview"
    #if [ ! -d "$overview_dir" ]; then
        #echo "🌐 Cloning overview repository ..."
        #git clone https://github.com/Shanu-Kumawat/quickshell-overview "$overview_dir"
        #echo "✅ Cloning complete"
    #fi
    
    # Go to the home directory
    cd "$HOME"

    # Remove present .zshrc file 
    rm -rf .face.icon .hyprcandy-zsh.zsh .icons Candy GJS
    rm -rf "$HOME/Pictures/HyprCandy"

    # Ensure ~/.config exists, then remove specified subdirectories
    [ -d "$HOME/.config" ] || mkdir -p "$HOME/.config"
    cd "$HOME/.config" || exit 1
    rm -rf background background.png btop cava dolphinrc fastfetch gtk-3.0 gtk-4.0 htop hypr hyprcustom hyprcandy hyprpanel kitty matugen micro nvtop nwg-dock-hyprland nwg-look qt5ct qt6ct quickshell rofi swaync wallust waybar waypaper wlogout xsettingsd

    # Go to the home directory
    cd "$HOME"

    # Safely remove existing .zshrc, .hyprcandy-zsh.zsh and .icons files (only if they exist)
    # [ -f "$HOME/.zshrc" ] && rm -f "$HOME/.zshrc"
    [ -f "$HOME/.face.icon" ] && rm -f "$HOME/.face.icon"
    [ -f "$HOME/.hyprcandy-zsh.zsh" ] && rm -f "$HOME/.hyprcandy-zsh.zsh"
    [ -f "$HOME/.icons" ] && rm -f "$HOME/.icons"
    [ -f "$HOME/Candy" ] && rm -f "$HOME/Candy"
    [ -f "$HOME/GJS" ] && rm -f "$HOME/GJS"

    # 📁 Create Screenshots and Recordings directories if they don't exist
    echo "📁 Ensuring directories for screenshots and recordings exist..."
    mkdir -p "$HOME/Pictures/Screenshots" "$HOME/Videos/Recordings"
    echo "✅ Created ~/Pictures/Screenshots and ~/Videos/Recordings (if missing)"

    # Return to the home directory
    cd "$HOME"
    
    # Change to the HyprCandy dotfiles directory
    cd "$hyprcandy_dir" || { echo "❌ Error: Could not find HyprCandy directory"; exit 1; }

    # Define only the configs to be stowed
    config_dirs=(".config" ".icons" ".hyprcandy-zsh.zsh")

    # Add files/folders to exclude from deletion
    preserve_items=("GJS" "Candy" "LICENSE" "README.md" ".git" ".gitignore")

    if [ ${#config_dirs[@]} -eq 0 ]; then
        echo "❌ No configuration directories specified."
        exit 1
    fi

    echo "🔍 Found configuration directories: ${config_dirs[*]}"
    echo "📦 Automatically installing all configurations..."

    # Backup: remove everything not in the allowlist
    for item in * .*; do
        # Skip special entries
        [[ "$item" == "." || "$item" == ".." ]] && continue

        # Skip allowed config items
        if [[ " ${config_dirs[*]} " == *" $item "* ]]; then
            continue
        fi

        # Skip explicitly preserved items
        if [[ " ${preserve_items[*]} " == *" $item "* ]]; then
            echo "❎ Preserving: $item"
            continue
        fi

        echo "🗑️  Removing: $item"
        rm -rf "$item"
    done

# Stow all configurations at once, ignoring Candy folder
if stow -v -t "$HOME" --ignore='Candy' --ignore='GJS' . 2>/dev/null; then
    echo "✅ Successfully stowed all configurations"
else
    echo "⚠️  Stow operation failed — attempting restow..."
    if stow -R -v -t "$HOME" --ignore='Candy' --ignore='GJS' . 2>/dev/null; then
        echo "✅ Successfully restowed all configurations"
    else
        echo "❌ Failed to stow configurations"
    fi
fi
    # Final summary
    echo
    echo "✅ Installation completed. Successfully installed: $stow_success"
    if [ ${#stow_failed[@]} -ne 0 ]; then
        echo "❌ Failed to install: ${stow_failed[*]}"
    fi

### ✅ Setup mako config, hook scripts and needed services
echo "📁 Creating background hook scripts..."
mkdir -p "$HOME/.config/hyprcandy/hooks" "$HOME/.config/systemd/user" "$HOME/.config/mako" "$HOME/.config/pypr" 

### 🪧 Setup mako config
cat > "$HOME/.config/mako/config" << 'EOF'
# Mako Configuration with Material You Colors
# Colors directly embedded (since include might not work)

# Default notification appearance
background-color=#432a00
text-color=#ffffff
border-color=#edbf80
progress-color=#000000

# Notification positioning and layout
anchor=top-right
margin=15,15,0,0
padding=15,20
border-size=2
border-radius=16

# Typography
font=FantasqueSansM Nerd Font Propo Italic 10
markup=1
format=<b>%s</b>\n%b

# Notification dimensions
width=240
height=120
max-visible=1

# Behavior
default-timeout=3000
ignore-timeout=0
group-by=app-name
sort=-time

# Icon settings
icon-path=/usr/share/icons/Papirus-Dark
max-icon-size=20

# Urgency levels with Material You colors
[urgency=low]
background-color=#432a00
text-color=#ffffff
border-color=#edbf80
default-timeout=3000

[urgency=normal]
background-color=#432a00
text-color=#ffffff
border-color=#edbf80
default-timeout=5000

[urgency=critical]
background-color=#432a00
text-color=#ffffff
border-color=#edbf80
default-timeout=0

# App-specific styling
[app-name=Spotify]
background-color=#432a00
text-color=#ffffff
border-color=#edbf80

[app-name=Discord]
background-color=#432a00
text-color=#ffffff
border-color=#edbf80

[app-name="Volume Control"]
background-color=#432a00
text-color=#ffffff
border-color=#edbf80
progress-color=#000000

[app-name="Brightness Control"]
background-color=#432a00
text-color=#ffffff
border-color=#edbf80
progress-color=#000000

# Network notifications
[app-name="NetworkManager"]
background-color=#432a00
text-color=#ffffff
border-color=#edbf80

# Battery notifications
[app-name="Power Management"]
background-color=#432a00
text-color=#ffffff
border-color=#edbf80

[app-name="Power Management" urgency=critical]
background-color=#432a00
text-color=#ffffff
border-color=#edbf80

# System notifications
[app-name="System"]
background-color=#432a00
text-color=#ffffff
border-color=#edbf80

# Screenshot notifications
[app-name="Screenshot"]
background-color=#432a00
text-color=#ffffff
border-color=#edbf80

# Media player notifications
[category=media]
background-color=#432a00
text-color=#ffffff
border-color=#edbf80
default-timeout=3000

# Animation and effects
on-button-left=dismiss
on-button-middle=none
on-button-right=dismiss-all
on-touch=dismiss

# Layer shell settings (for Wayland compositors)
layer=overlay
anchor=top-right
EOF

# ═══════════════════════════════════════════════════════════════
#                    Icon Size Increase Script
# ═══════════════════════════════════════════════════════════════

cat > "$HOME/.config/hyprcandy/hooks/nwg_dock_icon_size_increase.sh" << 'EOF'
#!/bin/bash

LAUNCH_SCRIPT="$HOME/.config/nwg-dock-hyprland/launch.sh"
KEYBINDS_FILE="$HOME/.config/hyprcustom/custom_keybinds.conf"
SETTINGS_FILE="$HOME/.config/hyprcandy/nwg_dock_settings.conf"

# Create settings file if it doesn't exist
if [ ! -f "$SETTINGS_FILE" ]; then
    echo "ICON_SIZE=24" > "$SETTINGS_FILE"
    echo "BORDER_RADIUS=16" >> "$SETTINGS_FILE"
    echo "BORDER_WIDTH=2" >> "$SETTINGS_FILE"
fi

# Source current settings
source "$SETTINGS_FILE"

# Increment icon size
NEW_SIZE=$((ICON_SIZE + 2))

# Update settings and configs
sed -i "s/ICON_SIZE=.*/ICON_SIZE=$NEW_SIZE/" "$SETTINGS_FILE"
sed -i "s/-i [0-9]\\+/-i $NEW_SIZE/g" "$LAUNCH_SCRIPT"
sed -i "s/-i [0-9]\\+/-i $NEW_SIZE/g" "$KEYBINDS_FILE"

# Relaunch dock in correct position
if pgrep -f "nwg-dock-hyprland.*-p left" > /dev/null; then
    pkill -f nwg-dock-hyprland
    sleep 0.3
    nwg-dock-hyprland -p left -lp start -i $NEW_SIZE -w 10 -ml 6 -mt 10 -mb 10 -x -r -s "style.css" -c "rofi -show drun" &
elif pgrep -f "nwg-dock-hyprland.*-p top" > /dev/null; then
    pkill -f nwg-dock-hyprland
    sleep 0.3
    nwg-dock-hyprland -p top -lp start -i $NEW_SIZE -w 10 -mt 6 -ml 10 -mr 10 -x -r -s "style.css" -c "rofi -show drun" &
elif pgrep -f "nwg-dock-hyprland.*-p right" > /dev/null; then
    pkill -f nwg-dock-hyprland
    sleep 0.3
    nwg-dock-hyprland -p right -lp start -i $NEW_SIZE -w 10 -mr 6 -mt 10 -mb 10 -x -r -s "style.css" -c "rofi -show drun" &
else
    "$LAUNCH_SCRIPT" &
fi

echo "🔼 Icon size increased: $NEW_SIZE px"
notify-send "Dock Icon Size Increased" "Size: ${NEW_SIZE}px" -t 2000
EOF

# ═══════════════════════════════════════════════════════════════
#                    Icon Size Decrease Script
# ═══════════════════════════════════════════════════════════════

cat > "$HOME/.config/hyprcandy/hooks/nwg_dock_icon_size_decrease.sh" << 'EOF'
#!/bin/bash

LAUNCH_SCRIPT="$HOME/.config/nwg-dock-hyprland/launch.sh"
KEYBINDS_FILE="$HOME/.config/hyprcustom/custom_keybinds.conf"
SETTINGS_FILE="$HOME/.config/hyprcandy/nwg_dock_settings.conf"

# Create settings file if it doesn't exist
if [ ! -f "$SETTINGS_FILE" ]; then
    echo "ICON_SIZE=24" > "$SETTINGS_FILE"
    echo "BORDER_RADIUS=16" >> "$SETTINGS_FILE"
    echo "BORDER_WIDTH=2" >> "$SETTINGS_FILE"
fi

# Source current settings
source "$SETTINGS_FILE"

# Decrease icon size with lower bound of 16px
NEW_SIZE=$((ICON_SIZE > 16 ? ICON_SIZE - 2 : 16))

# Update configs
sed -i "s/ICON_SIZE=.*/ICON_SIZE=$NEW_SIZE/" "$SETTINGS_FILE"
sed -i "s/-i [0-9]\\+/-i $NEW_SIZE/g" "$LAUNCH_SCRIPT"
sed -i "s/-i [0-9]\\+/-i $NEW_SIZE/g" "$KEYBINDS_FILE"

# Relaunch
if pgrep -f "nwg-dock-hyprland.*-p left" > /dev/null; then
    pkill -f nwg-dock-hyprland
    sleep 0.3
    nwg-dock-hyprland -p left -lp start -i $NEW_SIZE -w 10 -ml 6 -mt 10 -mb 10 -x -r -s "style.css" -c "rofi -show drun" &
elif pgrep -f "nwg-dock-hyprland.*-p top" > /dev/null; then
    pkill -f nwg-dock-hyprland
    sleep 0.3
    nwg-dock-hyprland -p top -lp start -i $NEW_SIZE -w 10 -mt 6 -ml 10 -mr 10 -x -r -s "style.css" -c "rofi -show drun" &
elif pgrep -f "nwg-dock-hyprland.*-p right" > /dev/null; then
    pkill -f nwg-dock-hyprland
    sleep 0.3
    nwg-dock-hyprland -p right -lp start -i $NEW_SIZE -w 10 -mr 6 -mt 10 -mb 10 -x -r -s "style.css" -c "rofi -show drun" &
else
    "$LAUNCH_SCRIPT" &
fi

echo "🔽 Icon size decreased: $NEW_SIZE px"
notify-send "Dock Icon Size Decreased" "Size: ${NEW_SIZE}px" -t 2000
EOF

# ═══════════════════════════════════════════════════════════════
#                    Border Radius Increase Script
# ═══════════════════════════════════════════════════════════════

cat > "$HOME/.config/hyprcandy/hooks/nwg_dock_border_radius_increase.sh" << 'EOF'
#!/bin/bash

STYLE_FILE="$HOME/.config/nwg-dock-hyprland/style.css"
SETTINGS_FILE="$HOME/.config/hyprcandy/nwg_dock_settings.conf"

# Create settings file if it doesn't exist
if [ ! -f "$SETTINGS_FILE" ]; then
    echo "ICON_SIZE=24" > "$SETTINGS_FILE"
    echo "BORDER_RADIUS=16" >> "$SETTINGS_FILE"
    echo "BORDER_WIDTH=2" >> "$SETTINGS_FILE"
fi

# Source current settings
source "$SETTINGS_FILE"

# Increment border radius
NEW_RADIUS=$((BORDER_RADIUS + 2))

# Update settings file
sed -i "s/BORDER_RADIUS=.*/BORDER_RADIUS=$NEW_RADIUS/" "$SETTINGS_FILE"

# Update style.css file
sed -i "5s/border-radius: [0-9]\+px/border-radius: ${NEW_RADIUS}px/" "$STYLE_FILE"

# Reload dock to apply CSS changes
if pgrep -f "nwg-dock-hyprland.*-p left" > /dev/null; then
    pkill -f nwg-dock-hyprland
    sleep 0.3
    nwg-dock-hyprland -p left -lp start -i $ICON_SIZE -w 10 -ml 6 -mt 10 -mb 10 -x -r -s "style.css" -c "rofi -show drun" > /dev/null 2>&1 &
elif pgrep -f "nwg-dock-hyprland.*-p top" > /dev/null; then
    pkill -f nwg-dock-hyprland
    sleep 0.3
    nwg-dock-hyprland -p top -lp start -i $ICON_SIZE -w 10 -mt 6 -ml 10 -mr 10 -x -r -s "style.css" -c "rofi -show drun" > /dev/null 2>&1 &
elif pgrep -f "nwg-dock-hyprland.*-p right" > /dev/null; then
    pkill -f nwg-dock-hyprland
    sleep 0.3
    nwg-dock-hyprland -p right -lp start -i $ICON_SIZE -w 10 -mr 6 -mt 10 -mb 10 -x -r -s "style.css" -c "rofi -show drun" > /dev/null 2>&1 &
elif pgrep -f "nwg-dock-hyprland" > /dev/null; then
    # Default to bottom
    LAUNCH_SCRIPT="$HOME/.config/nwg-dock-hyprland/launch.sh"
    pkill -f nwg-dock-hyprland
    sleep 0.3
    "$LAUNCH_SCRIPT" > /dev/null 2>&1 &
fi

echo "🔼 Border radius increased: $NEW_RADIUS px"
notify-send "Dock Border Radius Increased" "Radius: ${NEW_RADIUS}px" -t 2000
EOF

# ═══════════════════════════════════════════════════════════════
#                    Border Radius Decrease Script
# ═══════════════════════════════════════════════════════════════

cat > "$HOME/.config/hyprcandy/hooks/nwg_dock_border_radius_decrease.sh" << 'EOF'
#!/bin/bash

STYLE_FILE="$HOME/.config/nwg-dock-hyprland/style.css"
SETTINGS_FILE="$HOME/.config/hyprcandy/nwg_dock_settings.conf"

# Create settings file if it doesn't exist
if [ ! -f "$SETTINGS_FILE" ]; then
    echo "ICON_SIZE=24" > "$SETTINGS_FILE"
    echo "BORDER_RADIUS=16" >> "$SETTINGS_FILE"
    echo "BORDER_WIDTH=2" >> "$SETTINGS_FILE"
fi

# Source current settings
source "$SETTINGS_FILE"

# Decrement border radius with floor
NEW_RADIUS=$((BORDER_RADIUS > 0 ? BORDER_RADIUS - 2 : 0))

# Update settings file
sed -i "s/BORDER_RADIUS=.*/BORDER_RADIUS=$NEW_RADIUS/" "$SETTINGS_FILE"

# Update style.css file
sed -i "5s/border-radius: [0-9]\+px/border-radius: ${NEW_RADIUS}px/" "$STYLE_FILE"

# Reload dock to apply CSS changes
if pgrep -f "nwg-dock-hyprland.*-p left" > /dev/null; then
    pkill -f nwg-dock-hyprland
    sleep 0.3
    nwg-dock-hyprland -p left -lp start -i $ICON_SIZE -w 10 -ml 6 -mt 10 -mb 10 -x -r -s "style.css" -c "rofi -show drun" > /dev/null 2>&1 &
elif pgrep -f "nwg-dock-hyprland.*-p top" > /dev/null; then
    pkill -f nwg-dock-hyprland
    sleep 0.3
    nwg-dock-hyprland -p top -lp start -i $ICON_SIZE -w 10 -mt 6 -ml 10 -mr 10 -x -r -s "style.css" -c "rofi -show drun" > /dev/null 2>&1 &
elif pgrep -f "nwg-dock-hyprland.*-p right" > /dev/null; then
    pkill -f nwg-dock-hyprland
    sleep 0.3
    nwg-dock-hyprland -p right -lp start -i $ICON_SIZE -w 10 -mr 6 -mt 10 -mb 10 -x -r -s "style.css" -c "rofi -show drun" > /dev/null 2>&1 &
elif pgrep -f "nwg-dock-hyprland" > /dev/null; then
    LAUNCH_SCRIPT="$HOME/.config/nwg-dock-hyprland/launch.sh"
    pkill -f nwg-dock-hyprland
    sleep 0.3
    "$LAUNCH_SCRIPT" > /dev/null 2>&1 &
fi

echo "🔽 Border radius decreased: $NEW_RADIUS px"
notify-send "Dock Border Radius Decreased" "Radius: ${NEW_RADIUS}px" -t 2000
EOF

# ═══════════════════════════════════════════════════════════════
#                    Border Width Increase Script (WITH RELOAD)
# ═══════════════════════════════════════════════════════════════

cat > "$HOME/.config/hyprcandy/hooks/nwg_dock_border_width_increase.sh" << 'EOF'
#!/bin/bash

STYLE_FILE="$HOME/.config/nwg-dock-hyprland/style.css"
SETTINGS_FILE="$HOME/.config/hyprcandy/nwg_dock_settings.conf"

# Create settings file if it doesn't exist
if [ ! -f "$SETTINGS_FILE" ]; then
    echo "ICON_SIZE=24" > "$SETTINGS_FILE"
    echo "BORDER_RADIUS=16" >> "$SETTINGS_FILE"
    echo "BORDER_WIDTH=2" >> "$SETTINGS_FILE"
fi

# Source current settings
source "$SETTINGS_FILE"

# Increment border width
NEW_WIDTH=$((BORDER_WIDTH + 1))

# Update settings file
sed -i "s/BORDER_WIDTH=.*/BORDER_WIDTH=$NEW_WIDTH/" "$SETTINGS_FILE"

# Update style.css file
sed -i "s/border-width: [0-9]\+px/border-width: ${NEW_WIDTH}px/" "$STYLE_FILE"

# Reload dock to apply CSS changes
if pgrep -f "nwg-dock-hyprland.*-p left" > /dev/null; then
    pkill -f nwg-dock-hyprland
    sleep 0.3
    nwg-dock-hyprland -p left -lp start -i $ICON_SIZE -w 10 -ml 6 -mt 10 -mb 10 -x -r -s "style.css" -c "rofi -show drun" > /dev/null 2>&1 &
elif pgrep -f "nwg-dock-hyprland.*-p top" > /dev/null; then
    pkill -f nwg-dock-hyprland
    sleep 0.3
    nwg-dock-hyprland -p top -lp start -i $ICON_SIZE -w 10 -mt 6 -ml 10 -mr 10 -x -r -s "style.css" -c "rofi -show drun" > /dev/null 2>&1 &
elif pgrep -f "nwg-dock-hyprland.*-p right" > /dev/null; then
    pkill -f nwg-dock-hyprland
    sleep 0.3
    nwg-dock-hyprland -p right -lp start -i $ICON_SIZE -w 10 -mr 6 -mt 10 -mb 10 -x -r -s "style.css" -c "rofi -show drun" > /dev/null 2>&1 &
elif pgrep -f "nwg-dock-hyprland" > /dev/null; then
    # Default to bottom
    LAUNCH_SCRIPT="$HOME/.config/nwg-dock-hyprland/launch.sh"
    pkill -f nwg-dock-hyprland
    sleep 0.3
    "$LAUNCH_SCRIPT" > /dev/null 2>&1 &
fi

# ... (same dock reload logic as before, for brevity)
notify-send "Dock Border Width Increased" "Width: ${NEW_WIDTH}px" -t 2000
EOF

# ═══════════════════════════════════════════════════════════════
#                    Border Width Decrease Script (WITH RELOAD)
# ═══════════════════════════════════════════════════════════════

cat > "$HOME/.config/hyprcandy/hooks/nwg_dock_border_width_decrease.sh" << 'EOF'
#!/bin/bash

STYLE_FILE="$HOME/.config/nwg-dock-hyprland/style.css"
SETTINGS_FILE="$HOME/.config/hyprcandy/nwg_dock_settings.conf"

# Create settings file if it doesn't exist
if [ ! -f "$SETTINGS_FILE" ]; then
    echo "ICON_SIZE=24" > "$SETTINGS_FILE"
    echo "BORDER_RADIUS=16" >> "$SETTINGS_FILE"
    echo "BORDER_WIDTH=2" >> "$SETTINGS_FILE"
fi

# Source current settings
source "$SETTINGS_FILE"

# Decrement border width (minimum 0)
NEW_WIDTH=$((BORDER_WIDTH > 0 ? BORDER_WIDTH - 1 : 0))

# Update settings file
sed -i "s/BORDER_WIDTH=.*/BORDER_WIDTH=$NEW_WIDTH/" "$SETTINGS_FILE"

# Update style.css file
sed -i "s/border-width: [0-9]\+px/border-width: ${NEW_WIDTH}px/" "$STYLE_FILE"

# Reload dock to apply CSS changes
if pgrep -f "nwg-dock-hyprland.*-p left" > /dev/null; then
    pkill -f nwg-dock-hyprland
    sleep 0.3
    nwg-dock-hyprland -p left -lp start -i $ICON_SIZE -w 10 -ml 6 -mt 10 -mb 10 -x -r -s "style.css" -c "rofi -show drun" > /dev/null 2>&1 &
elif pgrep -f "nwg-dock-hyprland.*-p top" > /dev/null; then
    pkill -f nwg-dock-hyprland
    sleep 0.3
    nwg-dock-hyprland -p top -lp start -i $ICON_SIZE -w 10 -mt 6 -ml 10 -mr 10 -x -r -s "style.css" -c "rofi -show drun" > /dev/null 2>&1 &
elif pgrep -f "nwg-dock-hyprland.*-p right" > /dev/null; then
    pkill -f nwg-dock-hyprland
    sleep 0.3
    nwg-dock-hyprland -p right -lp start -i $ICON_SIZE -w 10 -mr 6 -mt 10 -mb 10 -x -r -s "style.css" -c "rofi -show drun" > /dev/null 2>&1 &
elif pgrep -f "nwg-dock-hyprland" > /dev/null; then
    # Default to bottom
    LAUNCH_SCRIPT="$HOME/.config/nwg-dock-hyprland/launch.sh"
    pkill -f nwg-dock-hyprland
    sleep 0.3
    "$LAUNCH_SCRIPT" > /dev/null 2>&1 &
fi

# ... (same dock reload logic as before, for brevity)
notify-send "Dock Border Width Decreased" "Width: ${NEW_WIDTH}px" -t 2000
EOF

# ═══════════════════════════════════════════════════════════════
#                    Dock Presets Script
# ═══════════════════════════════════════════════════════════════

cat > "$HOME/.config/hyprcandy/hooks/nwg_dock_presets.sh" << 'EOF'
#!/bin/bash

LAUNCH_SCRIPT="$HOME/.config/nwg-dock-hyprland/launch.sh"
KEYBINDS_FILE="$HOME/.config/hyprcustom/custom_keybinds.conf"
STYLE_FILE="$HOME/.config/nwg-dock-hyprland/style.css"
SETTINGS_FILE="$HOME/.config/hyprcandy/nwg_dock_settings.conf"

case "$1" in
    "minimal")
        ICON_SIZE=20
        BORDER_RADIUS=8
        BORDER_WIDTH=1
        ;;
    "balanced")
        ICON_SIZE=24
        BORDER_RADIUS=20
        BORDER_WIDTH=2
        ;;
    "prominent")
        ICON_SIZE=30
        BORDER_RADIUS=20
        BORDER_WIDTH=3
        ;;
    "hidden")
        pkill -f nwg-dock-hyprland
        #echo "🫥 Dock hidden"
        #notify-send "Dock Hidden" "nwg-dock-hyprland stopped" -t 2000
        exit 0
        ;;
    *)
        echo "Usage: $0 {minimal|balanced|prominent|hidden}"
        exit 1
        ;;
esac

# Update settings file
cat > "$SETTINGS_FILE" << SETTINGS_EOF
ICON_SIZE=$ICON_SIZE
BORDER_RADIUS=$BORDER_RADIUS
BORDER_WIDTH=$BORDER_WIDTH
SETTINGS_EOF

# Update launch script
sed -i "s/-i [0-9]\+/-i $ICON_SIZE/g" "$LAUNCH_SCRIPT"

# Update keybinds file
sed -i "s/-i [0-9]\+/-i $ICON_SIZE/g" "$KEYBINDS_FILE"

# Update style.css file
sed -i "5s/border-radius: [0-9]\+px/border-radius: ${BORDER_RADIUS}px/" "$STYLE_FILE"
sed -i "s/border-width: [0-9]\+px/border-width: ${BORDER_WIDTH}px/" "$STYLE_FILE"

# Restart dock with current position detection
if pgrep -f "nwg-dock-hyprland.*-p left" > /dev/null; then
    pkill -f nwg-dock-hyprland
    sleep 0.3
    nwg-dock-hyprland -p left -lp start -i $ICON_SIZE -w 10 -ml 6 -mt 10 -mb 10 -x -r -s "style.css" -c "rofi -show drun" > /dev/null 2>&1 &
elif pgrep -f "nwg-dock-hyprland.*-p top" > /dev/null; then
    pkill -f nwg-dock-hyprland
    sleep 0.3
    nwg-dock-hyprland -p top -lp start -i $ICON_SIZE -w 10 -mt 6 -ml 10 -mr 10 -x -r -s "style.css" -c "rofi -show drun" > /dev/null 2>&1 &
elif pgrep -f "nwg-dock-hyprland.*-p right" > /dev/null; then
    pkill -f nwg-dock-hyprland
    sleep 0.3
    nwg-dock-hyprland -p right -lp start -i $ICON_SIZE -w 10 -mr 6 -mt 10 -mb 10 -x -r -s "style.css" -c "rofi -show drun" > /dev/null 2>&1 &
else
    # Default to bottom (launch script)
    "$LAUNCH_SCRIPT" > /dev/null 2>&1 &
fi

echo "🎨 Applied $1 preset: icon_size=$ICON_SIZE, border_radius=$BORDER_RADIUS, border_width=$BORDER_WIDTH"
notify-send "Dock Preset Applied" "$1: SIZE=$ICON_SIZE RADIUS=$BORDER_RADIUS WIDTH=$BORDER_WIDTH" -t 3000
EOF

# ═══════════════════════════════════════════════════════════════
#                    Dock Status Display Script
# ═══════════════════════════════════════════════════════════════

cat > "$HOME/.config/hyprcandy/hooks/nwg_dock_status_display.sh" << 'EOF'
#!/bin/bash

SETTINGS_FILE="$HOME/.config/hyprcandy/nwg_dock_settings.conf"

# Default fallback settings
if [ ! -f "$SETTINGS_FILE" ]; then
    echo "ICON_SIZE=24" > "$SETTINGS_FILE"
    echo "BORDER_RADIUS=16" >> "$SETTINGS_FILE"
    echo "BORDER_WIDTH=2" >> "$SETTINGS_FILE"
fi

source "$SETTINGS_FILE"

# Detect current dock position
if pgrep -f "nwg-dock-hyprland.*-p left" > /dev/null; then
    DOCK_POSITION="left"
elif pgrep -f "nwg-dock-hyprland.*-p top" > /dev/null; then
    DOCK_POSITION="top"
elif pgrep -f "nwg-dock-hyprland.*-p right" > /dev/null; then
    DOCK_POSITION="right"
elif pgrep -f "nwg-dock-hyprland" > /dev/null; then
    DOCK_POSITION="bottom"
else
    DOCK_POSITION="stopped"
fi

# Dock running?
if pgrep -f "nwg-dock-hyprland" > /dev/null; then
    DOCK_STATUS="Running"
else
    DOCK_STATUS="Stopped"
fi

STATUS="🚢 NWG-Dock Status
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
📐 Icon Size: ${ICON_SIZE}px
🔘 Border Radius: ${BORDER_RADIUS}px
🔸 Border Width: ${BORDER_WIDTH}px
📍 Position: $DOCK_POSITION
🔄 Status: $DOCK_STATUS
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

echo "$STATUS"
notify-send "NWG-Dock Status" "SIZE:${ICON_SIZE} RADIUS:${BORDER_RADIUS} WIDTH:${BORDER_WIDTH} POS:$DOCK_POSITION" -t 5000
EOF

# ═══════════════════════════════════════════════════════════════
#                  Make Dock Hook Scripts Executable
# ═══════════════════════════════════════════════════════════════

chmod +x "$HOME/.config/hyprcandy/hooks/nwg_dock_icon_size_increase.sh"
chmod +x "$HOME/.config/hyprcandy/hooks/nwg_dock_icon_size_decrease.sh"
chmod +x "$HOME/.config/hyprcandy/hooks/nwg_dock_border_radius_increase.sh"
chmod +x "$HOME/.config/hyprcandy/hooks/nwg_dock_border_radius_decrease.sh"
chmod +x "$HOME/.config/hyprcandy/hooks/nwg_dock_border_width_increase.sh"
chmod +x "$HOME/.config/hyprcandy/hooks/nwg_dock_border_width_decrease.sh"
chmod +x "$HOME/.config/hyprcandy/hooks/nwg_dock_presets.sh"
chmod +x "$HOME/.config/hyprcandy/hooks/nwg_dock_status_display.sh"

# ═══════════════════════════════════════════════════════════════
#                    Gaps OUT Increase Script
# ═══════════════════════════════════════════════════════════════

cat > "$HOME/.config/hyprcandy/hooks/hyprland_gaps_out_increase.sh" << 'EOF'
#!/bin/bash

CONFIG_FILE="$HOME/.config/hypr/hyprviz.conf"

CURRENT_GAPS_OUT=$(grep -E "^\s*gaps_out\s*=" "$CONFIG_FILE" | sed 's/.*gaps_out\s*=\s*\([0-9]*\).*/\1/')
NEW_GAPS_OUT=$((CURRENT_GAPS_OUT + 1))
sed -i "s/^\(\s*gaps_out\s*=\s*\)[0-9]*/\1$NEW_GAPS_OUT/" "$CONFIG_FILE"

hyprctl keyword general:gaps_out $NEW_GAPS_OUT
hyprctl reload

echo "🔼 Gaps OUT increased: gaps_out=$NEW_GAPS_OUT"
notify-send "Gaps OUT Increased" "gaps_out: $NEW_GAPS_OUT" -t 2000
EOF

chmod +x "$HOME/.config/hyprcandy/hooks/hyprland_gaps_out_increase.sh"

# ═══════════════════════════════════════════════════════════════
#                    Gaps OUT Decrease Script
# ═══════════════════════════════════════════════════════════════

cat > "$HOME/.config/hyprcandy/hooks/hyprland_gaps_out_decrease.sh" << 'EOF'
#!/bin/bash

CONFIG_FILE="$HOME/.config/hypr/hyprviz.conf"

CURRENT_GAPS_OUT=$(grep -E "^\s*gaps_out\s*=" "$CONFIG_FILE" | sed 's/.*gaps_out\s*=\s*\([0-9]*\).*/\1/')
NEW_GAPS_OUT=$((CURRENT_GAPS_OUT > 0 ? CURRENT_GAPS_OUT - 1 : 0))
sed -i "s/^\(\s*gaps_out\s*=\s*\)[0-9]*/\1$NEW_GAPS_OUT/" "$CONFIG_FILE"
hyprctl keyword general:gaps_out $NEW_GAPS_OUT
hyprctl reload

echo "🔽 Gaps OUT decreased: gaps_out=$NEW_GAPS_OUT"
notify-send "Gaps OUT Decreased" "gaps_out: $NEW_GAPS_OUT" -t 2000
EOF

# ═══════════════════════════════════════════════════════════════
#                    Gaps IN Increase Script
# ═══════════════════════════════════════════════════════════════

cat > "$HOME/.config/hyprcandy/hooks/hyprland_gaps_in_increase.sh" << 'EOF'
#!/bin/bash

CONFIG_FILE="$HOME/.config/hypr/hyprviz.conf"
CURRENT_GAPS_IN=$(grep -E "^\s*gaps_in\s*=" "$CONFIG_FILE" | sed 's/.*gaps_in\s*=\s*\([0-9]*\).*/\1/')
NEW_GAPS_IN=$((CURRENT_GAPS_IN + 1))
sed -i "s/^\(\s*gaps_in\s*=\s*\)[0-9]*/\1$NEW_GAPS_IN/" "$CONFIG_FILE"
hyprctl keyword general:gaps_in $NEW_GAPS_IN
hyprctl reload

echo "🔼 Gaps IN increased: gaps_in=$NEW_GAPS_IN"
notify-send "Gaps IN Increased" "gaps_in: $NEW_GAPS_IN" -t 2000
EOF

# ═══════════════════════════════════════════════════════════════
#                    Gaps IN Decrease Script
# ═══════════════════════════════════════════════════════════════

cat > "$HOME/.config/hyprcandy/hooks/hyprland_gaps_in_decrease.sh" << 'EOF'
#!/bin/bash

CONFIG_FILE="$HOME/.config/hypr/hyprviz.conf"
CURRENT_GAPS_IN=$(grep -E "^\s*gaps_in\s*=" "$CONFIG_FILE" | sed 's/.*gaps_in\s*=\s*\([0-9]*\).*/\1/')
NEW_GAPS_IN=$((CURRENT_GAPS_IN > 0 ? CURRENT_GAPS_IN - 1 : 0))
sed -i "s/^\(\s*gaps_in\s*=\s*\)[0-9]*/\1$NEW_GAPS_IN/" "$CONFIG_FILE"
hyprctl keyword general:gaps_in $NEW_GAPS_IN
hyprctl reload

echo "🔽 Gaps IN decreased: gaps_in=$NEW_GAPS_IN"
notify-send "Gaps IN Decreased" "gaps_in: $NEW_GAPS_IN" -t 2000
EOF

# ═══════════════════════════════════════════════════════════════
#                Border Increase Script with Force Options
# ═══════════════════════════════════════════════════════════════

cat > "$HOME/.config/hyprcandy/hooks/hyprland_border_increase.sh" << 'EOF'
#!/bin/bash

CONFIG_FILE="$HOME/.config/hypr/hyprviz.conf"
CURRENT_BORDER=$(grep -E "^\s*border_size\s*=" "$CONFIG_FILE" | sed 's/.*border_size\s*=\s*\([0-9]*\).*/\1/')
NEW_BORDER=$((CURRENT_BORDER + 1))
sed -i "s/^\(\s*border_size\s*=\s*\)[0-9]*/\1$NEW_BORDER/" "$CONFIG_FILE"
hyprctl keyword general:border_size $NEW_BORDER
hyprctl reload

echo "🔼 Border increased: border_size=$NEW_BORDER"
notify-send "Border Increased" "border_size: $NEW_BORDER" -t 2000
EOF

# ═══════════════════════════════════════════════════════════════
#                Border Decrease Script with Force Options
# ═══════════════════════════════════════════════════════════════

cat > "$HOME/.config/hyprcandy/hooks/hyprland_border_decrease.sh" << 'EOF'
#!/bin/bash

CONFIG_FILE="$HOME/.config/hypr/hyprviz.conf"

CURRENT_BORDER=$(grep -E "^\s*border_size\s*=" "$CONFIG_FILE" | sed 's/.*border_size\s*=\s*\([0-9]*\).*/\1/')
NEW_BORDER=$((CURRENT_BORDER > 0 ? CURRENT_BORDER - 1 : 0))
sed -i "s/^\(\s*border_size\s*=\s*\)[0-9]*/\1$NEW_BORDER/" "$CONFIG_FILE"

hyprctl keyword general:border_size $NEW_BORDER
hyprctl reload

echo "🔽 Border decreased: border_size=$NEW_BORDER"
notify-send "Border Decreased" "border_size: $NEW_BORDER" -t 2000
EOF

# ═══════════════════════════════════════════════════════════════
#                Rounding Increase Script with Force Options
# ═══════════════════════════════════════════════════════════════

cat > "$HOME/.config/hyprcandy/hooks/hyprland_rounding_increase.sh" << 'EOF'
#!/bin/bash

CONFIG_FILE="$HOME/.config/hypr/hyprviz.conf"
CURRENT_ROUNDING=$(grep -E "^\s*rounding\s*=" "$CONFIG_FILE" | sed 's/.*rounding\s*=\s*\([0-9]*\).*/\1/')
NEW_ROUNDING=$((CURRENT_ROUNDING + 1))
sed -i "s/^\(\s*rounding\s*=\s*\)[0-9]*/\1$NEW_ROUNDING/" "$CONFIG_FILE"

hyprctl keyword decoration:rounding $NEW_ROUNDING
hyprctl reload

echo "🔼 Rounding increased: rounding=$NEW_ROUNDING"
notify-send "Rounding Increased" "rounding: $NEW_ROUNDING" -t 2000
EOF

# ═══════════════════════════════════════════════════════════════
#                Rounding Decrease Script with Force Options
# ═══════════════════════════════════════════════════════════════

cat > "$HOME/.config/hyprcandy/hooks/hyprland_rounding_decrease.sh" << 'EOF'
#!/bin/bash

CONFIG_FILE="$HOME/.config/hypr/hyprviz.conf"
CURRENT_ROUNDING=$(grep -E "^\s*rounding\s*=" "$CONFIG_FILE" | sed 's/.*rounding\s*=\s*\([0-9]*\).*/\1/')
NEW_ROUNDING=$((CURRENT_ROUNDING > 0 ? CURRENT_ROUNDING - 1 : 0))
sed -i "s/^\(\s*rounding\s*=\s*\)[0-9]*/\1$NEW_ROUNDING/" "$CONFIG_FILE"

hyprctl keyword decoration:rounding $NEW_ROUNDING
hyprctl reload

echo "🔽 Rounding decreased: rounding=$NEW_ROUNDING"
notify-send "Rounding Decreased" "rounding: $NEW_ROUNDING" -t 2000
EOF

# ═══════════════════════════════════════════════════════════════
#                    Gaps + Border Presets Script
# ═══════════════════════════════════════════════════════════════

cat > "$HOME/.config/hyprcandy/hooks/hyprland_gap_presets.sh" << 'EOF'
#!/bin/bash

CONFIG_FILE="$HOME/.config/hypr/hyprviz.conf"

case "$1" in
    "minimal")
        GAPS_OUT=2
        GAPS_IN=1
        BORDER=2
        ROUNDING=3
        ;;
    "balanced")
        GAPS_OUT=6
        GAPS_IN=4
        BORDER=3
        ROUNDING=10
        ;;
    "spacious")
        GAPS_OUT=10
        GAPS_IN=6
        BORDER=3
        ROUNDING=10
        ;;
    "zero")
        GAPS_OUT=0
        GAPS_IN=0
        BORDER=0
        ROUNDING=0
        ;;
    *)
        echo "Usage: $0 {minimal|balanced|spacious|zero}"
        exit 1
        ;;
esac

# Apply all settings
sed -i "s/^\(\s*gaps_out\s*=\s*\)[0-9]*/\1$GAPS_OUT/" "$CONFIG_FILE"
sed -i "s/^\(\s*gaps_in\s*=\s*\)[0-9]*/\1$GAPS_IN/" "$CONFIG_FILE"
sed -i "s/^\(\s*border_size\s*=\s*\)[0-9]*/\1$BORDER/" "$CONFIG_FILE"
sed -i "s/^\(\s*rounding\s*=\s*\)[0-9]*/\1$ROUNDING/" "$CONFIG_FILE"

# Apply immediately
hyprctl keyword general:gaps_out $GAPS_OUT
hyprctl keyword general:gaps_in $GAPS_IN
hyprctl keyword general:border_size $BORDER
hyprctl keyword decoration:rounding $ROUNDING

echo "🎨 Applied $1 preset: gaps_out=$GAPS_OUT, gaps_in=$GAPS_IN, border=$BORDER, rounding=$ROUNDING"
notify-send "Visual Preset Applied" "$1: OUT=$GAPS_OUT IN=$GAPS_IN BORDER=$BORDER ROUND=$ROUNDING" -t 3000
EOF

# ═══════════════════════════════════════════════════════════════
#                    Visual Status Display Script
# ═══════════════════════════════════════════════════════════════

cat > "$HOME/.config/hyprcandy/hooks/hyprland_status_display.sh" << 'EOF'
#!/bin/bash

CONFIG_FILE="$HOME/.config/hypr/hyprviz.conf"

GAPS_OUT=$(grep -E "^\s*gaps_out\s*=" "$CONFIG_FILE" | sed 's/.*gaps_out\s*=\s*\([0-9]*\).*/\1/')
GAPS_IN=$(grep -E "^\s*gaps_in\s*=" "$CONFIG_FILE" | sed 's/.*gaps_in\s*=\s*\([0-9]*\).*/\1/')
BORDER=$(grep -E "^\s*border_size\s*=" "$CONFIG_FILE" | sed 's/.*border_size\s*=\s*\([0-9]*\).*/\1/')
ROUNDING=$(grep -E "^\s*rounding\s*=" "$CONFIG_FILE" | sed 's/.*rounding\s*=\s*\([0-9]*\).*/\1/')

STATUS="🎨 Hyprland Visual Settings
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🔲 Gaps OUT (screen edges): $GAPS_OUT
🔳 Gaps IN (between windows): $GAPS_IN
🔸 Border size: $BORDER
🔘 Corner rounding: $ROUNDING
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

echo "$STATUS"
notify-send "Visual Settings Status" "OUT:$GAPS_OUT IN:$GAPS_IN BORDER:$BORDER ROUND:$ROUNDING" -t 5000
EOF

# ═══════════════════════════════════════════════════════════════
#                  Make Hyprland Scripts Executable
# ═══════════════════════════════════════════════════════════════

chmod +x "$HOME/.config/hyprcandy/hooks/hyprland_gaps_out_increase.sh"
chmod +x "$HOME/.config/hyprcandy/hooks/hyprland_gaps_out_decrease.sh"
chmod +x "$HOME/.config/hyprcandy/hooks/hyprland_gaps_in_increase.sh"
chmod +x "$HOME/.config/hyprcandy/hooks/hyprland_gaps_in_decrease.sh"
chmod +x "$HOME/.config/hyprcandy/hooks/hyprland_border_increase.sh"
chmod +x "$HOME/.config/hyprcandy/hooks/hyprland_border_decrease.sh"
chmod +x "$HOME/.config/hyprcandy/hooks/hyprland_rounding_increase.sh"
chmod +x "$HOME/.config/hyprcandy/hooks/hyprland_rounding_decrease.sh"
chmod +x "$HOME/.config/hyprcandy/hooks/hyprland_gap_presets.sh"
chmod +x "$HOME/.config/hyprcandy/hooks/hyprland_status_display.sh"

echo "✅ Hyprland adjustment scripts created and made executable!"

# ═══════════════════════════════════════════════════════════════
#                    SWAYNC RECORDER SCRIPT
# ═══════════════════════════════════════════════════════════════

cat > "$HOME/.config/swaync/recorder.sh" << 'EOF'
#!/bin/env bash

if pgrep -x "wf-recorder" > /dev/null; then
  pkill -x wf-recorder 
  sleep 0.1
  notify-send "Recorder" "Stopped " -t 2000
else
  bash -c 'wf-recorder -g -a --audio=bluez_output.78_15_2D_0D_BD_B7.1.monitor -f "$HOME/Videos/Recordings/recording-$(date +%Y%m%d-%H%M%S).mp4" $(slurp)'
fi
EOF

chmod +x "$HOME/.config/swaync/recorder.sh"

# ═══════════════════════════════════════════════════════════════
#                           GJS SCRIPTS
# ═══════════════════════════════════════════════════════════════

cat > "$HOME/.hyprcandy/GJS/toggle-control-center.sh" << 'EOF'
#!/bin/bash

# Check if the process is running
if pgrep -f "candy-main.js" > /dev/null; then
    # If running, kill it
    killall gjs ~/.hyprcandy/GJS/candy-main.js
else
    # If not running, start it
    gjs ~/.hyprcandy/GJS/candy-main.js &
fi
EOF

cat > "$HOME/.hyprcandy/GJS/toggle-media-player.sh" << 'EOF'
#!/bin/bash

# Check if the process is running
if pgrep -f "media-main.js" > /dev/null; then
    # If running, kill it
    killall gjs ~/.hyprcandy/GJS/media-main.js
else
    # If not running, start it
    gjs ~/.hyprcandy/GJS/media-main.js &
fi
EOF

cat > "$HOME/.hyprcandy/GJS/toggle-system-monitor.sh" << 'EOF'
#!/bin/bash

# Check if the process is running
if pgrep -f "candy-system-monitor.js" > /dev/null; then
    # If running, kill it
    killall gjs ~/.hyprcandy/GJS/candy-system-monitor.js
else
    # If not running, start it
    gjs ~/.hyprcandy/GJS/candy-system-monitor.js &
fi
EOF

cat > "$HOME/.hyprcandy/GJS/toggle-weather-widget.sh" << 'EOF'
#!/bin/bash

# Check if the process is running
if pgrep -f "weather-main.js" > /dev/null; then
    # If running, kill it
    killall gjs ~/.hyprcandy/GJS/weather-main.js
else
    # If not running, start it
    gjs ~/.hyprcandy/GJS/weather-main.js &
fi
EOF

chmod +x "$HOME/.hyprcandy/GJS/toggle-control-center.sh"
chmod +x "$HOME/.hyprcandy/GJS/toggle-media-player.sh"
chmod +x "$HOME/.hyprcandy/GJS/toggle-system-monitor.sh"
chmod +x "$HOME/.hyprcandy/GJS/toggle-weather-widget.sh"

echo "✅ Widget toggle scripts made executable!"

# ═══════════════════════════════════════════════════════════════
#             SERVICES & SCRIPTS BASED ON CHOSEN BAR
# ═══════════════════════════════════════════════════════════════

if [ "$PANEL_CHOICE" = "waybar" ]; then

# ═══════════════════════════════════════════════════════════════
#                      Waybar XDG Script
# ═══════════════════════════════════════════════════════════════

cat > "$HOME/.config/hypr/scripts/xdg.sh" << 'EOF'
#!/bin/bash
# __  ______   ____
# \ \/ /  _ \ / ___|
#  \  /| | | | |  _
#  /  \| |_| | |_| |
# /_/\_\____/ \____|

# Kill any stale portal processes not managed by systemd
killall -e xdg-desktop-portal-hyprland 2>/dev/null
killall -e xdg-desktop-portal-gtk      2>/dev/null
killall -e xdg-desktop-portal          2>/dev/null

sleep 1

# Stop all managed services cleanly
systemctl --user stop \
    pipewire \
    wireplumber \
    background-watcher \
    waybar-idle-monitor \
    waypaper-watcher \
    xdg-desktop-portal \
    xdg-desktop-portal-hyprland \
    xdg-desktop-portal-gtk

sleep 1

# Start portals in the correct order:
# hyprland portal first (screen capture, toplevel), then gtk/gnome for file pickers
systemctl --user start xdg-desktop-portal-hyprland
sleep 1
systemctl --user start xdg-desktop-portal-gtk
systemctl --user start xdg-desktop-portal

sleep 1

# Restart audio and other services
systemctl --user start \
    pipewire \
    wireplumber \
    background-watcher \
    waybar-idle-monitor \
    waypaper-watcher
EOF

chmod +x "$HOME/.config/hypr/scripts/xdg.sh"
else

# ═══════════════════════════════════════════════════════════════
#                      Hyprpanel XDG Script
# ═══════════════════════════════════════════════════════════════

cat > "$HOME/.config/hypr/scripts/xdg.sh" << 'EOF'
#!/bin/bash
# __  ______   ____
# \ \/ /  _ \ / ___|
#  \  /| | | | |  _
#  /  \| |_| | |_| |
# /_/\_\____/ \____|

# Kill any stale portal processes not managed by systemd
killall -e xdg-desktop-portal-hyprland 2>/dev/null
killall -e xdg-desktop-portal-gtk      2>/dev/null
killall -e xdg-desktop-portal          2>/dev/null

sleep 1

# Stop all managed services cleanly
systemctl --user stop \
    pipewire \
    wireplumber \
    background-watcher \
    hyprpanel \
    hyprpanel-idle-monitor \
    xdg-desktop-portal \
    xdg-desktop-portal-hyprland \
    xdg-desktop-portal-gtk

sleep 1

# Start portals in the correct order:
# hyprland portal first (screen capture, toplevel), then gtk/gnome for file pickers
systemctl --user start xdg-desktop-portal-hyprland
sleep 1
systemctl --user start xdg-desktop-portal-gtk
systemctl --user start xdg-desktop-portal

sleep 1

# Restart audio and other services
systemctl --user start \
    pipewire \
    wireplumber \
    background-watcher \
    hyprnael \
    hyprpanel-idle-monitor
EOF

chmod +x "$HOME/.config/hypr/scripts/xdg.sh"
fi

if [ "$PANEL_CHOICE" = "waybar" ]; then

# ═══════════════════════════════════════════════════════════════
#                          Wallpaper Script
# ═══════════════════════════════════════════════════════════════

cat > "$HOME/.config/waypaper/wallpaper-cycle.sh" << 'EOF'
#!/usr/bin/env bash
# wallpaper-cycle.sh
# Cycles through wallpapers in the waypaper folder using swww (or configured backend)
# and updates the waypaper config with the new wallpaper path.

# ── Config ────────────────────────────────────────────────────────────────────
WAYPAPER_CONFIG="${XDG_CONFIG_HOME:-$HOME/.config}/waypaper/config.ini"

if [[ ! -f "$WAYPAPER_CONFIG" ]]; then
  echo "Error: waypaper config not found at $WAYPAPER_CONFIG"
  exit 1
fi

# ── Read values from config.ini ───────────────────────────────────────────────
get_ini_value() {
  local key="$1"
  grep -E "^\s*${key}\s*=" "$WAYPAPER_CONFIG" \
    | head -n1 \
    | sed 's/.*=\s*//' \
    | sed "s|~|$HOME|g" \
    | xargs   # trim whitespace
}

FOLDER="$(get_ini_value folder)"
BACKEND="$(get_ini_value backend)"
CURRENT="$(get_ini_value wallpaper)"
FILL="$(get_ini_value fill)"
TRANSITION_TYPE="$(get_ini_value swww_transition_type)"
TRANSITION_STEP="$(get_ini_value swww_transition_step)"
TRANSITION_ANGLE="$(get_ini_value swww_transition_angle)"
TRANSITION_DURATION="$(get_ini_value swww_transition_duration)"
TRANSITION_FPS="$(get_ini_value swww_transition_fps)"

# ── Validate folder ───────────────────────────────────────────────────────────
if [[ ! -d "$FOLDER" ]]; then
  echo "Error: wallpaper folder not found: $FOLDER"
  exit 1
fi

# ── Collect wallpapers (sorted by name, matching common image types) ──────────
mapfile -t WALLPAPERS < <(
  find "$FOLDER" -maxdepth 1 -type f \
    \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" \
       -o -iname "*.webp" -o -iname "*.gif" -o -iname "*.bmp" \) \
    | sort
)

if [[ ${#WALLPAPERS[@]} -eq 0 ]]; then
  echo "Error: no wallpapers found in $FOLDER"
  exit 1
fi

# ── Find the next wallpaper ───────────────────────────────────────────────────
NEXT=""
FOUND=false

for WP in "${WALLPAPERS[@]}"; do
  if $FOUND; then
    NEXT="$WP"
    break
  fi
  [[ "$WP" == "$CURRENT" ]] && FOUND=true
done

# If current wasn't found, or it was the last one, wrap around to first
[[ -z "$NEXT" ]] && NEXT="${WALLPAPERS[0]}"

echo "Current : $CURRENT"
echo "Next    : $NEXT"
echo "Backend : $BACKEND"

# ── Apply wallpaper via backend ───────────────────────────────────────────────
apply_swww() {
  # Ensure swww daemon is running
  if ! swww query &>/dev/null; then
    echo "Starting swww daemon..."
    swww-daemon &
    sleep 0.5
  fi

  swww img "$NEXT" \
    --transition-type  "${TRANSITION_TYPE:-any}" \
    --transition-step  "${TRANSITION_STEP:-90}" \
    --transition-angle "${TRANSITION_ANGLE:-0}" \
    --transition-duration "${TRANSITION_DURATION:-2}" \
    --transition-fps   "${TRANSITION_FPS:-60}"
}

apply_feh() {
  feh --bg-fill "$NEXT"
}

apply_swaybg() {
  pkill swaybg 2>/dev/null
  swaybg -i "$NEXT" -m "${FILL:-fill}" &
}

apply_hyprpaper() {
  hyprctl hyprpaper preload "$NEXT"
  hyprctl hyprpaper wallpaper ",$NEXT"
}

case "$BACKEND" in
  swww)      apply_swww      ;;
  feh)       apply_feh       ;;
  swaybg)    apply_swaybg    ;;
  hyprpaper) apply_hyprpaper ;;
  *)
    echo "Warning: unsupported backend '$BACKEND'. Add it to the case block."
    exit 1
    ;;
esac

# ── Update config.ini with the new wallpaper path ────────────────────────────
# Store path with ~ abbreviated for cleanliness (optional — comment out if unwanted)
NEXT_STORED="${NEXT/$HOME/\~}"

sed -i "s|^wallpaper\s*=.*|wallpaper = $NEXT_STORED|" "$WAYPAPER_CONFIG"

systemctl --user restart waypaper-watcher.service

echo "Config updated → wallpaper = $NEXT_STORED"
EOF

chmod +x "$HOME/.config/waypaper/wallpaper-cycle.sh"

# ═══════════════════════════════════════════════════════════════
#                          Hyprlock Script
# ═══════════════════════════════════════════════════════════════

cat > "$HOME/.config/hypr/scripts/hyprlock-watcher.sh" << 'EOF'
#!/bin/bash
# hyprlock-watcher.sh - Watches for hyprlock unlock and refreshes waybar

WEATHER_CACHE_FILE="/tmp/astal-weather-cache.json"

# Wait for Hyprland to start
while [ -z "$HYPRLAND_INSTANCE_SIGNATURE" ]; do
    sleep 1
done

echo "Hyprlock watcher started"

# Continuously monitor for hyprlock
while true; do
    # Wait for hyprlock to start
    while ! pgrep -x hyprlock >/dev/null 2>&1; do
        sleep 1
    done
    
    echo "Hyprlock detected - waiting for unlock..."
    
    # Wait for hyprlock to end (unlock)
    while pgrep -x hyprlock >/dev/null 2>&1; do
        sleep 0.5
    done
    
    echo "Unlocked! Checking waybar status..."
    
    # Only refresh waybar if it was running before lock
    if pgrep -x waybar >/dev/null 2>&1; then
        echo "Waybar is running - refreshing..."
        
        # Remove cached weather file
        rm -f "$WEATHER_CACHE_FILE"
        #rm -f "${WEATHER_CACHE_FILE}.tmp"
        
        # Wait a moment for system to fully resume
        sleep 3
        
        # Full waybar restart
        systemctl --user restart waybar.service
    else
        echo "Waybar was hidden before session lock - skipping refresh"
    fi
    
    # Wait a bit before checking for next lock
    sleep 3
done
EOF

chmod +x "$HOME/.config/hypr/scripts/hyprlock-watcher.sh"

# ═══════════════════════════════════════════════════════════════
#                         Hyprlock Service
# ═══════════════════════════════════════════════════════════════

cat > "$HOME/.config/systemd/user/hyprlock-watcher.service" << 'EOF'
[Unit]
Description=Hyprlock Unlock Watcher - Refreshes Waybar on Resume
Documentation=https://wiki.hyprland.org/Hypr-Ecosystem/hyprlock/
PartOf=graphical-session.target
After=graphical-session.target
Requisite=graphical-session.target

[Service]
Type=simple
ExecStart=%h/.config/hypr/scripts/hyprlock-watcher.sh
Restart=on-failure
RestartSec=3

[Install]
WantedBy=graphical-session.target
EOF

echo "✅ Hyprlock service to re-initialize waybar set"
fi

if [ "$PANEL_CHOICE" = "waybar" ]; then

# ═══════════════════════════════════════════════════════════════
#                      Startup with Waybar
# ═══════════════════════════════════════════════════════════════

cat > "$HOME/.config/hyprcandy/hooks/startup_services.sh" << 'EOF'
#!/bin/bash

# Define colors file path
COLORS_FILE="$HOME/.config/hyprcandy/nwg_dock_colors.conf"

# Function to initialize colors file
initialize_colors_file() {
    echo "🎨 Initializing colors file..."
    
    mkdir -p "$(dirname "$COLORS_FILE")"
    local css_file="$HOME/.config/nwg-dock-hyprland/colors.css"
    
    if [ -f "$css_file" ]; then
        grep -E "@define-color (blur_background8|primary)" "$css_file" > "$COLORS_FILE"
        echo "✅ Colors file initialized with current values"
    else
        touch "$COLORS_FILE"
        echo "⚠️ CSS file not found, created empty colors file"
    fi
}

# MAIN EXECUTION
initialize_colors_file
echo "🎯 All services started successfully"
EOF

else

# ═══════════════════════════════════════════════════════════════
#                      Startup with Hyprpanel
# ═══════════════════════════════════════════════════════════════

cat > "$HOME/.config/hyprcandy/hooks/startup_services.sh" << 'EOF'
#!/bin/bash

# Define colors file path
COLORS_FILE="$HOME/.config/hyprcandy/nwg_dock_colors.conf"

# Function to initialize colors file
initialize_colors_file() {
    echo "🎨 Initializing colors file..."
    
    mkdir -p "$(dirname "$COLORS_FILE")"
    local css_file="$HOME/.config/nwg-dock-hyprland/colors.css"
    
    if [ -f "$css_file" ]; then
        grep -E "@define-color (blur_background8|primary)" "$css_file" > "$COLORS_FILE"
        echo "✅ Colors file initialized with current values"
    else
        touch "$COLORS_FILE"
        echo "⚠️ CSS file not found, created empty colors file"
    fi
}

wait_for_hyprpanel() {
    echo "⏳ Waiting for hyprpanel to initialize..."
    local max_wait=30
    local count=0

    while [ $count -lt $max_wait ]; do
        if pgrep -f "gjs" > /dev/null 2>&1; then
            echo "✅ hyprpanel is running"
            sleep 0.5
            return 0
        fi
        sleep 0.5
        ((count++))
    done

    echo "⚠️ hyprpanel may not have started properly"
    return 1
}

restart_swww() {
    echo "🔄 Restarting swww-daemon..."
    pkill swww-daemon 2>/dev/null
    sleep 0.5
    swww-daemon &
    sleep 1
    echo "✅ swww-daemon restarted"
}

# MAIN EXECUTION
initialize_colors_file
    
if wait_for_hyprpanel; then
    sleep 0.5
    restart_swww
else
    echo "⚠️ Proceeding with swww restart anyway..."
    restart_swww
fi

echo "🎯 All services started successfully"
EOF

chmod +x "$HOME/.config/hyprcandy/hooks/startup_services.sh"
fi

# ═══════════════════════════════════════════════════════════════
#                      	       Cava
# ═══════════════════════════════════════════════════════════════

cat > "$HOME/.config/waybar/scripts/cava.py" << 'EOF'
#!/usr/bin/env python3
"""
#TODO: I am trying to learn a good way to use sockets.
#? This implementation is a POC for other rewrites to avoid multiple IO and System calls.
Cava Manager and Client using Unix Sockets
This script can act as both a manager (server) and client (reader)
- Manager: Runs a single cava instance and broadcasts to multiple clients via socket
- Client: Connects to the socket and reads cava data with formatting
"""

import socket
import subprocess
import os
import sys
import threading
import time
import argparse
import signal
import atexit
import json
import shlex
import re
import fcntl
import tempfile
from pathlib import Path


class CavaConfig:
    """Handle Cava configuration loading and parsing from ~/.config/cava/config"""

    def __init__(self):
        self.config = self._load_config()

    def _load_config(self):
        """Load Cava configuration from ~/.config/cava/config"""
        config_dir = os.path.expanduser(os.getenv("XDG_CONFIG_HOME", "~/.config"))
        config_file = os.path.join(config_dir, "cava", "config")

        if not os.path.exists(config_file):
            return {}

        config = {}
        current_section = None
        
        try:
            with open(config_file, "r") as f:
                for line in f:
                    line = line.strip()
                    
                    # Skip empty lines and comments
                    if not line or line.startswith('#') or line.startswith(';'):
                        continue
                    
                    # Check for section headers [section_name]
                    if line.startswith('[') and line.endswith(']'):
                        current_section = line[1:-1].strip()
                        continue
                    
                    # Parse key = value pairs
                    if '=' in line and current_section:
                        key, value = line.split('=', 1)
                        key = key.strip()
                        value = value.strip()
                        
                        # Store with section prefix (e.g., "general_bars", "input_method")
                        config_key = f"{current_section}_{key}"
                        config[config_key] = value
                        
        except Exception as e:
            print(f"Warning: Could not load Cava config: {e}", file=sys.stderr)

        return config

    def get_value(self, key, default=None):
        """Get value from Cava config, falling back to environment, then default
        
        For cava config compatibility, this method maps common cava settings:
        - CAVA_BARS -> general_bars
        - CAVA_RANGE -> output_ascii_max_range  
        - CAVA_CHANNELS -> output_channels
        - CAVA_REVERSE -> output_reverse
        """
        # Map common environment variables to cava config keys
        key_mapping = {
            'CAVA_BARS': 'general_bars',
            'CAVA_RANGE': 'output_ascii_max_range',
            'CAVA_CHANNELS': 'output_channels', 
            'CAVA_REVERSE': 'output_reverse',
            # Add more mappings as needed for specific prefixed versions
            'CAVA_WAYBAR_BARS': 'general_bars',
            'CAVA_WAYBAR_RANGE': 'output_ascii_max_range',
            'CAVA_WAYBAR_CHANNELS': 'output_channels',
            'CAVA_WAYBAR_REVERSE': 'output_reverse',
            'CAVA_STDOUT_BARS': 'general_bars',
            'CAVA_STDOUT_RANGE': 'output_ascii_max_range',
            'CAVA_STDOUT_CHANNELS': 'output_channels',
            'CAVA_STDOUT_REVERSE': 'output_reverse',
            'CAVA_HYPRLOCK_BARS': 'general_bars',
            'CAVA_HYPRLOCK_RANGE': 'output_ascii_max_range',
            'CAVA_HYPRLOCK_CHANNELS': 'output_channels',
            'CAVA_HYPRLOCK_REVERSE': 'output_reverse',
        }
        
        # Check if we have a mapping for this key
        cava_key = key_mapping.get(key)
        if cava_key and cava_key in self.config:
            value = self.config[cava_key]
            
            # Convert numeric strings to appropriate types
            if value.isdigit():
                return int(value)
            elif value.lower() in ('true', 'yes', 'on'):
                return 1
            elif value.lower() in ('false', 'no', 'off'):
                return 0
            else:
                return value
        
        # Fall back to environment variable
        env_value = os.getenv(key)
        if env_value is not None:
            # Try to convert to int if it's numeric
            if env_value.isdigit():
                return int(env_value)
            elif env_value.lower() in ('true', 'yes', 'on'):
                return 1
            elif env_value.lower() in ('false', 'no', 'off'):
                return 0
            else:
                return env_value
        
        # Return default
        return default

    def get_cava_value(self, section, key, default=None):
        """Get a value directly from a specific cava config section"""
        config_key = f"{section}_{key}"
        value = self.config.get(config_key)
        
        if value is not None:
            # Convert numeric strings and booleans
            if value.isdigit():
                return int(value)
            elif value.lower() in ('true', 'yes', 'on'):
                return True
            elif value.lower() in ('false', 'no', 'off'):
                return False
            else:
                return value
                
        return default


class MediaDetector:
    """Detect if media is playing using playerctl, PipeWire, or PulseAudio"""
    
    def __init__(self):
        self.last_check = 0
        self.check_interval = 0.5  # Check more frequently (every 0.5 seconds)
        self.cached_status = False
        self.playerctl_available = self._check_playerctl_available()
        self.audio_system = self._detect_audio_system()
    
    def _check_playerctl_available(self):
        """Check if playerctl is available"""
        try:
            subprocess.run(['playerctl', '--version'], 
                         stdout=subprocess.DEVNULL, 
                         stderr=subprocess.DEVNULL,
                         check=True)
            return True
        except (subprocess.CalledProcessError, FileNotFoundError):
            return False
    
    def _detect_audio_system(self):
        """Detect whether system uses PipeWire or PulseAudio"""
        try:
            result = subprocess.run(['pactl', 'info'], 
                                  capture_output=True, 
                                  text=True, 
                                  timeout=1)
            if 'PipeWire' in result.stdout:
                return 'pipewire'
            return 'pulseaudio'
        except (subprocess.CalledProcessError, subprocess.TimeoutExpired, FileNotFoundError):
            return 'unknown'
    
    def _check_media_playerctl(self):
        """Check if media is playing using playerctl - most reliable method"""
        try:
            # Check all players
            result = subprocess.run(['playerctl', '-a', 'status'], 
                                  capture_output=True, 
                                  text=True, 
                                  timeout=1)
            # If any player is playing, return True
            statuses = result.stdout.strip().lower().split('\n')
            return 'playing' in statuses
        except (subprocess.CalledProcessError, subprocess.TimeoutExpired, FileNotFoundError):
            return False
    
    def _check_audio_activity_pipewire(self):
        """Check if audio is active using PipeWire (pw-cli or wpctl)"""
        try:
            # Try wpctl first (more modern)
            result = subprocess.run(['wpctl', 'status'], 
                                  capture_output=True, 
                                  text=True, 
                                  timeout=1)
            # Look for active sinks/sources with RUNNING state
            lines = result.stdout.split('\n')
            for line in lines:
                if 'RUNNING' in line:
                    return True
            return False
        except (subprocess.CalledProcessError, subprocess.TimeoutExpired, FileNotFoundError):
            try:
                # Fallback to pw-cli
                result = subprocess.run(['pw-cli', 'list-objects'], 
                                      capture_output=True, 
                                      text=True, 
                                      timeout=1)
                # Check for active streams
                return 'state = "running"' in result.stdout.lower()
            except (subprocess.CalledProcessError, subprocess.TimeoutExpired, FileNotFoundError):
                return False
    
    def _check_audio_activity_pulseaudio(self):
        """Check if any audio streams are active using pactl"""
        try:
            result = subprocess.run(['pactl', 'list', 'sink-inputs'], 
                                  capture_output=True, 
                                  text=True, 
                                  timeout=1)
            # Check for active sink inputs with RUNNING state
            if 'Sink Input #' not in result.stdout:
                return False
            # Look for corked (paused) state - if all are corked, nothing is playing
            lines = result.stdout.split('\n')
            has_running = False
            for i, line in enumerate(lines):
                if 'State:' in line:
                    if 'RUNNING' in line:
                        has_running = True
                    elif 'CORKED' in line:
                        continue
            return has_running
        except (subprocess.CalledProcessError, subprocess.TimeoutExpired, FileNotFoundError):
            return False
    
    def is_media_playing(self, force_check=False):
        """Check if media is currently playing with caching"""
        current_time = time.time()
        
        # Use cached result if recent enough and not forcing
        if not force_check and current_time - self.last_check < self.check_interval:
            return self.cached_status
        
        # Try playerctl first if available (most reliable)
        if self.playerctl_available:
            self.cached_status = self._check_media_playerctl()
        else:
            # Fallback to audio system detection
            if self.audio_system == 'pipewire':
                self.cached_status = self._check_audio_activity_pipewire()
            else:
                self.cached_status = self._check_audio_activity_pulseaudio()
        
        self.last_check = current_time
        return self.cached_status


class CSSColorUpdater:
    """Update Waybar CSS colors dynamically for cava modules with atomic writes and file locking"""
    
    def __init__(self, css_file_path=None):
        if css_file_path is None:
            config_home = os.path.expanduser(os.getenv("XDG_CONFIG_HOME", "~/.config"))
            self.css_file_path = os.path.join(config_home, "waybar", "style.css")
        else:
            self.css_file_path = os.path.expanduser(css_file_path)
        
        self.backup_path = self.css_file_path + ".cava_backup"
        self.lock_path = self.css_file_path + ".lock"
        self.current_state = None  # Track current state to avoid redundant updates
        self.last_update = 0
        self.update_interval = 0.3  # Minimum time between updates
        
        # Create initial backup if it doesn't exist
        if os.path.exists(self.css_file_path) and not os.path.exists(self.backup_path):
            self._create_backup()
    
    def _create_backup(self):
        """Create a backup of the original CSS file"""
        try:
            with open(self.css_file_path, 'r') as src:
                content = src.read()
            with open(self.backup_path, 'w') as dst:
                dst.write(content)
            print(f"Created CSS backup: {self.backup_path}", file=sys.stderr)
        except Exception as e:
            print(f"Warning: Could not create backup: {e}", file=sys.stderr)
    
    def _acquire_lock(self, lock_file, timeout=5):
        """Acquire an exclusive lock on the file with timeout"""
        start_time = time.time()
        while True:
            try:
                fcntl.flock(lock_file.fileno(), fcntl.LOCK_EX | fcntl.LOCK_NB)
                return True
            except IOError:
                if time.time() - start_time > timeout:
                    print("Warning: Could not acquire lock on CSS file", file=sys.stderr)
                    return False
                time.sleep(0.01)  # Wait 10ms before retry
    
    def _release_lock(self, lock_file):
        """Release the lock on the file"""
        try:
            fcntl.flock(lock_file.fileno(), fcntl.LOCK_UN)
        except Exception:
            pass
    
    def _update_css_color(self, make_transparent):
        """Update the CSS file to set cava colors to transparent or restore them using atomic write"""
        if not os.path.exists(self.css_file_path):
            print(f"Warning: CSS file not found: {self.css_file_path}", file=sys.stderr)
            return False
        
        lock_file = None
        temp_fd = None
        temp_path = None
        
        try:
            # Create/open lock file
            lock_file = open(self.lock_path, 'w')
            
            # Acquire exclusive lock with timeout
            if not self._acquire_lock(lock_file, timeout=5):
                return False
            
            # Read the current CSS file
            with open(self.css_file_path, 'r') as f:
                content = f.read()
            
            # Store original content for comparison
            original_content = content
            
            # Define the patterns for cava-left and cava-right blocks
            if make_transparent:
                # Change @primary_container to transparent in cava blocks
                pattern_left = r'(#custom-cava-left\s*\{[^}]*?color:\s*)@primary_container(\s*;)'
                content = re.sub(pattern_left, r'\1transparent\2', content)
                
                pattern_right = r'(#custom-cava-right\s*\{[^}]*?color:\s*)@primary_container(\s*;)'
                content = re.sub(pattern_right, r'\1transparent\2', content)
            else:
                # Restore transparent back to @primary_container in cava blocks
                pattern_left = r'(#custom-cava-left\s*\{[^}]*?color:\s*)transparent(\s*;)'
                content = re.sub(pattern_left, r'\1@primary_container\2', content)
                
                pattern_right = r'(#custom-cava-right\s*\{[^}]*?color:\s*)transparent(\s*;)'
                content = re.sub(pattern_right, r'\1@primary_container\2', content)
            
            # Check if any changes were actually made
            if content == original_content:
                # No changes needed, release lock and return
                self._release_lock(lock_file)
                lock_file.close()
                return True
            
            # Atomic write: write to temporary file first
            temp_fd, temp_path = tempfile.mkstemp(
                dir=os.path.dirname(self.css_file_path),
                prefix='.style_tmp_',
                suffix='.css'
            )
            
            # Write content to temp file
            with os.fdopen(temp_fd, 'w') as temp_file:
                temp_file.write(content)
                temp_file.flush()
                os.fsync(temp_file.fileno())  # Force write to disk
            
            # Get original file permissions
            original_stat = os.stat(self.css_file_path)
            os.chmod(temp_path, original_stat.st_mode)
            
            # Atomic rename (this is the critical atomic operation)
            os.rename(temp_path, self.css_file_path)
            temp_path = None  # Mark as successfully moved
            
            # Release lock
            self._release_lock(lock_file)
            lock_file.close()
            
            return True
            
        except Exception as e:
            print(f"Error updating CSS: {e}", file=sys.stderr)
            
            # Clean up temp file if it exists
            if temp_path and os.path.exists(temp_path):
                try:
                    os.unlink(temp_path)
                except Exception:
                    pass
            
            return False
        
        finally:
            # Ensure lock is released
            if lock_file:
                try:
                    self._release_lock(lock_file)
                    lock_file.close()
                except Exception:
                    pass
    
    def restore_from_backup(self):
        """Restore CSS from backup if it exists"""
        if os.path.exists(self.backup_path):
            try:
                with open(self.backup_path, 'r') as src:
                    content = src.read()
                with open(self.css_file_path, 'w') as dst:
                    dst.write(content)
                print("CSS restored from backup", file=sys.stderr)
                return True
            except Exception as e:
                print(f"Error restoring backup: {e}", file=sys.stderr)
                return False
        return False
    
    def update_for_media_state(self, is_playing):
        """Update CSS based on media playing state"""
        current_time = time.time()
        
        # Avoid redundant updates
        if self.current_state == is_playing and current_time - self.last_update < self.update_interval:
            return
        
        make_transparent = not is_playing
        if self._update_css_color(make_transparent):
            self.current_state = is_playing
            self.last_update = current_time
    
    def cleanup(self):
        """Cleanup: restore original colors when script exits"""
        try:
            # Restore to @primary_container on exit
            self._update_css_color(make_transparent=False)
            print("CSS colors restored on cleanup", file=sys.stderr)
        except Exception as e:
            print(f"Error during cleanup: {e}", file=sys.stderr)



class CavaDataParser:
    """Handle cava data parsing and formatting"""

    @staticmethod
    def format_data(line, bar_chars="▁▂▃▄▅▆▇█", width=None, standby_mode="", padding="", reverse=False):
        """Format cava data with custom bar characters (list or string) and optional padding"""
        line = line.strip()
        if not line:
            return CavaDataParser._handle_standby_mode(standby_mode, bar_chars, width)

        try:
            values = [int(x) for x in line.split(";") if x.isdigit()]
        except ValueError:
            return CavaDataParser._handle_standby_mode(standby_mode, bar_chars, width)

        if not values or all(v == 0 for v in values):
            return CavaDataParser._handle_standby_mode(standby_mode, bar_chars, width)

        if not width:
            width = len(values)

        if len(values) != width:
            expanded_values = []
            for i in range(width):
                original_pos = (i * (len(values) - 1)) / (width - 1) if width > 1 else 0

                left_idx = int(original_pos)
                right_idx = min(left_idx + 1, len(values) - 1)

                if left_idx == right_idx:
                    expanded_values.append(values[left_idx])
                else:
                    fraction = original_pos - left_idx
                    interpolated = (
                        values[left_idx]
                        + (values[right_idx] - values[left_idx]) * fraction
                    )
                    expanded_values.append(int(round(interpolated)))

            values = expanded_values

        # Reverse the values if requested (for right-side visualization)
        if reverse:
            values = list(reversed(values))

        bar_length = len(bar_chars)
        result_parts = []  # Changed from result = "" to list for easier joining

        for i, value in enumerate(values):
            if value >= bar_length:
                char_index = bar_length - 1
            else:
                char_index = value
            # bar_chars can be a list or string
            bar_char = bar_chars[char_index]
            result_parts.append(bar_char)
            
            # Add padding between bars (but not after the last bar)
            if i < len(values) - 1 and padding:
                result_parts.append(padding)

        return "".join(result_parts)

    @staticmethod
    def _handle_standby_mode(standby_mode, bar_chars, width):
        """Handle standby mode when no audio activity - matches bash script logic"""
        if isinstance(standby_mode, str):
            return standby_mode
        elif standby_mode == 0:
            return ""
        elif standby_mode == 1:
            return "‎ "
        elif standby_mode == 2:
            full_char = bar_chars[-1]
            return full_char * (width or len(bar_chars))
        elif standby_mode == 3:
            low_char = bar_chars[0]
            return low_char * (width or len(bar_chars))
        else:
            return str(standby_mode)


class CavaServer:
    """Cava server that manages the cava process and broadcasts to clients"""

    def __init__(self):
        self.runtime_dir = os.getenv(
            "XDG_RUNTIME_DIR", os.path.join("/run/user", str(os.getuid()))
        )
        self.socket_file = os.path.join(self.runtime_dir, "hyde", "cava.sock")
        self.pid_file = os.path.join(self.runtime_dir, "hyde", "cava.pid")
        self.temp_dir = Path(os.path.join(self.runtime_dir, "hyde"))
        self.config_file = self.temp_dir / "cava.manager.conf"

        self.clients = []
        self.clients_lock = threading.Lock()
        self.cava_process = None
        self.server_socket = None
        self.cleanup_registered = False
        self.successfully_started = False
        self.consecutive_zero_count = 0
        self.zero_threshold = 50
        self.last_client_time = time.time()
        self.should_shutdown = False

    def _signal_handler(self, signum, frame):
        """Handle signals gracefully"""
        self.cleanup()
        sys.exit(0)

    def cleanup(self):
        """Cleanup function called on exit"""
        if not (
            self.successfully_started and (self.server_socket or self.cava_process)
        ):
            return

        print(f"Shutting down cava manager (PID: {os.getpid()})...")

        if self.cava_process and self.cava_process.poll() is None:
            self.cava_process.terminate()
            try:
                self.cava_process.wait(timeout=3)
            except subprocess.TimeoutExpired:
                self.cava_process.kill()

        with self.clients_lock:
            for client_socket in self.clients[:]:
                try:
                    client_socket.close()
                except Exception:
                    pass
            self.clients.clear()

        if self.server_socket:
            self.server_socket.close()

        if self.server_socket and os.path.exists(self.socket_file):
            owns_pid_file = False
            if os.path.exists(self.pid_file):
                try:
                    with open(self.pid_file, "r") as f:
                        pid = int(f.read().strip())
                    owns_pid_file = pid == os.getpid()
                except (ValueError, IOError, FileNotFoundError):
                    pass

            if owns_pid_file or not os.path.exists(self.pid_file):
                os.remove(self.socket_file)
                print(f"Removed socket file: {self.socket_file}")

        if self.server_socket and os.path.exists(self.pid_file):
            try:
                with open(self.pid_file, "r") as f:
                    pid = int(f.read().strip())
                if pid == os.getpid():
                    os.remove(self.pid_file)
                    print(f"Removed PID file: {self.pid_file}")
            except (ValueError, IOError, FileNotFoundError):
                pass

        print("Cleanup complete.")

    def _write_pid_file(self):
        """Write PID file to prevent multiple managers"""
        self.temp_dir.mkdir(parents=True, exist_ok=True)
        with open(self.pid_file, "w") as f:
            f.write(str(os.getpid()))

    def _quick_check_running(self):
        """Quick check if manager is running without acquiring locks"""
        if os.path.exists(self.socket_file):
            try:
                with socket.socket(socket.AF_UNIX, socket.SOCK_STREAM) as test_socket:
                    test_socket.settimeout(0.5)
                    test_socket.connect(self.socket_file)
                return True
            except (ConnectionRefusedError, FileNotFoundError, OSError, socket.timeout):
                try:
                    os.remove(self.socket_file)
                except FileNotFoundError:
                    pass

        if os.path.exists(self.pid_file):
            try:
                with open(self.pid_file, "r") as f:
                    pid = int(f.read().strip())

                try:
                    os.kill(pid, 0)
                    return True
                except OSError:
                    try:
                        os.remove(self.pid_file)
                    except FileNotFoundError:
                        pass
            except (ValueError, IOError):
                try:
                    os.remove(self.pid_file)
                except FileNotFoundError:
                    pass

        return False

    def _check_auto_shutdown(self):
        """Check if manager should auto-shutdown when no clients are connected"""
        while not self.should_shutdown:
            time.sleep(1)
            with self.clients_lock:
                if not self.clients and time.time() - self.last_client_time > 1:
                    print("No clients connected for 5 seconds, shutting down...")
                    self.should_shutdown = True
                    break

    def _broadcast_data(self, data):
        """Broadcast data to all connected clients"""
        with self.clients_lock:
            disconnected_clients = []
            for client_socket in self.clients:
                try:
                    client_socket.sendall(data)
                except (BrokenPipeError, ConnectionResetError, OSError):
                    disconnected_clients.append(client_socket)

            for client in disconnected_clients:
                try:
                    client.close()
                except Exception:
                    pass
                if client in self.clients:
                    self.clients.remove(client)

            # If no clients remain, trigger shutdown immediately
            if not self.clients and not self.should_shutdown:
                print("All clients disconnected, shutting down cava manager.")
                self.should_shutdown = True
                # Terminate cava process to unblock main loop
                if self.cava_process and self.cava_process.poll() is None:
                    try:
                        self.cava_process.terminate()
                    except Exception:
                        pass

    def _handle_client_connections(self):
        """Handle incoming client connections and listen for reload command"""
        while not self.should_shutdown:
            try:
                conn, addr = self.server_socket.accept()
                print("New client connected")
                threading.Thread(
                    target=self._client_command_listener, args=(conn,), daemon=True
                ).start()
                with self.clients_lock:
                    self.clients.append(conn)
                    self.last_client_time = time.time()
            except OSError:
                break

    def _client_command_listener(self, conn):
        """Listen for special commands from a client (e.g., reload)"""
        try:
            conn.settimeout(0.1)
            data = b""
            while True:
                try:
                    chunk = conn.recv(1024)
                    if not chunk:
                        break
                    data += chunk
                    if b"\n" in data:
                        line, data = data.split(b"\n", 1)
                        if line.strip() == b"CMD:RELOAD":
                            print("Received reload command from client.")
                            self._reload_cava_process()
                except socket.timeout:
                    break
        except Exception:
            pass

    def _reload_cava_process(self):
        """Restart cava process and reload config with latest values"""
        print("Reloading cava process...")
        if self.cava_process and self.cava_process.poll() is None:
            self.cava_process.terminate()
            try:
                self.cava_process.wait(timeout=2)
            except subprocess.TimeoutExpired:
                self.cava_process.kill()
        # Always use latest config values
        cava_config = CavaConfig()
        bars = int(cava_config.get_value("CAVA_BARS", 16))
        range_val = int(cava_config.get_value("CAVA_RANGE", 15))
        channels = cava_config.get_value("CAVA_CHANNELS", "stereo")
        reverse = cava_config.get_value("CAVA_REVERSE", 0)
        try:
            reverse = int(reverse)
        except Exception:
            reverse = 1 if str(reverse).lower() in ("true", "yes", "on") else 0
        self._create_cava_config(bars, range_val, channels, reverse)
        try:
            self.cava_process = subprocess.Popen(
                ["cava", "-p", str(self.config_file)],
                stdout=subprocess.PIPE,
                stderr=subprocess.PIPE,
                text=True,
            )
            print("Cava process restarted.")
        except FileNotFoundError:
            print("Error: cava not found. Please install cava.")

    def _create_cava_config(
        self, bars=16, range_val=15, channels="stereo", reverse=0, prefix=""
    ):
        """Create cava configuration file with channels and reverse support, using CavaConfig with or without prefix as appropriate"""
        cava_config = CavaConfig()

        if prefix:
            config_channels = cava_config.get_value(f"CAVA_{prefix}_CHANNELS")
            config_reverse = cava_config.get_value(f"CAVA_{prefix}_REVERSE")
        else:
            config_channels = cava_config.get_value("CAVA_CHANNELS")
            config_reverse = cava_config.get_value("CAVA_REVERSE")
        if config_channels in ("mono", "stereo"):
            channels = config_channels
        if config_reverse is not None:
            try:
                reverse = int(config_reverse)
            except ValueError:
                reverse = (
                    1 if str(config_reverse).lower() in ("true", "yes", "on") else 0
                )

        self.temp_dir.mkdir(parents=True, exist_ok=True)

        config_content = f"""[general]
bars = {bars}
sleep_timer = 1

[input]
method = pulse
source = auto

[output]
method = raw
raw_target = /dev/stdout
data_format = ascii
ascii_max_range = {range_val}
channels = {channels}
reverse = {reverse}
"""

        with open(self.config_file, "w") as f:
            f.write(config_content)

    def start(self, bars=16, range_val=15, channels="stereo", reverse=0):
        """Start the cava server"""
        self.shutdown_event = threading.Event()
        threads = []
        try:
            self.temp_dir.mkdir(parents=True, exist_ok=True)
            self.server_socket = socket.socket(socket.AF_UNIX, socket.SOCK_STREAM)
            try:
                self.server_socket.bind(self.socket_file)
                self.server_socket.listen(10)
            except OSError as e:
                error_msg = {
                    98: "Error: Cava manager is already running",
                    2: None,  # Handle directory creation separately
                }.get(e.errno, f"Error: Could not bind to socket: {e}")

                if e.errno == 2:
                    os.makedirs(os.path.dirname(self.socket_file), exist_ok=True)
                    try:
                        self.server_socket.bind(self.socket_file)
                        self.server_socket.listen(10)
                    except OSError as e2:
                        error_msg = (
                            "Error: Cava manager is already running"
                            if e2.errno == 98
                            else f"Error: Could not bind to socket: {e2}"
                        )
                        print(error_msg)
                        self.server_socket.close()
                        self.server_socket = None
                        sys.exit(1)
                else:
                    print(error_msg)
                    self.server_socket.close()
                    self.server_socket = None
                    sys.exit(1)

            print(f"Cava manager started. Socket: {self.socket_file}")

            if not self.cleanup_registered:
                atexit.register(self.cleanup)
                self.cleanup_registered = True
                self.successfully_started = True

            self._write_pid_file()
            self._create_cava_config(bars, range_val, channels, reverse)

            print(f"Starting cava with config: {self.config_file}")
            try:
                self.cava_process = subprocess.Popen(
                    ["cava", "-p", str(self.config_file)],
                    stdout=subprocess.PIPE,
                    stderr=subprocess.PIPE,
                    text=True,
                )
            except FileNotFoundError:
                print("Error: cava not found. Please install cava.")
                sys.exit(1)

            def read_cava_output():
                import select

                while not self.shutdown_event.is_set():
                    if self.cava_process.stdout:
                        rlist, _, _ = select.select(
                            [self.cava_process.stdout], [], [], 0.2
                        )
                        if rlist:
                            line = self.cava_process.stdout.readline()
                            if not line or self.shutdown_event.is_set():
                                break
                            line_stripped = line.strip()
                            if line_stripped:
                                values = [
                                    x for x in line_stripped.split(";") if x.isdigit()
                                ]
                                if values and all(int(v) == 0 for v in values):
                                    self.consecutive_zero_count += 1
                                    if (
                                        self.consecutive_zero_count
                                        <= self.zero_threshold
                                    ):
                                        self._broadcast_data(line.encode("utf-8"))
                                else:
                                    self.consecutive_zero_count = 0
                                    if values:
                                        self._broadcast_data(line.encode("utf-8"))
                        else:
                            continue
                    else:
                        break

            def handle_client_connections():
                while not self.shutdown_event.is_set():
                    try:
                        self.server_socket.settimeout(0.2)
                        conn, addr = self.server_socket.accept()
                        print("New client connected")
                        threading.Thread(
                            target=self._client_command_listener,
                            args=(conn,),
                            daemon=True,
                        ).start()
                        with self.clients_lock:
                            self.clients.append(conn)
                            self.last_client_time = time.time()
                    except socket.timeout:
                        continue
                    except OSError:
                        break

            def check_auto_shutdown():
                while not self.shutdown_event.is_set():
                    time.sleep(1)
                    with self.clients_lock:
                        if not self.clients and time.time() - self.last_client_time > 1:
                            print(
                                "No clients connected for 5 seconds, shutting down..."
                            )
                            self.shutdown_event.set()
                            break

            threads.append(
                threading.Thread(target=handle_client_connections, daemon=True)
            )
            threads.append(threading.Thread(target=check_auto_shutdown, daemon=True))
            threads.append(threading.Thread(target=read_cava_output, daemon=True))
            for t in threads:
                t.start()

            def shutdown_handler(signum=None, frame=None):
                self.shutdown_event.set()
                for t in threads:
                    t.join(timeout=2)
                if self.cava_process and self.cava_process.poll() is None:
                    try:
                        self.cava_process.terminate()
                        self.cava_process.wait(timeout=2)
                    except Exception:
                        try:
                            self.cava_process.kill()
                        except Exception:
                            pass
                self.cleanup()
                os._exit(0)

            signal.signal(signal.SIGTERM, shutdown_handler)
            signal.signal(signal.SIGINT, shutdown_handler)
            try:
                while not self.shutdown_event.is_set():
                    time.sleep(0.2)
            except KeyboardInterrupt:
                shutdown_handler()

        except Exception as e:
            print(f"Error starting manager: {e}")
            sys.exit(1)
        finally:
            self.cleanup()
            os._exit(0)

    def is_running(self):
        """Check if the server is running"""
        return self._quick_check_running()

    def start_in_background(self, bars=16, range_val=15):
        """Start the manager in background and return immediately"""
        if self.is_running():
            return True

        script_path = os.path.abspath(__file__)
        try:
            process = subprocess.Popen(
                [
                    sys.executable,
                    script_path,
                    "manager",
                    "--bars",
                    str(bars),
                    "--range",
                    str(range_val),
                ],
                stdout=subprocess.DEVNULL,
                stderr=subprocess.DEVNULL,
                start_new_session=True,
            )

            max_wait = 5
            start_time = time.time()
            while time.time() - start_time < max_wait:
                if self.is_running():
                    return True
                time.sleep(0.1)

            if process.poll() is None:
                time.sleep(0.5)
                if self.is_running():
                    return True

            return False
        except Exception as e:
            print(f"Failed to start manager in background: {e}", file=sys.stderr)
            return False


class CavaClient:
    """Cava client that connects to the server and formats output"""

    def __init__(self):
        self.runtime_dir = os.getenv(
            "XDG_RUNTIME_DIR", os.path.join("/run/user", str(os.getuid()))
        )
        self.socket_file = os.path.join(self.runtime_dir, "hyde", "cava.sock")
        self.parser = CavaDataParser()
        self.media_detector = MediaDetector()
        self.css_updater = None  # Will be initialized if transparent_when_inactive is True

    def _auto_start_manager_if_needed(self, bars=16, range_val=15):
        """Automatically start manager if not running"""
        server = CavaServer()
        if not server.is_running():
            print("Manager not running, starting automatically...", file=sys.stderr)
            if server.start_in_background(bars, range_val):
                print("Manager started successfully", file=sys.stderr)
                return True
            else:
                print("Failed to start manager automatically", file=sys.stderr)
                return False
        return True

    def start(
        self,
        bar_chars="▁▂▃▄▅▆▇█",
        width=None,
        standby_mode=0,
        timeout=10,
        bars=16,
        range_val=15,
        json_output=False,
        hide_when_inactive=False,
        transparent_when_inactive=False,
        reverse=False,
    ):
        """Start the cava client with enhanced hiding functionality"""
        if not self._auto_start_manager_if_needed(bars, range_val):
            print("Error: Could not start cava manager", file=sys.stderr)
            sys.exit(1)
        
        # Initialize CSS updater if transparent_when_inactive is enabled
        if transparent_when_inactive:
            self.css_updater = CSSColorUpdater()
            print("CSS color updater initialized", file=sys.stderr)

        start_time = time.time()
        while not os.path.exists(self.socket_file):
            if time.time() - start_time > timeout:
                print(
                    "Error: Cava manager not accessible after timeout", file=sys.stderr
                )
                sys.exit(1)
            time.sleep(0.1)

        try:
            client_socket = socket.socket(socket.AF_UNIX, socket.SOCK_STREAM)
            client_socket.connect(self.socket_file)

            # Track state for hiding functionality
            last_media_check = 0
            media_check_interval = 0.5 if transparent_when_inactive else 2  # Check more frequently with CSS updates
            consecutive_silent_count = 0
            silent_threshold = 10  # Hide after 10 consecutive silent readings
            is_hidden = False
            last_output_time = time.time()

            # Initial media check and standby output
            is_media_playing = self.media_detector.is_media_playing(force_check=True)
            
            # Update CSS colors based on initial media state
            if transparent_when_inactive and self.css_updater:
                self.css_updater.update_for_media_state(is_media_playing)
            
            if not is_media_playing and hide_when_inactive:
                # If no media is playing and hide_when_inactive is True, output empty and hide
                if json_output:
                    output = {"text": "", "class": "cava-hidden"}
                    print(json.dumps(output), flush=True)
                else:
                    print("", flush=True)
                is_hidden = True
            else:
                # Show initial standby output
                standby_output = self.parser._handle_standby_mode(
                    standby_mode, bar_chars, width
                )
                if not (
                    (standby_mode == 0 and standby_output == "")
                    or (standby_mode == "" and standby_output == "")
                ):
                    if json_output:
                        output = {
                            "text": standby_output,
                            "tooltip": "Cava audio visualizer - standby mode",
                            "class": "cava-standby"
                        }
                        print(json.dumps(output), flush=True)
                    else:
                        print(standby_output, flush=True)

            buffer = ""
            while True:
                current_time = time.time()
                
                # Periodically check media status
                if (hide_when_inactive or transparent_when_inactive) and current_time - last_media_check > media_check_interval:
                    is_media_playing = self.media_detector.is_media_playing()
                    last_media_check = current_time
                    
                    # Update CSS colors if transparent_when_inactive is enabled
                    if transparent_when_inactive and self.css_updater:
                        self.css_updater.update_for_media_state(is_media_playing)
                    
                    # If media stopped and we're not hidden yet, hide immediately
                    if hide_when_inactive and not is_media_playing and not is_hidden:
                        if json_output:
                            output = {"text": "", "class": "cava-hidden"}
                            print(json.dumps(output), flush=True)
                        else:
                            print("", flush=True)
                        is_hidden = True
                        consecutive_silent_count = 0
                        continue
                    
                    # If media started and we're hidden, show standby mode
                    elif is_media_playing and is_hidden:
                        is_hidden = False
                        consecutive_silent_count = 0

                data = client_socket.recv(1024)
                if not data:
                    break

                decoded_data = data.decode("utf-8")
                if decoded_data.strip():
                    buffer += decoded_data

                    while "\n" in buffer:
                        line, buffer = buffer.split("\n", 1)
                        if line.strip():
                            # Parse the data to check for silence
                            try:
                                values = [int(x) for x in line.split(";") if x.isdigit()]
                                is_silent = not values or all(v == 0 for v in values)
                            except ValueError:
                                is_silent = True
                            
                            # Handle hiding logic or CSS updates
                            if hide_when_inactive or transparent_when_inactive:
                                # Check if media is still playing
                                if current_time - last_media_check > media_check_interval:
                                    is_media_playing = self.media_detector.is_media_playing()
                                    last_media_check = current_time
                                    
                                    # Update CSS colors if transparent_when_inactive is enabled
                                    if transparent_when_inactive and self.css_updater:
                                        self.css_updater.update_for_media_state(is_media_playing)
                                
                                if hide_when_inactive and not is_media_playing:
                                    # No media playing - hide immediately
                                    if not is_hidden:
                                        if json_output:
                                            output = {"text": "", "class": "cava-hidden"}
                                            print(json.dumps(output), flush=True)
                                        else:
                                            print("", flush=True)
                                        is_hidden = True
                                    continue
                                
                                elif hide_when_inactive and is_silent:
                                    # Media is playing but audio is silent
                                    consecutive_silent_count += 1
                                    if consecutive_silent_count >= silent_threshold and not is_hidden:
                                        # Hide after extended silence even if media is "playing"
                                        if json_output:
                                            output = {"text": "", "class": "cava-hidden"}
                                            print(json.dumps(output), flush=True)
                                        else:
                                            print("", flush=True)
                                        is_hidden = True
                                    elif not is_hidden:
                                        # Show standby mode during brief silence
                                        standby_output = self.parser._handle_standby_mode(
                                            standby_mode, bar_chars, width
                                        )
                                        if json_output:
                                            output = {
                                                "text": standby_output,
                                                "tooltip": "Cava audio visualizer - silent",
                                                "class": "cava-silent"
                                            }
                                            print(json.dumps(output), flush=True)
                                        else:
                                            if standby_output:
                                                print(standby_output, flush=True)
                                    continue
                                
                                elif hide_when_inactive:
                                    # Audio activity detected - show and reset counters
                                    consecutive_silent_count = 0
                                    is_hidden = False

                            # Format and display the audio data
                            formatted = self.parser.format_data(
                                line, bar_chars, width, standby_mode, "", reverse
                            )
                            
                            should_suppress = (
                                standby_mode == 0 and formatted == ""
                            ) or (standby_mode == "" and formatted == "")
                            
                            if not should_suppress and not (hide_when_inactive and is_hidden):
                                last_output_time = current_time
                                if json_output:
                                    css_class = "cava-active" if not is_silent else "cava-silent"
                                    output = {
                                        "text": formatted,
                                        "tooltip": "Cava audio visualizer - active",
                                        "class": css_class
                                    }
                                    print(json.dumps(output), flush=True)
                                else:
                                    print(formatted, flush=True)

        except (ConnectionRefusedError, FileNotFoundError):
            print("Error: Cannot connect to cava manager", file=sys.stderr)
            sys.exit(1)
        except KeyboardInterrupt:
            pass
        finally:
            # Cleanup CSS colors before exit
            if transparent_when_inactive and self.css_updater:
                self.css_updater.cleanup()
            
            try:
                client_socket.close()
            except Exception:
                pass

    @staticmethod
    def parse_command_config(cava_config, command, args):
        """Parse configuration for a specific command type"""
        prefix = f"CAVA_{command.upper()}"

        # Prefer --bar-array if present
        if hasattr(args, "bar_array") and args.bar_array:
            bar_chars = args.bar_array
        else:
            # Prefer BAR_ARRAY from config if present and is a list
            bar_array = cava_config.get_value(f"{prefix}_BAR_ARRAY")
            if bar_array and isinstance(bar_array, list):
                bar_chars = bar_array
            else:
                bar_chars = args.bar or cava_config.get_value(
                    f"{prefix}_BAR", "▁▂▃▄▅▆▇█"
                )
                if isinstance(bar_chars, str):
                    bar_chars = list(bar_chars)

        width = (
            args.width
            if args.width is not None
            else int(cava_config.get_value(f"{prefix}_WIDTH", "0") or 0)
        )
        if not width:
            width = len(bar_chars) if bar_chars else 8

        if args.stb is not None:
            standby_mode = args.stb
            if isinstance(standby_mode, str) and standby_mode.isdigit():
                standby_mode = int(standby_mode)
        else:
            standby_mode = cava_config.get_value(f"{prefix}_STANDBY", "0")
            if standby_mode is None or standby_mode == "":
                standby_mode = "\n"
            elif isinstance(standby_mode, str) and standby_mode.isdigit():
                standby_mode = int(standby_mode)
        
        # Handle reverse flag for --left/--right
        reverse = False
        if hasattr(args, 'direction') and args.direction:
            if args.direction == 'right':
                reverse = True
            elif args.direction == 'left':
                reverse = False

        return bar_chars, width, standby_mode, reverse


class CavaReloadClient:
    """Minimal client to send reload command to the server"""

    def __init__(self):
        self.runtime_dir = os.getenv(
            "XDG_RUNTIME_DIR", os.path.join("/run/user", str(os.getuid()))
        )
        self.socket_file = os.path.join(self.runtime_dir, "hyde", "cava.sock")

    def reload(self):
        if not os.path.exists(self.socket_file):
            print("Cava manager is not running.")
            sys.exit(1)
        try:
            s = socket.socket(socket.AF_UNIX, socket.SOCK_STREAM)
            s.connect(self.socket_file)
            s.sendall(b"CMD:RELOAD\n")
            s.close()
            print("Reload command sent.")
        except Exception as e:
            print(f"Failed to send reload command: {e}")
            sys.exit(1)


def create_client_parser(subparsers, name, help_text):
    """Create a client parser with common arguments"""
    parser = subparsers.add_parser(name, help=help_text)
    parser.add_argument("--bar", default=None, help="Bar characters")
    parser.add_argument(
        "--bar-array",
        nargs="+",
        help="Bar characters as an array (e.g. --bar-array '<span color=red>#</span>' '<span color=green>#</span>')",
    )
    parser.add_argument("--width", type=int, help="Bar width")
    parser.add_argument(
        "--stb",
        default=None,
        help='Standby mode (0-3 or string): 0=clean (totally hides the module), 1=blank (makes module expand as spaces), 2=full (occupies the module with full bar), 3=low (makes the module display the lowest set bar), ""=displays nothing and compresses the module, string=displays the custom string',
    )
    parser.add_argument(
        "--hide-when-inactive",
        action="store_true",
        help="Hide the visualizer when no media is playing or after extended silence"
    )
    parser.add_argument(
        "--transparent-when-inactive",
        action="store_true",
        help="Make bars transparent when silent instead of hiding (keeps module space)"
    )
    parser.add_argument(
        "--left",
        action="store_const",
        const="left",
        dest="direction",
        help="Display bars in normal order (left to right, low to high frequencies)"
    )
    parser.add_argument(
        "--right",
        action="store_const",
        const="right",
        dest="direction",
        help="Display bars in reversed order (right to left, high to low frequencies) - perfect for right-side modules"
    )
    if name == "waybar":
        parser.add_argument(
            "--json", action="store_true", help="Output JSON format for waybar tooltips"
        )
    return parser


def main():
    """Main entry point"""
    parser = argparse.ArgumentParser(description="Cava Manager and Client")
    subparsers = parser.add_subparsers(dest="command", help="Commands")

    manager_parser = subparsers.add_parser("manager", help="Start cava manager")
    manager_parser.add_argument("--bars", type=int, default=16, help="Number of bars")
    manager_parser.add_argument("--range", type=int, default=15, help="ASCII range")
    manager_parser.add_argument(
        "--channels",
        choices=["mono", "stereo"],
        default="stereo",
        help="Audio channels: mono or stereo",
    )
    manager_parser.add_argument(
        "--reverse",
        type=int,
        choices=[0, 1],
        default=0,
        help="Reverse frequency order: 0=normal, 1=reverse",
    )

    create_client_parser(subparsers, "waybar", "Waybar client")
    create_client_parser(subparsers, "stdout", "Stdout client")
    create_client_parser(subparsers, "hyprlock", "Hyprlock client")

    subparsers.add_parser("status", help="Check manager status")
    subparsers.add_parser("reload", help="Reload cava manager (restart cava process)")

    args = parser.parse_args()

    if args.command == "manager":
        server = CavaServer()
        if server.is_running():
            print("Cava manager is already running")
            sys.exit(0)

        server.start(args.bars, args.range, args.channels, args.reverse)

    elif args.command in ["waybar", "stdout", "hyprlock"]:
        cava_config = CavaConfig()

        bar_chars, width, standby_mode, reverse = CavaClient.parse_command_config(
            cava_config, args.command, args
        )

        bars = width
        range_val = int(cava_config.get_value("CAVA_RANGE", "15"))

        json_output = args.command == "waybar" and hasattr(args, "json") and args.json
        hide_when_inactive = hasattr(args, "hide_when_inactive") and args.hide_when_inactive
        transparent_when_inactive = hasattr(args, "transparent_when_inactive") and args.transparent_when_inactive

        client = CavaClient()
        client.start(
            bar_chars,
            width,
            standby_mode,
            bars=bars,
            range_val=range_val,
            json_output=json_output,
            hide_when_inactive=hide_when_inactive,
            transparent_when_inactive=transparent_when_inactive,
            reverse=reverse,
        )

    elif args.command == "status":
        server = CavaServer()
        if server.is_running():
            print("Cava manager is running")
            sys.exit(0)
        else:
            print("Cava manager is not running")
            sys.exit(1)

    elif args.command == "reload":
        CavaReloadClient().reload()

    else:
        parser.print_help()


if __name__ == "__main__":
    main()
EOF

chmod +x "$HOME/.config/waybar/scripts/cava.py"

# ═══════════════════════════════════════════════════════════════
#                             Weather
# ═══════════════════════════════════════════════════════════════

cat > "$HOME/.config/waybar/scripts/waybar-weather.sh" << 'EOF'
#!/bin/bash

# Waybar Weather Module - Accurate Location Detection
# Uses Open-Meteo with local environmental overrides for high humidity

# --- CONFIGURATION ---
UNIT_STATE_FILE="/tmp/waybar-weather-unit"
WEATHER_CACHE_FILE="/tmp/astal-weather-cache.json"
LOCATION_CACHE_FILE="/tmp/waybar-weather-location"
IPINFO_CACHE_FILE="/tmp/waybar-weather-ipinfo.json"
CACHE_MAX_AGE=300  # 5 minutes
LOCATION_MAX_AGE=3600  # 1 hour

# Get current unit
CURRENT_UNIT=$(cat "$UNIT_STATE_FILE" 2>/dev/null || echo "metric")

# Get precise location from ipinfo
get_location() {
    if [ -f "$IPINFO_CACHE_FILE" ]; then
        CACHE_AGE=$(( $(date +%s) - $(stat -c %Y "$IPINFO_CACHE_FILE") ))
        if [ $CACHE_AGE -lt $LOCATION_MAX_AGE ]; then
            cat "$IPINFO_CACHE_FILE"
            return
        fi
    fi
    
    IPINFO_DATA=$(curl -s https://ipinfo.io/json)
    if [ -n "$IPINFO_DATA" ]; then
        echo "$IPINFO_DATA" > "$IPINFO_CACHE_FILE"
        echo "$IPINFO_DATA"
    else
        if [ -f "$IPINFO_CACHE_FILE" ]; then
            cat "$IPINFO_CACHE_FILE"
        else
            echo '{"loc":"0,0","city":"Unknown"}'
        fi
    fi
}

IPINFO=$(get_location)
COORDINATES=$(echo "$IPINFO" | jq -r '.loc // "0,0"')
CITY=$(echo "$IPINFO" | jq -r '.city // "Unknown"')

LAT=$(echo "$COORDINATES" | cut -d',' -f1)
LON=$(echo "$COORDINATES" | cut -d',' -f2)
DISPLAY_LOCATION="$CITY"

# Open-Meteo API URL
WEATHER_URL="https://api.open-meteo.com/v1/forecast?latitude=${LAT}&longitude=${LON}&current=temperature_2m,relative_humidity_2m,apparent_temperature,is_day,weather_code,wind_speed_10m,precipitation&daily=weather_code,temperature_2m_max,temperature_2m_min&forecast_days=7&timezone=auto"

# Check cache freshness
if [ -f "$WEATHER_CACHE_FILE" ]; then
    CACHE_AGE=$(( $(date +%s) - $(stat -c %Y "$WEATHER_CACHE_FILE") ))
    if [ $CACHE_AGE -lt $CACHE_MAX_AGE ]; then
        WEATHER_DATA=$(cat "$WEATHER_CACHE_FILE")
    else
        WEATHER_DATA=$(curl -s "$WEATHER_URL")
        if [ -n "$WEATHER_DATA" ] && echo "$WEATHER_DATA" | jq -e '.current' >/dev/null 2>&1; then
            echo "$WEATHER_DATA" > "$WEATHER_CACHE_FILE"
        else
            WEATHER_DATA=$(cat "$WEATHER_CACHE_FILE" 2>/dev/null || echo '{}')
        fi
    fi
else
    WEATHER_DATA=$(curl -s "$WEATHER_URL")
    if [ -n "$WEATHER_DATA" ] && echo "$WEATHER_DATA" | jq -e '.current' >/dev/null 2>&1; then
        echo "$WEATHER_DATA" > "$WEATHER_CACHE_FILE"
    else
        echo '{"error":"Unable to fetch weather"}' >&2
        exit 1
    fi
fi

# Parse weather data with local override logic
jq --arg unit "$CURRENT_UNIT" \
   --arg display_loc "$DISPLAY_LOCATION" \
   -rc '
    def get_condition_info(code; is_day; humidity):
        if (code == 0) then {text: "Clear sky", icon: (if is_day == 1 then "󰖙" else "󰖔" end)}
        elif (code == 1) then {text: "Mainly clear", icon: (if is_day == 1 then "󰖕" else "󰼱" end)}
        elif (code == 2) then {text: "Partly cloudy", icon: (if is_day == 1 then "󰖕" else "󰼱" end)}
        
        # CODE 3 OVERRIDE: If Overcast + High Humidity (85%+), trigger Rain Icon
        elif (code == 3) then 
            (if humidity >= 85 then {text: "Overcast (Rainy)", icon: "󰖖"} 
             else {text: "Overcast", icon: "󰼰"} end)
        
        elif (code == 45 or code == 48) then {text: "Fog", icon: "󰖑"}
        elif (code == 51 or code == 53 or code == 55) then {text: "Drizzle", icon: "󰖗"}
        elif (code == 56 or code == 57) then {text: "Freezing Drizzle", icon: "󰖒"}
        elif (code == 61) then {text: "Slight Rain", icon: "󰖗"}
        elif (code == 63) then {text: "Moderate Rain", icon: "󰖖"}
        elif (code == 65) then {text: "Heavy Rain", icon: "󰙾"}
        elif (code == 66 or code == 67) then {text: "Freezing Rain", icon: "󰙿"}
        elif (code == 71) then {text: "Slight Snow", icon: "󰜗"}
        elif (code == 73) then {text: "Moderate Snow", icon: "󰜗"}
        elif (code == 75) then {text: "Heavy Snow", icon: "󰜗"}
        elif (code == 77) then {text: "Snow Grains", icon: "󰖘"}
        elif (code == 80 or code == 81 or code == 82) then {text: "Rain Showers", icon: "󰙾"}
        elif (code == 85 or code == 86) then {text: "Snow Showers", icon: "󰼶"}
        elif (code == 95) then {text: "Thunderstorm", icon: "󰖓"}
        elif (code == 96 or code == 99) then {text: "Thunderstorm with Hail", icon: "󰖓"}
        else {text: "Unknown", icon: "󰖐"} end;
    
    .current as $current |
    get_condition_info($current.weather_code; $current.is_day; $current.relative_humidity_2m) as $condition |
    
    (if $unit == "metric" then
        { temp: $current.temperature_2m, feel: $current.apparent_temperature, unit: "°C", speed: "\($current.wind_speed_10m) km/h" }
    else
        { temp: ($current.temperature_2m * 9 / 5 + 32), feel: ($current.apparent_temperature * 9 / 5 + 32), unit: "°F", speed: "\($current.wind_speed_10m * 0.621371 | floor) mph" }
    end) as $data |
    
    {
        "text": "\($data.temp | round)\($data.unit) \($condition.icon)",
        "tooltip": "Scroll-Up: °C\nScroll-Down: °F\n-------------------\nClick: Weather-Widget",
        "class": "weather",
        "alt": $condition.text
    }
' <<< "$WEATHER_DATA"

# \($condition.icon) <b>\($condition.text)</b>\n Location: \($display_loc)\n󰔐 Feels like: \($data.feel | round)\($data.unit)\n󰖌 Humidity: \($current.relative_humidity_2m)%\n󰖝 Wind: \($data.speed)
EOF

chmod +x "$HOME/.config/waybar/scripts/waybar-weather.sh"

# ═══════════════════════════════════════════════════════════════
#                      Cursor Update Script
# ═══════════════════════════════════════════════════════════════

cat > "$HOME/.config/hyprcandy/hooks/watch_cursor_theme.sh" << 'EOF'
#!/bin/bash

GTK3_FILE="$HOME/.config/gtk-3.0/settings.ini"
GTK4_FILE="$HOME/.config/gtk-4.0/settings.ini"
HYPRCONF="$HOME/.config/hypr/hyprviz.conf"

get_value() {
    grep -E "^$1=" "$1" 2>/dev/null | cut -d'=' -f2 | tr -d ' '
}

extract_cursor_theme() {
    grep -E "^gtk-cursor-theme-name=" "$1" | cut -d'=' -f2 | tr -d ' '
}

extract_cursor_size() {
    grep -E "^gtk-cursor-theme-size=" "$1" | cut -d'=' -f2 | tr -d ' '
}

update_hypr_cursor_env() {
    local theme="$1"
    local size="$2"

    [ -z "$theme" ] && return
    [ -z "$size" ] && return

    # Replace each env line using sed
    sed -i "s|^env = XCURSOR_THEME,.*|env = XCURSOR_THEME,$theme|" "$HYPRCONF"
    sed -i "s|^env = XCURSOR_SIZE,.*|env = XCURSOR_SIZE,$size|" "$HYPRCONF"
    sed -i "s|^env = HYPRCURSOR_THEME,.*|env = HYPRCURSOR_THEME,$theme|" "$HYPRCONF"
    sed -i "s|^env = HYPRCURSOR_SIZE,.*|env = HYPRCURSOR_SIZE,$size|" "$HYPRCONF"
    
    # Sync GTK4 with GTK3
    sed -i "s|^gtk-cursor-theme-name=.*|gtk-cursor-theme-name=$theme|" "$GTK4_FILE"
    sed -i "s|^gtk-cursor-theme-size=.*|gtk-cursor-theme-size=$size|" "$GTK4_FILE" 

    # SDDM cursor update
    sudo sed -i "s|^CursorTheme=.*|CursorTheme=$theme|" "/etc/sddm.conf.d/sugar-candy.conf"
    sudo sed -i "s|^CursorSize=.*|CursorSize=$size|" "/etc/sddm.conf.d/sugar-candy.conf"

    # Apply changes immediately
    apply_cursor_changes "$theme" "$size"

    echo "✅ Updated and applied cursor theme: $theme / $size"
}

apply_cursor_changes() {
    local theme="$1"
    local size="$2"
    
    # Method 1: Reload Hyprland config
    hyprctl reload 2>/dev/null
    # Apply cursor changes immediately using hyprctl
    hyprctl setcursor "$theme" "$size" 2>/dev/null || {
        echo "⚠️  hyprctl setcursor failed, falling back to reload"
        hyprctl reload 2>/dev/null
    }
    
    # Method 2: Set cursor for current session (fallback)
    if command -v gsettings >/dev/null 2>&1; then
        gsettings set org.gnome.desktop.interface cursor-theme "$theme" 2>/dev/null || true
        gsettings set org.gnome.desktop.interface cursor-size "$size" 2>/dev/null || true
    fi
    
    # Method 3: Update X11 cursor (if running under Xwayland apps)
    if [ -n "$DISPLAY" ]; then
        echo "Xcursor.theme: $theme" | xrdb -merge 2>/dev/null || true
        echo "Xcursor.size: $size" | xrdb -merge 2>/dev/null || true
    fi
}

watch_gtk_file() {
    local file="$1"
    echo "👁 Watching $file for cursor changes..."
    inotifywait -m -e modify "$file" | while read -r; do
        theme=$(extract_cursor_theme "$file")
        size=$(extract_cursor_size "$file")
        update_hypr_cursor_env "$theme" "$size"
        sleep 0.5
        systemctl --user restart cursor-theme-watcher.service
    done
}

# Initial sync if file exists
for gtk_file in "$GTK3_FILE" "$GTK4_FILE"; do
    if [ -f "$gtk_file" ]; then
        theme=$(extract_cursor_theme "$gtk_file")
        size=$(extract_cursor_size "$gtk_file")
        update_hypr_cursor_env "$theme" "$size"
    fi
done

# Start watchers in background
watch_gtk_file "$GTK3_FILE" &
wait
EOF

chmod +x "$HOME/.config/hyprcandy/hooks/watch_cursor_theme.sh"

# ═══════════════════════════════════════════════════════════════
#                    Cursor Update Service
# ═══════════════════════════════════════════════════════════════

cat > "$HOME/.config/systemd/user/cursor-theme-watcher.service" << 'EOF'
[Unit]
Description=Watch GTK cursor theme and size changes
After=hyprland-session.target
PartOf=hyprland-session.target

[Service]
Type=simple
ExecStart=%h/.config/hyprcandy/hooks/watch_cursor_theme.sh
Restart=on-failure
RestartSec=5

# Import environment variables from the user session
Environment="PATH=/usr/local/bin:/usr/bin:/bin"
# These will be set by the ExecStartPre command
ExecStartPre=/bin/bash -c 'systemctl --user import-environment HYPRLAND_INSTANCE_SIGNATURE XDG_CURRENT_DESKTOP WAYLAND_DISPLAY DISPLAY'

[Install]
WantedBy=hyprland-session.target
EOF

# ═══════════════════════════════════════════════════════════════
#                        Pyprland Config
# ═══════════════════════════════════════════════════════════════

cat > "$HOME/.config/pypr/config.toml" << 'EOF'
[pyprland]
plugins = [
    "scratchpads"
]
[scratchpads.term]
animation = "fromTop"
command = "kitty --class=kitty-scratchpad"
class = "kitty-scratchpad"
EOF

if [ "$PANEL_CHOICE" = "waybar" ]; then

# ═══════════════════════════════════════════════════════════════
#                         Waybar Service
# ═══════════════════════════════════════════════════════════════

cat > "$HOME/.config/systemd/user/waybar.service" << 'EOF'
Unit]
Description=Waybar - Highly customizable Wayland bar
Documentation=https://github.com/Alexays/Waybar/wiki
After=graphical-session.target hyprland-session.target
Wants=graphical-session.target
PartOf=graphical-session.target
Requisite=graphical-session.target

[Service]
Type=simple
ExecStart=/usr/bin/waybar
Restart=on-failure
RestartSec=6
KillMode=mixed
KillSignal=SIGTERM
TimeoutStopSec=10

# Don't restart if manually stopped (allows keybind control)
RestartPreventExitStatus=143

[Install]
WantedBy=graphical-session.target
EOF
# Just waybar service. No swww cache clearing needed

else

# ═══════════════════════════════════════════════════════════════
#                  Clear Swww Cache Script
# ═══════════════════════════════════════════════════════════════

cat > "$HOME/.config/hyprcandy/hooks/clear_swww.sh" << 'EOF'
#!/bin/bash
CACHE_DIR="$HOME/.cache/swww"
[ -d "$CACHE_DIR" ] && rm -rf "$CACHE_DIR"
EOF
chmod +x "$HOME/.config/hyprcandy/hooks/clear_swww.sh"
fi

if [ "$PANEL_CHOICE" = "waybar" ]; then
# ═══════════════════════════════════════════════════════════════
#                  Background Update Script
# ═══════════════════════════════════════════════════════════════

cat > "$HOME/.config/hyprcandy/hooks/update_background.sh" << 'EOF'
#!/bin/bash
set +e

restart_swaync() {
    swaync &
    sleep 1
    swaync-client -rs & >/dev/null 2>&1
}

restart_swaync

# Update ROFI background 
ROFI_RASI="$HOME/.config/rofi/colors.rasi"

if command -v sed >/dev/null; then
    sed -i "2s/, 1)/, 0.4)/" "$ROFI_RASI"
    echo "Rofi color updated"
fi

# Update local background.png
if command -v magick >/dev/null && [ -f "$HOME/.config/background" ]; then
    magick "$HOME/.config/background[0]" "$HOME/.config/background.png"
fi

# ── Update SDDM background path and BackgroundColor from waypaper/colors.css ──
WAYPAPER_CONFIG="${XDG_CONFIG_HOME:-$HOME/.config}/waypaper/config.ini"
SDDM_CONF="/usr/share/sddm/themes/sugar-candy/theme.conf"
SDDM_BG_DIR="/usr/share/sddm/themes/sugar-candy/Backgrounds"
COLORS_CSS="${XDG_CONFIG_HOME:-$HOME/.config}/gtk-4.0/colors.css"

if [[ -f "$WAYPAPER_CONFIG" && -f "$SDDM_CONF" ]]; then
    # ── Wallpaper path ────────────────────────────────────────────────────────
    CURRENT_WP=$(grep -E "^\s*wallpaper\s*=" "$WAYPAPER_CONFIG" \
        | head -n1 \
        | sed 's/.*=\s*//' \
        | sed "s|~|$HOME|g" \
        | xargs)

    if [[ -n "$CURRENT_WP" && -f "$CURRENT_WP" ]]; then
        WP_FILENAME=$(basename "$CURRENT_WP")
        WP_EXT="${WP_FILENAME##*.}"

        # webp is not supported by sugar-candy — convert to jpg first
        if [[ "${WP_EXT,,}" == "webp" ]]; then
            WP_FILENAME="${WP_FILENAME%.*}.jpg"
            sudo magick "$CURRENT_WP" "$SDDM_BG_DIR/$WP_FILENAME"
            echo "🔄 Converted webp → $WP_FILENAME"
        else
            sudo magick "$CURRENT_WP" "$SDDM_BG_DIR/$WP_FILENAME"
        fi

        sudo sed -i "s|^Background=.*|Background=\"Backgrounds/$WP_FILENAME\"|" "$SDDM_CONF"
        echo "🖥️  SDDM background updated → Backgrounds/$WP_FILENAME"
    fi

    # ── BackgroundColor from inverse_primary in colors.css ───────────────────
    if [[ -f "$COLORS_CSS" ]]; then
        FULL_HEX=$(grep -E '@define-color\s+inverse_primary\s+#' "$COLORS_CSS" \
            | head -n1 \
            | grep -oP '(?<=#)[0-9a-fA-F]{6}')

        if [[ -n "$FULL_HEX" ]]; then
            sudo sed -i "s|^BackgroundColor=.*|BackgroundColor=\"#$FULL_HEX\"|" "$SDDM_CONF"
            echo "🎨 SDDM BackgroundColor updated → #$FULL_HEX (from inverse_primary)"
        else
            echo "⚠️  Could not parse inverse_primary from $COLORS_CSS"
        fi
    else
        echo "⚠️  colors.css not found at $COLORS_CSS"
    fi

    # ── AccentColor from primary_container in colors.css ───────────────────
    if [[ -f "$COLORS_CSS" ]]; then
        FULL_HEX=$(grep -E '@define-color\s+primary_container\s+#' "$COLORS_CSS" \
            | head -n1 \
            | grep -oP '(?<=#)[0-9a-fA-F]{6}')

        if [[ -n "$FULL_HEX" ]]; then
            sudo sed -i "s|^AccentColor=.*|AccentColor=\"#$FULL_HEX\"|" "$SDDM_CONF"
            echo "🎨 SDDM AccentColor updated → #$FULL_HEX (from primary_container)"
        else
            echo "⚠️  Could not parse primary_container from $COLORS_CSS"
        fi
    else
        echo "⚠️  colors.css not found at $COLORS_CSS"
    fi

else
    [[ ! -f "$WAYPAPER_CONFIG" ]] && echo "⚠️  waypaper config not found: $WAYPAPER_CONFIG"
    [[ ! -f "$SDDM_CONF" ]]      && echo "⚠️  SDDM config not found: $SDDM_CONF"
fi

# Create lock.png at 661x661 pixels
if command -v magick >/dev/null && [ -f "$HOME/.config/background" ]; then
    magick "$HOME/.config/background[0]" -resize 661x661^ -gravity center -extent 661x661 "$HOME/.config/lock.png"
    echo "🔒 Created lock.png at 661x661 pixels"
fi
EOF

else

cat > "$HOME/.config/hyprcandy/hooks/update_background.sh" << 'EOF'
#!/bin/bash
set +e

# Update ROFI background 
ROFI_RASI="$HOME/.config/rofi/colors.rasi"

if command -v sed >/dev/null; then
    sed -i "2s/, 1)/, 0.4)/" "$ROFI_RASI"
    echo "Rofi color updated"
fi

# Update local background.png
if command -v magick >/dev/null && [ -f "$HOME/.config/background" ]; then
    magick "$HOME/.config/background[0]" "$HOME/.config/background.png"
fi

# ── Update SDDM background path and BackgroundColor from waypaper/colors.css ──
WAYPAPER_CONFIG="${XDG_CONFIG_HOME:-$HOME/.config}/waypaper/config.ini"
SDDM_CONF="/usr/share/sddm/themes/sugar-candy/theme.conf"
SDDM_BG_DIR="/usr/share/sddm/themes/sugar-candy/Backgrounds"
COLORS_CSS="${XDG_CONFIG_HOME:-$HOME/.config}/gtk-4.0/colors.css"

if [[ -f "$WAYPAPER_CONFIG" && -f "$SDDM_CONF" ]]; then
    # ── Wallpaper path ────────────────────────────────────────────────────────
    CURRENT_WP=$(grep -E "^\s*wallpaper\s*=" "$WAYPAPER_CONFIG" \
        | head -n1 \
        | sed 's/.*=\s*//' \
        | sed "s|~|$HOME|g" \
        | xargs)

    if [[ -n "$CURRENT_WP" && -f "$CURRENT_WP" ]]; then
        WP_FILENAME=$(basename "$CURRENT_WP")
        WP_EXT="${WP_FILENAME##*.}"

        # webp is not supported by sugar-candy — convert to jpg first
        if [[ "${WP_EXT,,}" == "webp" ]]; then
            WP_FILENAME="${WP_FILENAME%.*}.jpg"
            sudo magick "$CURRENT_WP" "$SDDM_BG_DIR/$WP_FILENAME"
            echo "🔄 Converted webp → $WP_FILENAME"
        else
            sudo magick "$CURRENT_WP" "$SDDM_BG_DIR/$WP_FILENAME"
        fi

        sudo sed -i "s|^Background=.*|Background=\"Backgrounds/$WP_FILENAME\"|" "$SDDM_CONF"
        echo "🖥️  SDDM background updated → Backgrounds/$WP_FILENAME"
    fi

    # ── BackgroundColor from inverse_primary in colors.css ───────────────────
    if [[ -f "$COLORS_CSS" ]]; then
        FULL_HEX=$(grep -E '@define-color\s+inverse_primary\s+#' "$COLORS_CSS" \
            | head -n1 \
            | grep -oP '(?<=#)[0-9a-fA-F]{6}')

        if [[ -n "$FULL_HEX" ]]; then
            sudo sed -i "s|^BackgroundColor=.*|BackgroundColor=\"#$FULL_HEX\"|" "$SDDM_CONF"
            echo "🎨 SDDM BackgroundColor updated → #$FULL_HEX (from inverse_primary)"
        else
            echo "⚠️  Could not parse inverse_primary from $COLORS_CSS"
        fi
    else
        echo "⚠️  colors.css not found at $COLORS_CSS"
    fi

    # ── AccentColor from primary_container in colors.css ───────────────────
    if [[ -f "$COLORS_CSS" ]]; then
        FULL_HEX=$(grep -E '@define-color\s+primary_container\s+#' "$COLORS_CSS" \
            | head -n1 \
            | grep -oP '(?<=#)[0-9a-fA-F]{6}')

        if [[ -n "$FULL_HEX" ]]; then
            sudo sed -i "s|^AccentColor=.*|AccentColor=\"#$FULL_HEX\"|" "$SDDM_CONF"
            echo "🎨 SDDM AccentColor updated → #$FULL_HEX (from primary_container)"
        else
            echo "⚠️  Could not parse primary_container from $COLORS_CSS"
        fi
    else
        echo "⚠️  colors.css not found at $COLORS_CSS"
    fi

else
    [[ ! -f "$WAYPAPER_CONFIG" ]] && echo "⚠️  waypaper config not found: $WAYPAPER_CONFIG"
    [[ ! -f "$SDDM_CONF" ]]      && echo "⚠️  SDDM config not found: $SDDM_CONF"
fi

# Create lock.png at 661x661 pixels
if command -v magick >/dev/null && [ -f "$HOME/.config/background" ]; then
    magick "$HOME/.config/background[0]" -resize 661x661^ -gravity center -extent 661x661 "$HOME/.config/lock.png"
    echo "🔒 Created lock.png at 661x661 pixels"
fi

# Update mako config colors from nwg-dock-hyprland/colors.css
MAKO_CONFIG="$HOME/.config/mako/config"
COLORS_CSS="$HOME/.config/nwg-dock-hyprland/colors.css"

if [ -f "$COLORS_CSS" ] && [ -f "$MAKO_CONFIG" ]; then
    # Extract hex values from colors.css, removing trailing semicolons and newlines
    ON_PRIMARY_FIXED_VARIANT=$(grep -E "@define-color[[:space:]]+on_primary_fixed_variant" "$COLORS_CSS" | awk '{print $3}' | tr -d ';' | tr -d '\n')
    PRIMARY_FIXED_DIM=$(grep -E "@define-color[[:space:]]+primary_fixed_dim" "$COLORS_CSS" | awk '{print $3}' | tr -d ';' | tr -d '\n')
    SCIM=$(grep -E "@define-color[[:space:]]+scrim" "$COLORS_CSS" | awk '{print $3}' | tr -d ';' | tr -d '\n')

    # Only proceed if both colors are found
    if [[ $ON_PRIMARY_FIXED_VARIANT =~ ^#([A-Fa-f0-9]{6})$ ]] && [[ $PRIMARY_FIXED_DIM =~ ^#([A-Fa-f0-9]{6})$ ]]; then
        # Update all background-color, progress-color, and border-color lines in mako config
        sed -i "s|^background-color=#.*|background-color=$ON_PRIMARY_FIXED_VARIANT|g" "$MAKO_CONFIG"
        sed -i "s|^progress-color=#.*|progress-color=$SCIM|g" "$MAKO_CONFIG"
        sed -i "s|^border-color=#.*|border-color=$PRIMARY_FIXED_DIM|g" "$MAKO_CONFIG"
        pkill -f mako
        sleep 1
        mako &
        echo "🎨 Updated ALL mako config colors: background-color=$ON_PRIMARY_FIXED_VARIANT, progress-color=$SCIM, border-color=$PRIMARY_FIXED_DIM"
    else
        echo "⚠️  Could not extract required color values from $COLORS_CSS"
    fi
else
    echo "⚠️  $COLORS_CSS or $MAKO_CONFIG not found, skipping mako color update"
fi
EOF
fi

chmod +x "$HOME/.config/hyprcandy/hooks/update_background.sh"

# ═══════════════════════════════════════════════════════════════
#                             Overview
# ═══════════════════════════════════════════════════════════════

cat > "$HOME/.config/hyprcandy/scripts/overview.sh" << 'EOF'
#!/bin/bash

# Check if the process is running
if pgrep - f "qs -c overview" > /dev/null; then
    # If running, just toggle the overview
    qs ipc -c overview call overview toggle
else
    # If not running, start it then toggle the overview
    qs -c overview &
    sleep 0.5
    qs ipc -c overview call overview toggle
fi
EOF

chmod +x "$HOME/.config/hyprcandy/scripts/overview.sh"

# ═══════════════════════════════════════════════════════════════
#              Background File & Matugen Watcher
# ═══════════════════════════════════════════════════════════════

cat > "$HOME/.config/hyprcandy/hooks/watch_background.sh" << 'EOF'
#!/bin/bash
CONFIG_BG="$HOME/.config/background"
HOOKS_DIR="$HOME/.config/hyprcandy/hooks"
COLORS_FILE="$HOME/.config/hyprcandy/nwg_dock_colors.conf"
AUTO_RELAUNCH_PREF="$HOME/.config/hyprcandy/scripts/.dock-auto-relaunch"

while [ -z "$HYPRLAND_INSTANCE_SIGNATURE" ]; do
    echo "Waiting for Hyprland to start..."
    sleep 1
done
echo "Hyprland started"

# Function to execute hooks
execute_hooks() {
    echo "🎯 Executing hooks & checking dock relaunch..."
    
    # Check auto-relaunch preference
    AUTO_RELAUNCH_STATE="enabled"
    if [ -f "$AUTO_RELAUNCH_PREF" ]; then
        AUTO_RELAUNCH_STATE=$(<"$AUTO_RELAUNCH_PREF")
    fi
    
    # Only proceed with dock relaunch if auto-relaunch is enabled
    if [[ "$AUTO_RELAUNCH_STATE" == "enabled" ]]; then
        # Check if colors have changed and launch dock if different
        colors_file="$HOME/.config/nwg-dock-hyprland/colors.css"
        
        # Get current colors from CSS file
        get_current_colors() {
            if [ -f "$colors_file" ]; then
                grep -E "@define-color (blur_background8|primary)" "$colors_file"
            fi
        }
        
        # Get stored colors from our tracking file
        get_stored_colors() {
            if [ -f "$COLORS_FILE" ]; then
                cat "$COLORS_FILE"
            fi
        }
        
        # Compare colors and launch dock if different
        if [ -f "$colors_file" ]; then
            current_colors=$(get_current_colors)
            stored_colors=$(get_stored_colors)
            
            if [ "$current_colors" != "$stored_colors" ]; then
                pkill -f nwg-dock-hyprland
                gsettings set org.gnome.desktop.interface gtk-theme "''"
                sleep 0.2
                gsettings set org.gnome.desktop.interface gtk-theme "adw-gtk3-dark"
                sleep 0.5
                nohup bash -c "$HOME/.config/hyprcandy/scripts/toggle-dock.sh --relaunch" >/dev/null 2>&1 &
                mkdir -p "$(dirname "$COLORS_FILE")"
                echo "$current_colors" > "$COLORS_FILE"
                echo "🎨 Updated dock colors and launched dock"
            else
                echo "🎨 Colors unchanged, skipping dock launch"
            fi
        else
            # Fallback if colors.css doesn't exist
            echo "🎨 Colors file not found"
        fi
    else
        echo "🚫 Auto-relaunch disabled by user, skipping dock relaunch"
    fi
    
    "$HOOKS_DIR/clear_swww.sh"
    "$HOOKS_DIR/update_background.sh"
}

# Function to monitor matugen process
monitor_matugen() {
    echo "🎨 Matugen detected, waiting for completion..."
    
    # Wait for matugen to finish
    while pgrep -x "matugen" > /dev/null 2>&1; do
        sleep 1
    done
    
    echo "✅ Matugen finished, reloading dock & executing hooks"
    execute_hooks
}

# ⏳ Wait for background file to exist
while [ ! -f "$CONFIG_BG" ]; do
    echo "⏳ Waiting for background file to appear..."
    sleep 0.5
done

echo "🚀 Starting background and matugen monitoring..."

# Start background monitoring in background
{
    inotifywait -m -e close_write "$CONFIG_BG" | while read -r file; do
        echo "🎯 Detected background update: $file"
        
        # Check if matugen is running
        if pgrep -x "matugen" > /dev/null 2>&1; then
            echo "🎨 Matugen is running, will wait for completion..."
            monitor_matugen
        else
            execute_hooks
        fi
    done
} &

# Start matugen process monitoring
{
    while true; do
        # Wait for matugen to start
        while ! pgrep -x "matugen" > /dev/null 2>&1; do
            sleep 0.5
        done
        
        echo "🎨 Matugen process detected!"
        monitor_matugen
    done
} &

# Wait for any child process to exit
wait
EOF

chmod +x "$HOME/.config/hyprcandy/hooks/watch_background.sh"

# ═══════════════════════════════════════════════════════════════
#            Systemd Service: Background Watcher
# ═══════════════════════════════════════════════════════════════

cat > "$HOME/.config/systemd/user/background-watcher.service" << 'EOF'
[Unit]
Description=Watch ~/.config/background, clear swww cache and update background images
After=hyprland-session.target
PartOf=hyprland-session.target

[Service]
Type=simple
ExecStart=%h/.config/hyprcandy/hooks/watch_background.sh
Restart=on-failure
RestartSec=5

# Import environment variables from the user session
Environment="PATH=/usr/local/bin:/usr/bin:/bin"
# These will be set by the ExecStartPre command
ExecStartPre=/bin/bash -c 'systemctl --user import-environment HYPRLAND_INSTANCE_SIGNATURE XDG_CURRENT_DESKTOP WAYLAND_DISPLAY DISPLAY'

[Install]
WantedBy=hyprland-session.target
EOF

if [ "$PANEL_CHOICE" = "waybar" ]; then

# ═══════════════════════════════════════════════════════════════
#         waybar_idle_monitor.sh — Auto Toggle Inhibitor
# ═══════════════════════════════════════════════════════════════

cat > "$HOME/.config/hyprcandy/hooks/waybar_idle_monitor.sh" << 'EOF'
#!/usr/bin/env bash
#
# waybar_idle_monitor.sh
#   - when waybar is NOT running: start our idle inhibitor
#   - when waybar IS running : stop our idle inhibitor
#   - ignores any other inhibitors

# ----------------------------------------------------------------------
# Configuration
# ----------------------------------------------------------------------
INHIBITOR_WHO="Waybar-Idle-Monitor"
CHECK_INTERVAL=5      # seconds between polls

# holds the PID of our systemd-inhibit process
IDLE_INHIBITOR_PID=""

# Wait for Hyprland to start
while [ -z "$HYPRLAND_INSTANCE_SIGNATURE" ]; do
  echo "Waiting for Hyprland to start..."
  sleep 1
done
echo "Hyprland started"
echo "🔍 Waiting for Waybar to start..."

# ----------------------------------------------------------------------
# Helpers
# ----------------------------------------------------------------------

# Returns 0 if our inhibitor is already active
has_our_inhibitor() {
  systemd-inhibit --list 2>/dev/null \
    | grep -F "$INHIBITOR_WHO" \
    >/dev/null 2>&1
}

# Returns 0 if waybar is running
is_waybar_running() {
  pgrep -x waybar >/dev/null 2>&1
}

# ----------------------------------------------------------------------
# Start / stop our inhibitor
# ----------------------------------------------------------------------

start_idle_inhibitor() {
  if has_our_inhibitor; then
    echo "$(date): [INFO] Idle inhibitor already active."
    return
  fi

  echo "$(date): [INFO] Starting idle inhibitor (waybar down)…"
  systemd-inhibit \
    --what=idle \
    --who="$INHIBITOR_WHO" \
    --why="waybar not running — keep screen awake" \
    sleep infinity &
  IDLE_INHIBITOR_PID=$!
}

stop_idle_inhibitor() {
  if [ -n "$IDLE_INHIBITOR_PID" ] && kill -0 "$IDLE_INHIBITOR_PID" 2>/dev/null; then
    echo "$(date): [INFO] Stopping idle inhibitor (waybar back)…"
    kill "$IDLE_INHIBITOR_PID"
    IDLE_INHIBITOR_PID=""
  elif has_our_inhibitor; then
    # fallback if we lost track of the PID
    echo "$(date): [INFO] Killing stray idle inhibitor by tag…"
    pkill -f "systemd-inhibit.*$INHIBITOR_WHO"
  fi
}

# ----------------------------------------------------------------------
# Cleanup on exit
# ----------------------------------------------------------------------

cleanup() {
  echo "$(date): [INFO] Exiting — cleaning up."
  stop_idle_inhibitor
  exit 0
}

trap cleanup SIGINT SIGTERM

# ----------------------------------------------------------------------
# Main
# ----------------------------------------------------------------------

echo "$(date): [INFO] Starting Waybar idle monitor…"
echo "       CHECK_INTERVAL=${CHECK_INTERVAL}s, INHIBITOR_WHO=$INHIBITOR_WHO"

# Initial state
if is_waybar_running; then
  stop_idle_inhibitor
else
  start_idle_inhibitor
fi

# Poll loop
while true; do
  if is_waybar_running; then
    stop_idle_inhibitor
  else
    start_idle_inhibitor
  fi
  sleep "$CHECK_INTERVAL"
done
EOF

chmod +x "$HOME/.config/hyprcandy/hooks/waybar_idle_monitor.sh"

# ═══════════════════════════════════════════════════════════════
#        Systemd Service: waybar Idle Inhibitor Monitor
# ═══════════════════════════════════════════════════════════════

cat > "$HOME/.config/systemd/user/waybar-idle-monitor.service" << 'EOF'
[Unit]
Description=Waybar Idle Inhibitor Monitor
After=graphical-session.target
Wants=graphical-session.target

[Service]
Type=simple
# Make sure this path matches where you put your script:
ExecStart=%h/.config/hyprcandy/hooks/waybar_idle_monitor.sh
Restart=always
RestartSec=10

[Install]
WantedBy=default.target
EOF

# ═══════════════════════════════════════════════════════════════
#             Waybar Restart and Kill Scripts
# ═══════════════════════════════════════════════════════════════

cat > "$HOME/.config/hyprcandy/hooks/restart_waybar.sh" << 'EOF'
#!/bin/bash
systemctl --user restart waybar.service
EOF

cat > "$HOME/.config/hyprcandy/hooks/kill_waybar_safe.sh" << 'EOF'
#!/bin/bash
systemctl --user stop waybar.service
pkill -x waybar
EOF

chmod +x "$HOME/.config/hyprcandy/hooks/restart_waybar.sh"
chmod +x "$HOME/.config/hyprcandy/hooks/kill_waybar_safe.sh"

# ═══════════════════════════════════════════════════════════════
#               Waypaper Integration Scripts
# ═══════════════════════════════════════════════════════════════

    cat > "$HOME/.config/hyprcandy/hooks/waypaper_integration.sh" << 'EOF'
#!/bin/bash
CONFIG_BG="$HOME/.config/background"
WAYPAPER_CONFIG="$HOME/.config/waypaper/config.ini"
MATUGEN_CONFIG="$HOME/.config/matugen/config.toml"
RELOAD_SO="/usr/local/lib/gtk3-reload.so"
RELOAD_SRC="/usr/local/share/gtk3-reload/gtk3-reload.c"

get_waypaper_background() {
    if [ -f "$WAYPAPER_CONFIG" ]; then
        current_bg=$(grep "^wallpaper = " "$WAYPAPER_CONFIG" | cut -d'=' -f2- | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')
        if [ -n "$current_bg" ]; then
            current_bg=$(echo "$current_bg" | sed "s|^~|$HOME|")
            echo "$current_bg"
            return 0
        fi
    fi
    return 1
}

update_config_background() {
    local bg_path="$1"
    if [ -f "$bg_path" ]; then
        magick "$bg_path" "$HOME/.config/background" && magick "$HOME/.config/background[0]" "$HOME/.config/wallpaper.png"
        echo "✅ Updated ~/.config/background to point to: $bg_path"
        return 0
    else
        echo "❌ Background file not found: $bg_path"
        return 1
    fi
}

trigger_matugen() {
    if [ -f "$MATUGEN_CONFIG" ]; then
        echo "🎨 Triggering matugen color generation..."
        matugen image "$HOME/.config/wallpaper.png" --type scheme-content -m dark --base16-backend wal --lightness-dark -0.1 --source-color-index 0 -r nearest --contrast 0.2
        sleep 0.5
        reload_colors
        update_hypr_group_text
        echo "✅ Matugen color generation complete"
    else
        echo "⚠️  Matugen config not found at: $MATUGEN_CONFIG"
    fi
}

# ── Hot reload GTK4/libadwaita/QT colors ────────────────────────────────────────
reload_colors() {
    touch "$HOME/.config/gtk-3.0/colors.css"
    touch "$HOME/.config/gtk-3.0/gtk.css"
    touch "$HOME/.config/gtk-4.0/colors.css"
    touch "$HOME/.config/gtk-4.0/gtk.css"
    touch "$HOME/.config/qt5ct/qt5ct.conf"
    touch "$HOME/.config/qt6ct/qt6ct.conf"
    sync
    
    #gsettings set org.gnome.desktop.interface gtk-theme 'Default'
    gsettings set org.gnome.desktop.interface color-scheme 'default'
    sleep 0.5
    #gsettings set org.gnome.desktop.interface gtk-theme "adw-gtk3-dark"
    gsettings set org.gnome.desktop.interface color-scheme "prefer-dark"
    
    sudo dconf update
}

update_hypr_group_text() {
    local COLORS_CONF="${XDG_CONFIG_HOME:-$HOME/.config}/hypr/colors.conf"
    local HYPRVIZ_CONF="${XDG_CONFIG_HOME:-$HOME/.config}/hypr/hyprviz.conf"

    if [[ ! -f "$COLORS_CONF" ]]; then
        echo "update_hypr_group_text: colors.conf not found at $COLORS_CONF"
        return 1
    fi

    if [[ ! -f "$HYPRVIZ_CONF" ]]; then
        echo "update_hypr_group_text: hyprviz.conf not found at $HYPRVIZ_CONF"
        return 1
    fi

    local BG_LINE
    local PAT='(?<=rgba\()[0-9a-fA-F]{6}'
    BG_LINE=$(grep -E '^\$source_color\s*=' "$COLORS_CONF" | head -n1)
    BG_HEX=$(echo "$BG_LINE" | grep -oP "$PAT")

    if [[ -z "$BG_HEX" ]]; then
        echo "update_hypr_group_text: could not parse \$source_color from $COLORS_CONF"
        return 1
    fi

    local R G B
    R=$((16#${BG_HEX:0:2}))
    G=$((16#${BG_HEX:2:2}))
    B=$((16#${BG_HEX:4:2}))

    local LUMINANCE
    LUMINANCE=$(echo "scale=2; 0.2126 * $R + 0.7152 * $G + 0.0722 * $B" | bc)
    local LUMINANCE_INT=${LUMINANCE%.*}

    local MAX MIN SATURATION
    MAX=$(echo -e "$R\n$G\n$B" | sort -n | tail -1)
    MIN=$(echo -e "$R\n$G\n$B" | sort -n | head -1)

    if (( MAX == MIN )); then
        SATURATION=0
    else
        local LIGHTNESS_RAW=$(( (MAX + MIN) / 2 ))
        if (( LIGHTNESS_RAW <= 127 )); then
            SATURATION=$(( (MAX - MIN) * 100 / (MAX + MIN) ))
        else
            SATURATION=$(( (MAX - MIN) * 100 / (510 - MAX - MIN) ))
        fi
    fi

    if (( LUMINANCE_INT > 150 && SATURATION >= 40 )); then
        local TEXT_COLOR="\$inverse_primary"
    elif (( LUMINANCE_INT <= 150 && SATURATION <= 20 )); then
        local TEXT_COLOR="\$surface_tint"
    elif (( LUMINANCE_INT <= 150 && SATURATION > 20 )); then
        local TEXT_COLOR="\$surface_tint"
    elif (( LUMINANCE_INT > 150 && SATURATION >= 20 && SATURATION < 40 )); then
        local TEXT_COLOR="\$secondary_container"
    else
        local TEXT_COLOR="\$on_primary_fixed_variant"
    fi

    sed -i "s|^\(\s*text_color\s*=\).*|\1 $TEXT_COLOR|" "$HYPRVIZ_CONF"
    echo "update_hypr_group_text: source_color luminance=${LUMINANCE_INT}/255 saturation=${SATURATION}% → text_color = $TEXT_COLOR"
}

execute_color_generation() {
    echo "🚀 Starting color generation for new background..."
    trigger_matugen
    sleep 1
    echo "✅ Color generation processes initiated"
}

main() {
    ensure_gtk3_reload
    echo "🎯 Waypaper integration triggered"
    current_bg=$(get_waypaper_background)
    if [ $? -eq 0 ]; then
        echo "📸 Current Waypaper background: $current_bg"
        if update_config_background "$current_bg"; then
            execute_color_generation
        fi
    else
        echo "⚠️  Could not determine current Waypaper background"
    fi
}

main
EOF
    chmod +x "$HOME/.config/hyprcandy/hooks/waypaper_integration.sh"

    cat > "$HOME/.config/hyprcandy/hooks/waypaper_watcher.sh" << 'EOF'
#!/bin/bash
WAYPAPER_CONFIG="$HOME/.config/waypaper/config.ini"
INTEGRATION_SCRIPT="$HOME/.config/hyprcandy/hooks/waypaper_integration.sh"
wait_for_config() {
    while [ -z "$HYPRLAND_INSTANCE_SIGNATURE" ]; do
        echo "Waiting for Hyprland to start..."
        sleep 1
    done
    echo "Hyprland started"
    echo "🔍 Waiting for Waypaper config to appear..."
    while [ ! -f "$WAYPAPER_CONFIG" ]; do
        echo "⏳ Waiting for Waypaper config to appear..."
        sleep 1
    done
    echo "✅ Waypaper config found"
}
monitor_waypaper() {
    echo "🔍 Starting Waypaper config monitoring..."
    wait_for_config
    inotifywait -m -e modify "$WAYPAPER_CONFIG" | while read -r path action file; do
        echo "🎯 Waypaper config changed, triggering integration..."
        sleep 0.5
        "$INTEGRATION_SCRIPT"
    done
}
initial_setup() {
    echo "🚀 Initial Waypaper integration setup..."
    wait_for_config
    "$INTEGRATION_SCRIPT"
    monitor_waypaper
}
echo "🎨 Starting Waypaper integration watcher..."
initial_setup
EOF
    chmod +x "$HOME/.config/hyprcandy/hooks/waypaper_watcher.sh"

# ═══════════════════════════════════════════════════════════════
#               Systemd Service: Waypaper Watcher
# ═══════════════════════════════════════════════════════════════
    cat > "$HOME/.config/systemd/user/waypaper-watcher.service" << 'EOF'
[Unit]
Description=Monitor Waypaper config changes and trigger color generation
After=graphical-session.target

[Service]
Type=simple
ExecStart=%h/.config/hyprcandy/hooks/waypaper_watcher.sh
Restart=always
RestartSec=10
KillMode=mixed
KillSignal=SIGTERM
TimeoutStopSec=15

[Install]
WantedBy=default.target
EOF

else

# ═══════════════════════════════════════════════════════════════
#         hyprpanel_idle_monitor.sh — Auto Toggle Inhibitor
# ═══════════════════════════════════════════════════════════════

cat > "$HOME/.config/hyprcandy/hooks/hyprpanel_idle_monitor.sh" << 'EOF'
#!/bin/bash

IDLE_INHIBITOR_PID=""
MAKO_PID=""
CHECK_INTERVAL=5
INHIBITOR_WHO="HyprCandy-Monitor"

# Wait for Hyprland to start
while [ -z "$HYPRLAND_INSTANCE_SIGNATURE" ]; do
  echo "Waiting for Hyprland to start..."
  sleep 1
done
echo "Hyprland started"
echo "🔍 Waiting for hyprpanel to start..."

has_hyprpanel_inhibitor() {
    systemd-inhibit --list 2>/dev/null | grep -i "hyprpanel\|panel" >/dev/null 2>&1
}

has_our_inhibitor() {
    systemd-inhibit --list 2>/dev/null | grep "$INHIBITOR_WHO" >/dev/null 2>&1
}

is_mako_running() {
    pgrep -x "mako" > /dev/null 2>&1
}

start_mako() {
    if is_mako_running; then return; fi
    mako &
    MAKO_PID=$!
    sleep 1
}

stop_mako() {
    if [ -n "$MAKO_PID" ] && kill -0 "$MAKO_PID" 2>/dev/null; then
        kill "$MAKO_PID"
        MAKO_PID=""
    elif is_mako_running; then
        pkill -x "mako"
    fi
}

# Function to start idle inhibitor (only if hyprpanel doesn't have one)
start_idle_inhibitor() {
    if has_hyprpanel_inhibitor; then
        echo "$(date): Hyprpanel already has inhibitor"
        return
    fi
    if has_our_inhibitor; then
        echo "$(date): Our idle inhibitor is already active"
        return
    fi
    if [ -z "$IDLE_INHIBITOR_PID" ] || ! kill -0 "$IDLE_INHIBITOR_PID" 2>/dev/null; then
        systemd-inhibit --what=idle --who="$INHIBITOR_WHO" --why="Hyprpanel not running" sleep infinity &
        IDLE_INHIBITOR_PID=$!
    fi
}

stop_idle_inhibitor() {
    if [ -n "$IDLE_INHIBITOR_PID" ] && kill -0 "$IDLE_INHIBITOR_PID" 2>/dev/null; then
        kill "$IDLE_INHIBITOR_PID"
        IDLE_INHIBITOR_PID=""
    fi
}

is_hyprpanel_running() {
    pgrep -f "gjs" > /dev/null 2>&1
}

start_fallback_services() {
    start_idle_inhibitor
    start_mako
}

stop_fallback_services() {
    stop_idle_inhibitor
    stop_mako
}

cleanup() {
    stop_idle_inhibitor
    stop_mako
    exit 0
}

trap cleanup SIGTERM SIGINT

echo "$(date): Starting enhanced hyprpanel monitor..."
echo "$(date): WHO=$INHIBITOR_WHO, CHECK_INTERVAL=${CHECK_INTERVAL}s"

if is_hyprpanel_running; then
    stop_fallback_services
else
    start_fallback_services
fi

while true; do
    if is_hyprpanel_running; then
        if [ -n "$IDLE_INHIBITOR_PID" ] && kill -0 "$IDLE_INHIBITOR_PID" 2>/dev/null; then
            stop_fallback_services
        fi
    else
        needs_inhibitor=false
        needs_mako=false
        if [ -z "$IDLE_INHIBITOR_PID" ] || ! kill -0 "$IDLE_INHIBITOR_PID" 2>/dev/null; then
            if ! has_hyprpanel_inhibitor; then
                needs_inhibitor=true
            fi
        fi
        if ! is_mako_running; then
            needs_mako=true
        fi
        if $needs_inhibitor || $needs_mako; then
            if $needs_inhibitor; then start_idle_inhibitor; fi
            if $needs_mako; then start_mako; fi
        fi
    fi
    sleep "$CHECK_INTERVAL"
done
EOF

chmod +x "$HOME/.config/hyprcandy/hooks/hyprpanel_idle_monitor.sh"

# ═══════════════════════════════════════════════════════════════
#        Systemd Service: hyprpanel Idle Inhibitor Monitor
# ═══════════════════════════════════════════════════════════════

cat > "$HOME/.config/systemd/user/hyprpanel-idle-monitor.service" << 'EOF'
[Unit]
Description=Monitor hyprpanel and manage idle inhibitor
After=graphical-session.target
Wants=graphical-session.target

[Service]
Type=simple
ExecStart=%h/.config/hyprcandy/hooks/hyprpanel_idle_monitor.sh
Restart=always
RestartSec=10
KillMode=mixed
KillSignal=SIGTERM
TimeoutStopSec=15

[Install]
WantedBy=default.target
EOF

# ═══════════════════════════════════════════════════════════════
#             Safe hyprpanel Killer Script (Preserve swww)
# ═══════════════════════════════════════════════════════════════

cat > "$HOME/.config/hyprcandy/hooks/kill_hyprpanel_safe.sh" << 'EOF'
#!/bin/bash

echo "🔄 Safely closing hyprpanel while preserving swww-daemon..."

# Try graceful shutdown
if pgrep -f "hyprpanel" > /dev/null; then
    echo "📱 Attempting graceful shutdown..."
    hyprpanel -q
    sleep 1

    if pgrep -f "hyprpanel" > /dev/null; then
        echo "⚠️  Graceful shutdown failed, trying systemd stop..."
        systemctl --user stop hyprpanel.service
        sleep 1

        if pgrep -f "hyprpanel" > /dev/null; then
            echo "🔨 Force killing hyprpanel processes..."
            pkill -f "gjs.*hyprpanel"
        fi
    fi
fi

# Ensure swww-daemon continues running
if ! pgrep -f "swww-daemon" > /dev/null; then
    echo "🔄 swww-daemon not found, restarting it..."
    swww-daemon &
    sleep 1
    if [ -f "$HOME/.config/background" ]; then
        echo "🖼️  Restoring wallpaper..."
        swww img "$HOME/.config/background" --transition-type fade --transition-duration 1
    fi
fi

echo "✅ hyprpanel safely closed, swww-daemon preserved"
EOF

chmod +x "$HOME/.config/hyprcandy/hooks/kill_hyprpanel_safe.sh"

# ═══════════════════════════════════════════════════════════════
#             Hyprpanel Restart Script (via systemd)
# ═══════════════════════════════════════════════════════════════

cat > "$HOME/.config/hyprcandy/hooks/restart_hyprpanel.sh" << 'EOF'
#!/bin/bash

echo "🔄 Restarting hyprpanel via systemd..."

systemctl --user stop hyprpanel.service
sleep 0.5
systemctl --user start hyprpanel.service

echo "✅ Hyprpanel restarted"
EOF

chmod +x "$HOME/.config/hyprcandy/hooks/restart_hyprpanel.sh"

# ═══════════════════════════════════════════════════════════════
#             Systemd Service: Hyprpanel Launcher
# ═══════════════════════════════════════════════════════════════

cat > "$HOME/.config/systemd/user/hyprpanel.service" << 'EOF'
[Unit]
Description=Hyprpanel - Modern Hyprland panel
After=graphical-session.target hyprland-session.target
Wants=graphical-session.target
PartOf=graphical-session.target
Requisite=graphical-session.target

[Service]
Type=simple
ExecStart=/usr/bin/hyprpanel
Restart=on-failure
RestartSec=6
KillMode=mixed
KillSignal=SIGTERM
TimeoutStopSec=10

# Don't restart if manually stopped (allows keybind control)
RestartPreventExitStatus=143

[Install]
WantedBy=graphical-session.target
EOF
fi

# ═══════════════════════════════════════════════════════════════
#      Script: Update Rofi Font from GTK Settings Font Name
# ═══════════════════════════════════════════════════════════════

cat > "$HOME/.config/hyprcandy/hooks/update_rofi_font.sh" << 'EOF'
#!/bin/bash

GTK_FILE="$HOME/.config/gtk-3.0/settings.ini"
ROFI_RASI="$HOME/.config/hyprcandy/settings/rofi-font.rasi"

# Get font name from GTK settings
GTK_FONT=$(grep "^gtk-font-name=" "$GTK_FILE" | cut -d'=' -f2-)

# Escape double quotes
GTK_FONT_ESCAPED=$(echo "$GTK_FONT" | sed 's/"/\\"/g')

# Update font line in rofi rasi config
if [ -f "$ROFI_RASI" ]; then
    sed -i "s|^.*font:.*|configuration { font: \"$GTK_FONT_ESCAPED\"; }|" "$ROFI_RASI"
    echo "✅ Updated Rofi font to: $GTK_FONT_ESCAPED"
else
    echo "⚠️  Rofi font config not found at: $ROFI_RASI"
fi
EOF

chmod +x "$HOME/.config/hyprcandy/hooks/update_rofi_font.sh"

# ═══════════════════════════════════════════════════════════════
#                  Sync GTK and QT Icon Theme
# ═══════════════════════════════════════════════════════════════

cat > "$HOME/.config/hyprcandy/hooks/update_icon_theme.sh" << 'EOF'
#!/bin/bash

GTK_FILE="$HOME/.config/gtk-3.0/settings.ini"
QT6CT_CONF="$HOME/.config/qt6ct/qt6ct.conf"
QT5CT_CONF="$HOME/.config/qt5ct/qt5ct.conf"
KDEGLOBALS="$HOME/.config/kdeglobals"
UC_COLORS="$HOME/.local/share/color-schemes/HyprCandy.colors"

ICON_THEME=$(grep "^gtk-icon-theme-name=" "$GTK_FILE" | cut -d'=' -f2- | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')

if [ -z "$ICON_THEME" ]; then
    echo "⚠️  Could not read icon theme from $GTK_FILE"
    exit 1
fi

echo "🎨 Syncing icon theme: $ICON_THEME"

for CONF in "$QT6CT_CONF" "$QT5CT_CONF"; do
    [ -f "$CONF" ] || continue
    if grep -q "^icon_theme=" "$CONF"; then
        sed -i "s|^icon_theme=.*|icon_theme=$ICON_THEME|" "$CONF"
    else
        sed -i "/^\[Appearance\]/a icon_theme=$ICON_THEME" "$CONF"
    fi
    echo "✅ $(basename $CONF) icon theme → $ICON_THEME"
done

for FILE in "$KDEGLOBALS" "$UC_COLORS"; do
    [ -f "$FILE" ] || continue
    if grep -q "^Theme=" "$FILE"; then
        sed -i "s|^Theme=.*|Theme=$ICON_THEME|" "$FILE"
    else
        sed -i "/^\[Icons\]/a Theme=$ICON_THEME" "$FILE"
    fi
    echo "✅ $(basename $FILE) icon theme → $ICON_THEME"
done

dbus-send --session --type=signal /kdeglobals \
    org.kde.kconfig.notify.ConfigChanged \
    'array:dict:string,variant:{"Icons":{"Theme":"'"$ICON_THEME"'"}}' 2>/dev/null || true

echo "✅ Icon theme synced to: $ICON_THEME"
EOF

chmod +x "$HOME/.config/hyprcandy/hooks/update_icon_theme.sh"

# ═══════════════════════════════════════════════════════════════
#      Watcher: React to GTK Font Changes via nwg-look
# ═══════════════════════════════════════════════════════════════

cat > "$HOME/.config/hyprcandy/hooks/watch_gtk_font.sh" << 'EOF'
#!/bin/bash

GTK_FILE="$HOME/.config/gtk-3.0/settings.ini"
FONT_HOOK="$HOME/.config/hyprcandy/hooks/update_rofi_font.sh"
ICON_HOOK="$HOME/.config/hyprcandy/hooks/update_icon_theme.sh"

while [ ! -f "$GTK_FILE" ]; do sleep 1; done

"$FONT_HOOK"
"$ICON_HOOK"

# Track previous values to avoid redundant hook calls
PREV_FONT=$(grep "^gtk-font-name=" "$GTK_FILE" | cut -d'=' -f2-)
PREV_ICON=$(grep "^gtk-icon-theme-name=" "$GTK_FILE" | cut -d'=' -f2-)

inotifywait -m -e modify "$GTK_FILE" | while read -r path event file; do
    CUR_FONT=$(grep "^gtk-font-name=" "$GTK_FILE" | cut -d'=' -f2-)
    CUR_ICON=$(grep "^gtk-icon-theme-name=" "$GTK_FILE" | cut -d'=' -f2-)

    if [ "$CUR_FONT" != "$PREV_FONT" ]; then
        "$FONT_HOOK"
        PREV_FONT="$CUR_FONT"
    fi

    if [ "$CUR_ICON" != "$PREV_ICON" ]; then
        "$ICON_HOOK"
        PREV_ICON="$CUR_ICON"
    fi
done
EOF

chmod +x "$HOME/.config/hyprcandy/hooks/watch_gtk_font.sh"

# ═══════════════════════════════════════════════════════════════
#      Systemd Service: GTK Font → Rofi Font Syncer
# ═══════════════════════════════════════════════════════════════

cat > "$HOME/.config/systemd/user/rofi-font-watcher.service" << 'EOF'
[Unit]
Description=Auto-update Rofi font when GTK font changes via nwg-look
After=graphical-session.target

[Service]
ExecStart=%h/.config/hyprcandy/hooks/watch_gtk_font.sh
Restart=on-failure

[Install]
WantedBy=default.target
EOF

# ═══════════════════════════════════════════════════════════════
#               Change Nwg-Dock Start Button Icon
# ═══════════════════════════════════════════════════════════════

cat > "$HOME/.config/hyprcandy/hooks/change_start_button_icon.sh" << 'EOF'
#!/bin/bash

# Change Start Button Icon
 # ⚙️ Step 1: Remove old grid.svg from nwg-dock-hyprland
 echo "🔄 Replacing 'grid.svg' in /usr/share/nwg-dock-hyprland/images..."

print_status "Removing old start button icon"

if cd /usr/share/nwg-dock-hyprland/images 2>/dev/null; then
    pkexec rm -f grid.svg && echo "🗑️  Removed old grid.svg"
else
    echo "❌ Failed to access /usr/share/nwg-dock-hyprland/images"
    exit 1
fi

# 🏠 Step 2: Return to home
cd "$HOME" || exit 1

# 📂 Step 3: Copy new grid.svg from custom SVG folder
SVG_SOURCE="$HOME/Pictures/Candy/Dock-SVGs/grid.svg"
SVG_DEST="/usr/share/nwg-dock-hyprland/images"

print_status "Changing start button icon"

if [ -f "$SVG_SOURCE" ]; then
    pkexec cp "$SVG_SOURCE" "$SVG_DEST" && echo "✅ grid.svg copied successfully."
    sleep 1
    #"$HOME/.config/nwg-dock-hyprland/launch.sh" >/dev/null 2>&1 &
    notify-send "Start Icon Changed" -t 2000
else
    echo "❌ grid.svg not found at $SVG_SOURCE"
    exit 1
fi
EOF
chmod +x "$HOME/.config/hyprcandy/hooks/change_start_button_icon.sh"
chmod +x "$HOME/.config/waybar/scripts/waybar-weather.sh"
chmod +x "$HOME/.config/waybar/scripts/toggle-weather-format.sh"

    # 🛠️ GNOME Window Button Layout Adjustment
    echo
    echo "🛠️ Disabling GNOME titlebar buttons..."

    # Check if 'gsettings' is available on the system
    if command -v gsettings >/dev/null 2>&1; then
        # Run the command to change the window button layout (e.g., remove minimize/maximize buttons)
        gsettings set org.gnome.desktop.wm.preferences button-layout ":close" \
            && echo "✅ GNOME button layout updated." \
            || echo "❌ Failed to update GNOME button layout."
    else
        echo "⚠️  'gsettings' not found. Skipping GNOME button layout configuration."
    fi
    
    # 📁 Copy Candy folder to ~/Pictures
    echo
    echo "📁 Attempting to copy 'Candy' images folder to ~/Pictures..."
    if [ -d "$hyprcandy_dir/Candy" ]; then
        if [ -d "$HOME/Pictures" ]; then
            cp -r "$hyprcandy_dir/Candy" "$HOME/Pictures/"
            echo "✅ 'Candy' copied successfully to ~/Pictures"
        else
            echo "⚠️  Skipped copy: '$HOME/Pictures' directory does not exist."
        fi
    else
        echo "⚠️  'Candy' folder not found in $hyprcandy_dir"
    fi

    # Change Start Button Icon
    # ⚙️ Step 1: Remove old grid.svg from nwg-dock-hyprland
    echo "🔄 Replacing 'grid.svg' in /usr/share/nwg-dock-hyprland/images..."

    print_status "Removing old start button icon"

    if cd /usr/share/nwg-dock-hyprland/images 2>/dev/null; then
        sudo rm -f grid.svg && echo "🗑️  Removed old grid.svg"
    else
        echo "❌ Failed to access /usr/share/nwg-dock-hyprland/images"
    fi

    # 🏠 Step 2: Return to home
    cd "$HOME"
    
    # Add all custom cursors from ~/.icons to system icons
    print_status "Adding custom cursors"
    sudo cp -r $HOME/.icons/* /usr/share/icons
    print_status "Custom sursors added"
    
    # 📂 Step 3: Copy new grid.svg from custom SVG folder
    SVG_SOURCE="$HOME/Pictures/Candy/Dock-SVGs/grid.svg"
    SVG_DEST="/usr/share/nwg-dock-hyprland/images"

    print_status "Changing start button icon"

    if [ -f "$SVG_SOURCE" ]; then
        sudo cp "$SVG_SOURCE" "$SVG_DEST" && echo "✅ grid.svg copied successfully."
    else
        echo "❌ grid.svg not found at $SVG_SOURCE"
    fi

    # 🔐 Add sudoers entry for background script
    echo
    echo "🔄 Adding sddm background auto-update settings..."
    
    # Get the current username
    sudo rm -f /etc/sudoers.d/hyprcandy-background
    USERNAME=$(whoami)

    # Create the sudoers entries for background script and required commands
    SUDOERS_ENTRIES=(
        "$USERNAME ALL=(ALL) NOPASSWD: /usr/bin/magick * /usr/share/sddm/themes/sugar-candy/Backgrounds/*"
        "$USERNAME ALL=(ALL) NOPASSWD: /usr/bin/sed -i s|^Background=*|* /usr/share/sddm/themes/sugar-candy/theme.conf"
        "$USERNAME ALL=(ALL) NOPASSWD: /usr/bin/sed -i s|^BackgroundColor=*|* /usr/share/sddm/themes/sugar-candy/theme.conf"
        "$USERNAME ALL=(ALL) NOPASSWD: /usr/bin/sed -i s|^AccentColor=*|* /usr/share/sddm/themes/sugar-candy/theme.conf"
        "$USERNAME ALL=(ALL) NOPASSWD: /usr/bin/tee /usr/share/sddm/themes/sugar-candy/theme.conf"
        "$USERNAME ALL=(ALL) NOPASSWD: /usr/bin/sed -i s|^CursorTheme=*|* /etc/sddm.conf.d/sugar-candy.conf"
        "$USERNAME ALL=(ALL) NOPASSWD: /usr/bin/sed -i s|^CursorSize=*|* /etc/sddm.conf.d/sugar-candy.conf"
        "$USERNAME ALL=(ALL) NOPASSWD: /usr/bin/mkdir -p /usr/local/share/gtk3-reload"
        "$USERNAME ALL=(ALL) NOPASSWD: /usr/bin/tee /usr/local/share/gtk3-reload/gtk3-reload.c"
        "$USERNAME ALL=(ALL) NOPASSWD: /usr/bin/tee /usr/local/share/gtk3-reload/.gtk3-version"
        "$USERNAME ALL=(ALL) NOPASSWD: /usr/bin/gcc * /usr/local/lib/gtk3-reload.so"
        "$USERNAME ALL=(ALL) NOPASSWD: /usr/bin/gcc -shared -fPIC -o /usr/local/lib/gtk3-reload.so /usr/local/share/gtk3-reload/gtk3-reload.c *"
        "$USERNAME ALL=(ALL) NOPASSWD: /usr/bin/dconf update"
    )

    # Add all entries to sudoers safely using visudo
    printf '%s\n' "${SUDOERS_ENTRIES[@]}" | sudo EDITOR='tee -a' visudo -f /etc/sudoers.d/hyprcandy-background
    
    # Set proper permissions on the sudoers file
    sudo chmod 440 /etc/sudoers.d/hyprcandy-background

    echo "✅ Added sddm background auto-update settings successfully"
    
    # 🎨 Update wlogout style.css with correct username
    echo
    echo "🎨 Updating wlogout style.css with current username..."

	cat > "$HOME/.config/wlogout/style.css" << 'WEOF'
/*
          _                         _
__      _| | ___   __ _  ___  _   _| |_
\ \ /\ / / |/ _ \ / _` |/ _ \| | | | __|
 \ V  V /| | (_) | (_| | (_) | |_| | |_
  \_/\_/ |_|\___/ \__, |\___/ \__,_|\__|
                  |___/

by Stephan Raabe (2023)
-----------------------------------------------------
*/

/* -----------------------------------------------------
 * Import Pywal colors
 * ----------------------------------------------------- */
@import 'colors.css';

/* -----------------------------------------------------
 * General
 * ----------------------------------------------------- */

* {
    font-family: JetbrainsMono Nerd Font Propo;
	background-image: none;
	transition: 20ms;
	box-shadow: none;
}

window {
	background-image: url("/home/$USERNAME/.config/background.png");
	background-size: cover;
	font-size: 16pt;
	color: #cdd6f4;
}

button {
	background-repeat: no-repeat;
    	background-position: center;
    	background-size: 20%;
    	background-color: @scrim;
		opacity: 0.95;
    	animation: gradient_f 20s ease-in infinite;
    	border-radius: 80px; /* Increased border radius for a more rounded look */
	border:0px;
	transition: all 0.3s cubic-bezier(.55, 0.0, .28, 1.682), box-shadow 0s ease-in-out, background-color 0s ease-in-out;
}

button:focus {
    background-size: 25%;
	background-color: @inverse_primary;
	opacity: 0.95;
	color: @scrim;
	border: 0px;
	margin: 30px;
	box-shadow: 0 0 8px @shadow;
}

button:hover {
    background-color: @on_primary;
	opacity: 0.95;
    color: @primary_fixed_dim;
    background-size: 25%;
    margin: 30px;
    border-radius: 80px;
    box-shadow: 0 0 8px @shadow;
}

/* Adjust the size of the icon or content inside the button */
button span {
    font-size: 1em; /* Increase the font size */
}

/*
-----------------------------------------------------
Buttons
-----------------------------------------------------
*/

#lock {
	margin: 5px;
	border-radius: 4px;
	background-image: image(url("icons/lock.png"));
}

#logout {
	margin: 5px;
	border-radius: 4px;
	background-image: image(url("icons/logout.png"));
}

#suspend {
	margin: 5px;
	border-radius: 4px;
	background-image: image(url("icons/suspend.png"));
}

#hibernate {
	margin: 5px;
	border-radius: 4px;
	background-image: image(url("icons/hibernate.png"));
}

#shutdown {
	margin: 5px;
	border-radius: 4px;
	background-image: image(url("icons/shutdown.png"));
}

#reboot {
	margin: 5px;
	border-radius: 4px;
	background-image: image(url("icons/reboot.png"));
}
WEOF
    
    WLOGOUT_STYLE="$HOME/.config/wlogout/style.css"
    
    if [ -f "$WLOGOUT_STYLE" ]; then
        # Replace $USERNAME with actual username in the background image path
        sed -i "s|\$USERNAME|$USERNAME|g" "$WLOGOUT_STYLE"
        echo "✅ Updated wlogout style.css with username: $USERNAME"
    else
        echo "⚠️  wlogout style.css not found at $WLOGOUT_STYLE"
    fi
    # Symlink GTK3 and GTK4 settings files
    #ln -sf ~/.config/gtk-3.0/settings.ini ~/.config/gtk-4.0/settings.ini
}

# Function to enable display manager and prompt for reboot
enable_display_manager() {
    print_status "Enabling $DISPLAY_MANAGER display manager..."
    
    # Disable other display managers first
    print_status "Disabling other display managers..."
    sudo systemctl disable lightdm 2>/dev/null || true
    sudo systemctl disable lxdm 2>/dev/null || true
    if [ "$DISPLAY_MANAGER" != "sddm" ]; then
        sudo systemctl disable sddm 2>/dev/null || true
    fi
    if [ "$DISPLAY_MANAGER" != "gdm" ]; then
        sudo systemctl disable gdm 2>/dev/null || true
    fi
    
    # Enable the selected display manager
    if sudo systemctl enable "$DISPLAY_MANAGER_SERVICE"; then
        print_success "$DISPLAY_MANAGER has been enabled successfully!"
    else
        print_error "Failed to enable $DISPLAY_MANAGER. You may need to enable it manually."
        print_status "Run: sudo systemctl enable $DISPLAY_MANAGER_SERVICE"
    fi
    
    # Additional SDDM configuration if selected
    if [ "$DISPLAY_MANAGER" = "sddm" ]; then
        print_status "Configuring SDDM with Sugar Candy theme..."
        
        sudo rm -rf /etc/sddm.conf.d/
        sleep 1
        # Create SDDM config directory if it doesn't exist
        sudo mkdir -p /etc/sddm.conf.d/
        
        # Configure SDDM to use Sugar Candy theme
        if [ -d "/usr/share/sddm/themes/sugar-candy" ]; then
            sudo tee /etc/sddm.conf.d/sugar-candy.conf > /dev/null << EOF
[Theme]
Current=sugar-candy
CursorTheme=Bibata-Modern-Classic
CursorSize=18
EOF
            # Write full theme config to the sugar-candy theme directory
            sudo tee /usr/share/sddm/themes/sugar-candy/theme.conf > /dev/null << EOF
[General]
Background="Backgrounds/Mountain.png"
DimBackgroundImage="0.0"
ScaleImageCropped="true"
ScreenWidth="1366"
ScreenHeight="768"
FullBlur="false"
PartialBlur="true"
BlurRadius="75"
HaveFormBackground="true"
FormPosition="center"
BackgroundImageHAlignment="center"
BackgroundImageVAlignment="center"
MainColor="white"
AccentColor="#fb884f"
BackgroundColor="#243900"
OverrideLoginButtonTextColor=""
InterfaceShadowSize="6"
InterfaceShadowOpacity="0.6"
RoundCorners="20"
ScreenPadding="0"
Font="Noto Sans"
FontSize=""
ForceRightToLeft="false"
ForceLastUser="true"
ForcePasswordFocus="true"
ForceHideCompletePassword="false"
ForceHideVirtualKeyboardButton="false"
ForceHideSystemButtons="false"
AllowEmptyPassword="false"
AllowBadUsernames="false"
Locale=""
HourFormat="HH:mm"
DateFormat="dddd, d of MMMM"
HeaderText="󰫣  󱀝 󰫣  󱀝 󰫣"
TranslatePlaceholderUsername=""
TranslatePlaceholderPassword=""
TranslateShowPassword=""
TranslateLogin=""
TranslateLoginFailedWarning=""
TranslateCapslockWarning=""
TranslateSession=""
TranslateSuspend=""
TranslateHibernate=""
TranslateReboot=""
TranslateShutdown=""
TranslateVirtualKeyboardButton=""
EOF
            # ── Patch sugar-candy Main.qml for AnimatedImage gif support (once) ──────────
            MAIN_QML="/usr/share/sddm/themes/sugar-candy/Main.qml"

            if [[ -f "$MAIN_QML" ]]; then
                if grep -q "^\s*Image {" "$MAIN_QML"; then
                    sudo sed -i 's/^\(\s*\)Image {/\1AnimatedImage {/' "$MAIN_QML"
                    sudo sed -i '/id: backgroundImage/a\            playing: true' "$MAIN_QML"
                    echo "🎬 Patched Main.qml with AnimatedImage support"
                else
                    echo "✅ Main.qml already patched"
                fi
            fi

            print_success "SDDM configured to use Sugar Candy theme with custom auto-updating background"
        else
            print_warning "Sugar Candy theme not found. SDDM will use default theme."
        fi
    fi
}

# Function to setup default "custom.conf" file
setup_custom_config() {
# Create the custom settings directory and files if it doesn't already exist
        if [ ! -d "$HOME/.config/hyprcustom" ]; then
            mkdir -p "$HOME/.config/hyprcustom" && touch "$HOME/.config/hypr/hyprviz.conf" && touch "$HOME/.config/hyprcustom/custom_lock.conf"
            echo "📁 Created the custom settings directory with 'custom.conf' and 'custom_lock.conf' files to keep your personal Hyprland and Hyprlock changes safe ..."
          if [ "$PANEL_CHOICE" = "waybar" ]; then
 # Add default content to the custom.conf file
            cat > "$HOME/.config/hypr/hyprviz.conf" << 'EOF'
# ██████╗ █████╗ ███╗   ██╗██████╗ ██╗   ██╗
#██╔════╝██╔══██╗████╗  ██║██╔══██╗╚██╗ ██╔╝
#██║     ███████║██╔██╗ ██║██║  ██║ ╚████╔╝ 
#██║     ██╔══██║██║╚██╗██║██║  ██║  ╚██╔╝  
#╚██████╗██║  ██║██║ ╚████║██████╔╝   ██║   
# ╚═════╝╚═╝  ╚═╝╚═╝  ╚═══╝╚═════╝    ╚═╝   

#[IMPORTANT]#
# Add custom settings at the very end of the file.
# This "hypr" folder is backed up on updates so you can copy you "userprefs" from the hyprviz.conf backup to the new file
#[IMPORTANT]#

# ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
# ┃                           Autostart                         ┃
# ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

# Environment must be first — everything else depends on these
exec-once = systemctl --user import-environment WAYLAND_DISPLAY XDG_CURRENT_DESKTOP HYPRLAND_INSTANCE_SIGNATURE
exec-once = dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP=hyprland DBUS_SESSION_BUS_ADDRESS DISPLAY XAUTHORITY

# Portals next — before any app or service that might need them
exec-once = bash ~/.config/hypr/scripts/xdg.sh

# Theme
exec-once = gsettings set org.gnome.desktop.interface gtk-theme 'adw-gtk3-dark'
exec-once = gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'

# System services
exec-once = systemctl --user start hyprpolkitagent
exec-once = systemctl --user start hyprlock-watcher.service
exec-once = systemctl --user start waybar-idle-monitor
exec-once = systemctl --user start waypaper-watcher
exec-once = systemctl --user start rofi-font-watcher
exec-once = systemctl --user start cursor-theme-watcher

# Daemons
exec-once = swww-daemon
exec-once = hypridle
exec-once = /usr/bin/pypr

# UI — after daemons are up
exec-once = swaync
exec-once = blueman-applet
exec-once = bash ~/.config/hyprcandy/hooks/restart_waybar.sh
exec-once = bash ~/.config/hyprcandy/hooks/startup_services.sh
exec-once = bash ~/.config/hyprcandy/scripts/toggle-dock.sh --login

# Wallpaper — after swww-daemon is running
#exec-once = bash ~/.config/hypr/scripts/wallpaper-restore.sh
exec-once = systemctl --user start background-watcher

# Clipboard
exec-once = wl-paste --watch cliphist store

# Overview
env = QS_NO_RELOAD_POPUP,1
exec-once = qs -c overview

# ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
# ┃                           Animations                        ┃
# ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

source = ~/.config/hypr/conf/animations/LimeFrenzy.conf

# ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
# ┃                        Hypraland-colors                     ┃
# ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

source = ~/.config/hypr/colors.conf

# ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
# ┃                         Env-variables                       ┃
# ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

# Packages to have full env path access
env = PATH,$PATH:/usr/local/bin:/usr/bin:/bin:/home/$USERNAME/.cargo/bin

# After using nwg-look, also change the cursor settings here to maintain changes after every reboot
env = XCURSOR_THEME,Bibata-Modern-Classic
env = XCURSOR_SIZE,18
env = HYPRCURSOR_THEME,Bibata-Modern-Classic
env = HYPRCURSOR_SIZE,18

# XDG Desktop Portal
env = XDG_CURRENT_DESKTOP,Hyprland
env = XDG_SESSION_TYPE,wayland
env = XDG_SESSION_DESKTOP,Hyprland
# QT
env = QT_QPA_PLATFORM,wayland
env = QT_QPA_PLATFORMTHEME,qt6ct
env = QT_WAYLAND_DISABLE_WINDOWDECORATION,0
env = QT_AUTO_SCREEN_SCALE_FACTOR,1
# GDK
env = GDK_DEBUG,portals
env = GDK_SCALE,1
# Toolkit Backend
env = GDK_BACKEND,wayland
env = CLUTTER_BACKEND,wayland
# Mozilla
env = MOZ_ENABLE_WAYLAND,1
# Ozone
env = OZONE_PLATFORM,wayland
env = ELECTRON_OZONE_PLATFORM_HINT,wayland
# Extra
env = WINIT_UNIX_BACKEND,wayland
env = WLR_DRM_NO_ATOMIC,1
env = WLR_NO_HARDWARE_CURSORS,1
# Virtual machine display scaling
env = QT_SCALE_FACTOR_ROUNDING_POLICY=PassThrough
# For better VM performance
env = QEMU_AUDIO_DRV=pa

# ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
# ┃                           Keyboard                          ┃
# ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

input {
    kb_layout = $LAYOUT
    kb_variant = 
    kb_model =
    kb_options =
    numlock_by_default = true
    mouse_refocus = false

    follow_mouse = 1
    touchpad {
        # for desktop
        natural_scroll = false

        # for laptop
        # natural_scroll = yes
        # middle_button_emulation = true
        # clickfinger_behavior = false
        scroll_factor = 1.0  # Touchpad scroll factor
    }
    sensitivity = 0 # Pointer speed: -1.0 - 1.0, 0 means no modification.
}

# ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
# ┃                             Layout                          ┃
# ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

general {
    gaps_in = 6
    gaps_out = 8	
    gaps_workspaces = 50    # Gaps between workspaces
    border_size = 3
    col.active_border = $source_color
    col.inactive_border = $background
    layout = scrolling
    resize_on_border = true
    allow_tearing = true
}

group {
    col.border_active =  $source_color
    col.border_inactive = $background
    col.border_locked_active =  $primary_fixed_dim
    col.border_locked_inactive = $background
    
    groupbar {
        font_size = 14
        font_weight_active = heavy
        font_weight_inactive = heavy
        text_color = $surface_tint
        col.active =  $primary_fixed_dim
        col.inactive = $background
        col.locked_active =  $primary_fixed_dim
        col.locked_inactive = $background
        indicator_height = 4
        indicator_gap = 6
    
        # Additional styling options
        height = 10          # Height of the groupbar
        render_titles = true           # Show window titles
        scrolling = true              # Enable scrolling through titles
        
        # Gradients work too (like hyprbars)
        # col.active = $source_color $primary_fixed_dim 45deg
    }
}

dwindle {
    pseudotile = true
    preserve_split = true
}

master {
    new_status = slave
    new_on_active = after
    smart_resizing = true
    drop_at_cursor = true
}

scrolling {
    direction = right
    focus_fit_method = 0
    column_width = 0.5
}

gesture = 3, horizontal, workspace
gesture = 4, swipe, move,
gesture = 2, pinch, float
gestures {
    workspace_swipe_distance = 700
    workspace_swipe_cancel_ratio = 0.2
    workspace_swipe_min_speed_to_force = 5
    workspace_swipe_direction_lock = true
    workspace_swipe_direction_lock_threshold = 10
    workspace_swipe_create_new = true
}

binds {
  workspace_back_and_forth = true
  allow_workspace_cycles = true
  pass_mouse_when_bound = false
}

# ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
# ┃                          Decorations                        ┃
# ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

decoration {
    rounding = 15
    rounding_power = 2
    active_opacity = 0.85
    inactive_opacity = 0.85
    fullscreen_opacity = 1.0

    blur {
    enabled = true
    size = 2
    passes = 4
    new_optimizations = on
    ignore_opacity = true
        xray = false
        vibrancy = 0.24999999999999933
        noise = 0
    popups = true
    popups_ignorealpha = 0.8
        brightness = 1.0000000000000002
        contrast = 0.9999999999999997
        special = false
        vibrancy_darkness = 0.5000000000000002
    }

    shadow {
        enabled = true
        range = 12
        render_power = 4
        color = $scrim
    }
    dim_strength = 0.19999999999999973
    dim_inactive = false
}

# ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
# ┃                          Decorations                        ┃
# ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

decoration {
    rounding = 15
    rounding_power = 2
    active_opacity = 0.8499999999999999
    inactive_opacity = 0.8499999999999999
    fullscreen_opacity = 1.0

    blur {
    enabled = true
    size = 2
    passes = 4
    new_optimizations = on
    ignore_opacity = true
        xray = true
        vibrancy = 0.24999999999999933
        noise = 0
    popups = true
    popups_ignorealpha = 0.8
        brightness = 1.0000000000000002
        contrast = 0.9999999999999997
        special = false
        vibrancy_darkness = 0.5000000000000002
    }

    shadow {
        enabled = true
        range = 12
        render_power = 4
        color = $scrim
    }
    dim_strength = 0.19999999999999973
    dim_inactive = false
}

# ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
# ┃                      Window & layer rules                   ┃
# ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

windowrule = group barred, match:class .*
windowrule = pin on,border_size 0,match:title (candy.utils)
windowrule = pin on,border_size 0,move 960 45,match:title (candy.systemmonitor)
windowrule = pin on,border_size 0,move 420 45,match:title (candy.media)
windowrule = pin on,border_size 0,move 10 45,match:title (candy.weather)
windowrule = opacity 0.85 0.85,match:class ^(kitty|kitty-scratchpad|Alacritty|floating-installer|clock)$
windowrule = float on, center on,size 800 500,match:class (kitty-scratchpad)
windowrule = suppress_event maximize, match:class .* #nofocus,match:class ^$,match:title ^$,xwayland:1,floating:1,fullscreen:0,pinned:0
# Pavucontrol floating
windowrule = float on,match:class (.*org.pulseaudio.pavucontrol.*)
windowrule = size 700 600,match:class (.*org.pulseaudio.pavucontrol.*)
windowrule = center on,match:class (.*org.pulseaudio.pavucontrol.*)
#windowrule = pin on,match:class (.*org.pulseaudio.pavucontrol.*)
# Browser Picture in Picture
windowrule = float on, match:title ^(Picture-in-Picture)$
windowrule = pin on, match:title ^(Picture-in-Picture)$
windowrule = move 69.5% 4%, match:title ^(Picture-in-Picture)$
# Waypaper
windowrule = float on,match:class (.*waypaper.*)
windowrule = size 800 600,match:class (.*waypaper.*)
windowrule = center on,match:class (.*waypaper.*)
#windowrule = pin on,match:class (.*waypaper.*)
# Blueman Manager
windowrule = float on,match:class (blueman-manager)
windowrule = size 800 600,match:class (blueman-manager)
windowrule = center on,match:class (blueman-manager)
# Weather
windowrule = float on,match:class (org.gnome.Weather)
windowrule = size 700 600,match:class (org.gnome.Weather)
windowrule = center on,match:class (org.gnome.Weather)
#windowrule = pin on,match:class (org.gnome.Weather)
# Calendar
windowrule = float on,match:class (org.gnome.Calendar)
windowrule = size 820 600,match:class (org.gnome.Calendar)
windowrule = center on,match:class (org.gnome.Calendar)
#windowrule = pin on,match:class (org.gnome.Calendar)
# System Monitor
windowrule = float on,match:class (org.gnome.SystemMonitor)
windowrule = size 820 625,match:class (org.gnome.SystemMonitor)
windowrule = center on,match:class (org.gnome.SystemMonitor)
#windowrule = pin on,match:class (org.gnome.SystemMonitor)
# Files
windowrule = float on,match:title (Open Files)
windowrule = size 700 600,match:title (Open Files)
windowrule = center on,match:title (Open Files)
#windowrule = pin on,match:title (Open Files)

windowrule = float on,match:title (Select Copy Destination)
windowrule = size 700 600,match:title (Select Copy Destination)
windowrule = center on,match:title (Select Copy Destination)
#windowrule = pin on,match:title (Select Copy Destination)

windowrule = float on,match:title (Select Move Destination)
windowrule = size 700 600,match:title (Select Move Destination)
windowrule = center on,match:title (Select Move Destination)
#windowrule = pin on,match:title (Select Move Destination)

windowrule = float on,match:title (Save As)
windowrule = size 700 600,match:title (Save As)
windowrule = center on,match:title (Save As)
#windowrule = pin on,match:title (Save As)

windowrule = float on,match:title (Select files to send)
windowrule = size 700 600,match:title (Select files to send)
windowrule = center on,match:title (Select files to send)
#windowrule = pin on,match:title (Select files to send)

windowrule = float on,match:title (Bluetooth File Transfer)
#windowrule = pin on,match:title (Bluetooth File Transfer)
# nwg-look
windowrule = float on,match:class (nwg-look)
windowrule = size 700 600,match:class (nwg-look)
windowrule = center on,match:class (nwg-look)
#windowrule = pin on,match:class (nwg-look)
# CachyOS Hello
windowrule = float on,match:class (CachyOSHello)
windowrule = size 700 600,match:class (CachyOSHello)
windowrule = center on,match:class (CachyOSHello)
#windowrule = pin on,match:class (CachyOSHello)
# nwg-displays
windowrule = float on,match:class (nwg-displays)
windowrule = size 990 600,match:class (nwg-displays)
windowrule = center on,match:class (nwg-displays)
#windowrule = pin on,match:class (nwg-displays)
# System Mission Center
windowrule = float on, match:class (io.missioncenter.MissionCenter)
#windowrule = pin on, match:class (io.missioncenter.MissionCenter)
windowrule = center on, match:class (io.missioncenter.MissionCenter)
windowrule = size 900 600, match:class (io.missioncenter.MissionCenter)
# System Mission Center Preference Window
windowrule = float on, match:class (missioncenter), match:title ^(Preferences)$
#windowrule = pin on, match:class (missioncenter), match:title ^(Preferences)$
windowrule = center on, match:class (missioncenter), match:title ^(Preferences)$
# Gnome Calculator
windowrule = float on,match:class (org.gnome.Calculator)
windowrule = size 700 600,match:class (org.gnome.Calculator)
windowrule = center on,match:class (org.gnome.Calculator)
# Emoji Picker Smile
windowrule = float on,match:class (it.mijorus.smile)
#windowrule = pin on, match:class (it.mijorus.smile)
windowrule = move 100%-w-40 90,match:class (it.mijorus.smile)
# Hyprland Share Picker
windowrule = float on, match:class (hyprland-share-picker)
#windowrule = pin on, match:class (hyprland-share-picker)
windowrule = center on, match:title match:class (hyprland-share-picker)
windowrule = size 600 400,match:class (hyprland-share-picker)
# Hyprland Settings App
windowrule = float on,match:title (hyprviz)
windowrule = size 1000 625,match:title (hyprviz)
windowrule = center on,match:title (hyprviz)
# General floating
windowrule = float on,match:class (dotfiles-floating)
windowrule = size 1000 700,match:class (dotfiles-floating)
windowrule = center on,match:class (dotfiles-floating)
# Satty
windowrule = float on,match:title (satty)
windowrule = size 1000 565,match:title (satty)
windowrule = center on,match:title (satty)
# Float Necessary Windows
windowrule = float on, match:class ^(org.pulseaudio.pavucontrol)
windowrule = float on, match:class ^()$,match:title ^(Picture in picture)$
windowrule = float on, match:class ^()$,match:title ^(Save File)$
windowrule = float on, match:class ^()$,match:title ^(Open File)$
windowrule = float on, match:class ^(LibreWolf)$,match:title ^(Picture-in-Picture)$
##windowrule = float on, match:class ^(blueman-manager)$
windowrule = float on, match:class ^(xdg-desktop-portal-hyprland|xdg-desktop-portal-gtk|xdg-desktop-portal-kde)(.*)$
windowrule = float on, match:class ^(hyprpolkitagent|polkit-gnome-authentication-agent-1|org.org.kde.polkit-kde-authentication-agent-1)(.*)$
windowrule = float on, match:class ^(CachyOSHello)$
windowrule = float on, match:class ^(zenity)$
windowrule = float on, match:class ^()$,match:title ^(Steam - Self Updater)$
# Increase the opacity
windowrule = opacity 1.0, match:class ^(zen)$
# # windowrule = opacity 1.0, match:class ^(discord|armcord|webcord)$
# # windowrule = opacity 1.0, match:title ^(QQ|Telegram)$
# # windowrule = opacity 1.0, match:title ^(NetEase Cloud Music Gtk4)$
# General window rules
windowrule = float on, match:title ^(Picture-in-Picture)$
windowrule = size 460 260, match:title ^(Picture-in-Picture)$
windowrule = move 65%- 10%-, match:title ^(Picture-in-Picture)$
windowrule = float on, match:title ^(imv|mpv|danmufloat|termfloat|nemo|ncmpcpp)$
windowrule = move 25%-, match:title ^(imv|mpv|danmufloat|termfloat|nemo|ncmpcpp)$
windowrule = size 960 540, match:title ^(imv|mpv|danmufloat|termfloat|nemo|ncmpcpp)$
#windowrule = pin on, match:title ^(danmufloat)$
windowrule = rounding 5, match:title ^(danmufloat|termfloat)$
windowrule = animation slide right, match:class ^(kitty|Alacritty)$
#windowrule = no_blur on, match:class ^(org.mozilla.firefox)$
# Decorations related to floating windows on workspaces 1 to 10
##windowrule = bordersize 2, floating:1, onworkspace:w[fv1-10]
workspace = w[fv1-10], border_color c $source_color, float on #$on_primary_fixed_variant 90deg
##windowrule = rounding 8, floating:1, onworkspace:w[fv1-10]
# Decorations related to tiling windows on workspaces 1 to 10
##windowrule = bordersize 3, floating:0, onworkspace:f[1-10]
##windowrule = rounding 4, floating:0, onworkspace:f[1-10]
#windowrule = tile, match:title ^(Microsoft-edge)$
vwindowrule = tile, match:title ^(Brave-browser)$
#windowrule = tile, match:title ^(Chromium)$
windowrule = float on, match:title ^(pavucontrol)$
windowrule = float on, match:title ^(blueman-manager)$
windowrule = float on, match:title ^(nm-connection-editor)$
windowrule = float on, match:title ^(qalculate-gtk)$
# idleinhibit
windowrule = idle_inhibit fullscreen,match:class ([window]) # Available modes: none, always, focus, fullscreen
### no blur for specific classes
##windowrule = noblur,match:class ^(?!(nautilus|nwg-look|nwg-displays|zen))
## Windows Rules End #

windowrule = opacity 1.0 $& 1.0 $& 1,match:class ^(nautilus)$
windowrule = opacity 1.0 $& 1.0 $& 1,match:class ^(zen)$
# # windowrule = opacity 1.0 $& 1.0 $& 1,match:class ^(Brave-browser)$
windowrule = opacity 1.0 $& 1.0 $& 1,match:class ^(code-oss)$
windowrule = opacity 1.0 $& 1.0 $& 1,match:class ^([Cc]ode)$
# # windowrule = opacity 1.0 $& 1.0 $& 1,match:class ^(code-url-handler)$
# # windowrule = opacity 1.0 $& 1.0 $& 1,match:class ^(code-insiders-url-handler)$
# # windowrule = opacity 1.0 $& 1.0 $& 1,match:class ^(org.kde.dolphin)$
# # windowrule = opacity 1.0 $& 1.0 $& 1,match:class ^(org.kde.ark)$
windowrule = opacity 1.0 $& 1.0 $& 1,match:class ^(nwg-look)$
windowrule = opacity 1.0 $& 1.0 $& 1,match:class ^(qt5ct)$
windowrule = opacity 1.0 $& 1.0 $& 1,match:class ^(qt6ct)$
windowrule = opacity 1.0 $& 1.0 $& 1,match:class ^(kvantummanager)$
# # windowrule = opacity 1.0 $& 1.0 $& 1,match:class ^(org.pulseaudio.pavucontrol)$
# # windowrule = opacity 1.0 $& 1.0 $& 1,match:class ^(blueman-manager)$
# # windowrule = opacity 1.0 $& 1.0 $& 1,match:class ^(nm-applet)$
# # windowrule = opacity 1.0 $& 1.0 $& 1,match:class ^(nm-connection-editor)$
# # windowrule = opacity 1.0 $& 1.0 $& 1,match:class ^(org.kde.polkit-kde-authentication-agent-1)$
# # windowrule = opacity 1.0 $& 1.0 $& 1,match:class ^(polkit-gnome-authentication-agent-1)$
# # windowrule = opacity 1.0 $& 1.0 $& 1,match:class ^(org.freedesktop.impl.portal.desktop.gtk)$
# # windowrule = opacity 1.0 $& 1.0 $& 1,match:class ^(org.freedesktop.impl.portal.desktop.hyprland)$
# # windowrule = opacity 1.0 $& 1.0 $& 1,match:class ^([Ss]team)$
# # windowrule = opacity 1.0 $& 1.0 $& 1,match:class ^(steamwebhelper)$
windowrule = opacity 1.0 $& 1.0 $& 1,match:class ^([Ss]potify)$
windowrule = opacity 1.0 $& 1.0 $& 1,match:title ^(Spotify Free)$
windowrule = opacity 1.0 $& 1.0 $& 1,match:title ^(Spotify Premium)$
# # 
# # windowrule = opacity 1.0 1.0,match:class ^(com.github.rafostar.Clapper)$ # Clapper-Gtk
# # windowrule = opacity 1.0 1.0,match:class ^(com.github.tchx84.Flatseal)$ # Flatseal-Gtk
# # windowrule = opacity 1.0 1.0,match:class ^(hu.kramo.Cartridges)$ # Cartridges-Gtk
# # windowrule = opacity 1.0 1.0,match:class ^(com.obsproject.Studio)$ # Obs-Qt
# # windowrule = opacity 1.0 1.0,match:class ^(gnome-boxes)$ # Boxes-Gtk
# # windowrule = opacity 1.0 1.0,match:class ^(vesktop)$ # Vesktop
# # windowrule = opacity 1.0 1.0,match:class ^(discord)$ # Discord-Electron
# # windowrule = opacity 1.0 1.0,match:class ^(WebCord)$ # WebCord-Electron
# # windowrule = opacity 1.0 1.0,match:class ^(ArmCord)$ # ArmCord-Electron
# # windowrule = opacity 1.0 1.0,match:class ^(app.drey.Warp)$ # Warp-Gtk
# # windowrule = opacity 1.0 1.0,match:class ^(net.davidotek.pupgui2)$ # ProtonUp-Qt
# # windowrule = opacity 1.0 1.0,match:class ^(yad)$ # Protontricks-Gtk
# # windowrule = opacity 1.0 1.0,match:class ^(Signal)$ # Signal-Gtk
# # windowrule = opacity 1.0 1.0,match:class ^(io.github.alainm23.planify)$ # planify-Gtk
# # windowrule = opacity 1.0 1.0,match:class ^(io.gitlab.theevilskeleton.Upscaler)$ # Upscaler-Gtk
# # windowrule = opacity 1.0 1.0,match:class ^(com.github.unrud.VideoDownloader)$ # VideoDownloader-Gtk
# # windowrule = opacity 1.0 1.0,match:class ^(io.gitlab.adhami3310.Impression)$ # Impression-Gtk
# # windowrule = opacity 1.0 1.0,match:class ^(io.missioncenter.MissionCenter)$ # MissionCenter-Gtk
# # windowrule = opacity 1.0 1.0,match:class ^(io.github.flattool.Warehouse)$ # Warehouse-Gtk
windowrule = float on,match:class ^(org.kde.dolphin)$,match:title ^(Progress Dialog — Dolphin)$
windowrule = float on,match:class ^(org.kde.dolphin)$,match:title ^(Copying — Dolphin)$
windowrule = float on,match:title ^(About Mozilla Firefox)$
windowrule = float on,match:class ^(firefox)$,match:title ^(Picture-in-Picture)$
windowrule = float on,match:class ^(firefox)$,match:title ^(Library)$
windowrule = float on,match:class ^(kitty)$,match:title ^(top)$
windowrule = float on,match:class ^(kitty)$,match:title ^(btop)$
windowrule = float on,match:class ^(kitty)$,match:title ^(htop)$
windowrule = float on,match:class ^(vlc)$
windowrule = float on,match:class ^(eww-main-window)$
windowrule = float on,match:class ^(eww-notifications)$
windowrule = float on,match:class ^(kvantummanager)$
windowrule = float on,match:class ^(qt5ct)$
windowrule = float on,match:class ^(qt6ct)$
windowrule = float on,match:class ^(nwg-look)$
windowrule = float on,match:class ^(org.kde.ark)$
windowrule = float on,match:class ^(org.pulseaudio.pavucontrol)$
windowrule = float on,match:class ^(blueman-manager)$
windowrule = float on,match:class ^(nm-applet)$
windowrule = float on,match:class ^(nm-connection-editor)$
windowrule = float on,match:class ^(org.kde.polkit-kde-authentication-agent-1)$

windowrule = float on,match:class ^(Signal)$ # Signal-Gtk
windowrule = float on,match:class ^(com.github.rafostar.Clapper)$ # Clapper-Gtk
windowrule = float on,match:class ^(app.drey.Warp)$ # Warp-Gtk
windowrule = float on,match:class ^(net.davidotek.pupgui2)$ # ProtonUp-Qt
windowrule = float on,match:class ^(yad)$ # Protontricks-Gtk
windowrule = float on,match:class ^(eog)$ # Imageviewer-Gtk
windowrule = float on,match:class ^(io.github.alainm23.planify)$ # planify-Gtk
windowrule = float on,match:class ^(io.gitlab.theevilskeleton.Upscaler)$ # Upscaler-Gtk
windowrule = float on,match:class ^(com.github.unrud.VideoDownloader)$ # VideoDownloader-Gkk
windowrule = float on,match:class ^(io.gitlab.adhami3310.Impression)$ # Impression-Gtk
windowrule = float on,match:class ^(io.missioncenter.MissionCenter)$ # MissionCenter-Gtk
windowrule = float on,match:class (clipse) # ensure you have a floating window class set if you want this behavior
windowrule = size 622 652,match:class (clipse) # set the size of the window as necessary
#windowrule = noborder, fullscreen:1

# common modals
#windowrule = float on,match:title ^(Open File)$
#windowrule = layer:top,match:class hyprpolkitagent
windowrule = float on,match:title ^(Choose Files)$
windowrule = float on,match:title ^(Save As)$
windowrule = float on,match:title ^(Confirm to replace files)$
windowrule = float on,match:title ^(File Operation Progress)$
windowrule = float on,match:class ^(xdg-desktop-portal-gtk)$

# installer
windowrule = float on, match:class (floating-installer)
windowrule = center on, match:class (floating-installer)

# clock
windowrule = float on, center on, size 400 200, match:class (clock)

# Extra workspace & window rules 
# Workspaces Rules https://wiki.hyprland.org/0.45.0/Configuring/Workspace-Rules/ #
# workspace = 1, default:true, monitor:$priMon
# workspace = 6, default:true, monitor:$secMon
# Workspace selectors https://wiki.hyprland.org/0.45.0/Configuring/Workspace-Rules/#workspace-selectors
# workspace = r[1-5], monitor:$priMon
# workspace = r[6-10], monitor:$secMon
# workspace = special:scratchpad, on-created-empty:$applauncher
# no_gaps_when_only deprecated instead workspaces rules with selectors can do the same
# Smart gaps from 0.45.0 https://wiki.hyprland.org/0.45.0/Configuring/Workspace-Rules/#smart-gaps
#workspace = w[t1], gapsout:0, gapsin:0
#workspace = w[tg1], gapsout:0, gapsin:0
workspace = f[1], gapsout:0, gapsin:0
#windowrule = bordersize 2, floating:0, onworkspace:w[t1]
#windowrule = rounding 10, floating:0, onworkspace:w[t1]
#windowrule = bordersize 2, floating:0, onworkspace:w[tg1]
#windowrule = rounding 10, floating:0, onworkspace:w[tg1]
#windowrule = bordersize 2, floating:0, onworkspace:f[1]
#windowrule = rounding 10, floating:0, onworkspace:f[1]
windowrule = rounding 0, fullscreen true, border_size 0
#workspace = w[tv1-10], gapsout:6, gapsin:2
#workspace = f[1], gapsout:6, gapsin:2

workspace = 1, layoutopt:orientation:left
workspace = 2, layoutopt:orientation:right
workspace = 3, layoutopt:orientation:left
workspace = 4, layoutopt:orientation:right
workspace = 5, layoutopt:orientation:left
workspace = 6, layoutopt:orientation:right
workspace = 7, layoutopt:orientation:left
workspace = 8, layoutopt:orientation:right
workspace = 9, layoutopt:orientation:left
workspace = 10, layoutopt:orientation:right
# Workspaces Rules End #

# Layers Rules #
layerrule = animation slide top, match:namespace logout_dialog
layerrule = blur on,xray on,match:namespace rofi
layerrule = ignore_alpha 0.01,match:namespace rofi
layerrule = blur on,match:namespace notifications
layerrule = ignore_alpha 0.01,match:namespace notifications
layerrule = blur on,match:namespace swaync-notification-window
layerrule = ignore_alpha 0.01,match:namespace swaync-notification-window
layerrule = blur on,xray on,no_anim on,match:namespace swaync-control-center
layerrule = ignore_alpha 0.01,match:namespace swaync-control-center
layerrule = blur on,no_anim on,match:namespace nwg-dock
layerrule = ignore_alpha 0.01,match:namespace nwg-dock
layerrule = blur on,match:namespace logout_dialog
layerrule = ignore_alpha 0.01,match:namespace logout_dialog
layerrule = blur on,match:namespace gtk-layer-shell
layerrule = ignore_alpha 0.01,match:namespace gtk-layer-shell
layerrule = blur on,no_anim on,match:namespace waybar
layerrule = ignore_alpha 0.01,match:namespace waybar
layerrule = blur on,match:namespace dashboardmenu
layerrule = ignore_alpha 0.01,match:namespace dashboardmenu
layerrule = blur on,match:namespace calendarmenu
layerrule = ignore_alpha 0.01,match:namespace calendarmenu
layerrule = blur on,match:namespace notificationsmenu
layerrule = ignore_alpha 0.01,match:namespace notificationsmenu
layerrule = blur on,match:namespace networkmenu
layerrule = ignore_alpha 0.01,match:namespace networkmenu
layerrule = blur on,match:namespace mediamenu
layerrule = ignore_alpha 0.01,match:namespace mediamenu
layerrule = blur on,match:namespace energymenu
layerrule = ignore_alpha 0.01,match:namespace energymenu
layerrule = blur on,match:namespace bluetoothmenu
layerrule = ignore_alpha 0.01,match:namespace bluetoothmenu
layerrule = blur on,match:namespace audiomenu
layerrule = ignore_alpha 0.01,match:namespace audiomenu
layerrule = blur on,match:namespace hyprmenu
layerrule = ignore_alpha 0.01,match:namespace hyprmenu
# layerrule = animation popin 50%, waybar
# Layers Rules End #

# ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
# ┃                         Misc-settings                       ┃
# ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

misc {
    disable_hyprland_logo = true
    disable_splash_rendering = false
    initial_workspace_tracking = 1
}

# ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
# ┃                           Userprefs                         ┃
# ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛
# [NOTE!!] Add you personal settings from here and incase of an update copy them to the new file once this is changed to a backup

debug {
    suppress_errors = true
}

# ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
# ┃                            Plugins                          ┃
# ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

EOF

else  

            # Add default content to the custom.conf file
            cat > "$HOME/.config/hypr/hyprviz.conf" << 'EOF'
# ██████╗ █████╗ ███╗   ██╗██████╗ ██╗   ██╗
#██╔════╝██╔══██╗████╗  ██║██╔══██╗╚██╗ ██╔╝
#██║     ███████║██╔██╗ ██║██║  ██║ ╚████╔╝ 
#██║     ██╔══██║██║╚██╗██║██║  ██║  ╚██╔╝  
#╚██████╗██║  ██║██║ ╚████║██████╔╝   ██║   
# ╚═════╝╚═╝  ╚═╝╚═╝  ╚═══╝╚═════╝    ╚═╝   

#[IMPORTANT]#
# Add custom settings at the very end of the file.
# This "hypr" folder is backed up on updates so you can copy you "userprefs" from the hyprviz.conf backup to the new file
#[IMPORTANT]#

# ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
# ┃                           Autostart                         ┃
# ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

# Environment must be first — everything else depends on these
exec-once = systemctl --user import-environment WAYLAND_DISPLAY XDG_CURRENT_DESKTOP HYPRLAND_INSTANCE_SIGNATURE
exec-once = dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP=hyprland DBUS_SESSION_BUS_ADDRESS DISPLAY XAUTHORITY

# Portals next — before any app or service that might need them
exec-once = bash ~/.config/hypr/scripts/xdg.sh

# Theme
exec-once = gsettings set org.gnome.desktop.interface gtk-theme 'adw-gtk3-dark'
exec-once = gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'

# System services
exec-once = systemctl --user start hyprpolkitagent
exec-once = systemctl --user start hyprlock-watcher.service
exec-once = systemctl --user start hyprpanel-idle-monitor
exec-once = systemctl --user start rofi-font-watcher
exec-once = systemctl --user start cursor-theme-watcher

# Daemons
exec-once = hypridle
exec-once = /usr/bin/pypr

# UI — after daemons are up
exec-once = systemctl --user start hyprpanel
exec-once = bash ~/.config/hyprcandy/hooks/startup_services.sh
exec-once = bash ~/.config/hyprcandy/scripts/toggle-dock.sh --login

# Wallpaper
exec-once = bash ~/.config/hypr/scripts/wallpaper-restore.sh
exec-once = systemctl --user start background-watcher

# Clipboard
exec-once = wl-paste --watch cliphist store

# Overview
env = QS_NO_RELOAD_POPUP,1
exec-once = qs -c overview

# ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
# ┃                           Animations                        ┃
# ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

source = ~/.config/hypr/conf/animations/LimeFrenzy.conf

# ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
# ┃                        Hypraland-colors                     ┃
# ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

source = ~/.config/hypr/colors.conf

# ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
# ┃                         Env-variables                       ┃
# ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

# Packages to have full env path access
env = PATH,$PATH:/usr/local/bin:/usr/bin:/bin:/home/$USERNAME/.cargo/bin

# After using nwg-look, also change the cursor settings here to maintain changes after every reboot
env = XCURSOR_THEME,Bibata-Modern-Classic
env = XCURSOR_SIZE,18
env = HYPRCURSOR_THEME,Bibata-Modern-Classic
env = HYPRCURSOR_SIZE,18

# XDG Desktop Portal
env = XDG_CURRENT_DESKTOP,Hyprland
env = XDG_SESSION_TYPE,wayland
env = XDG_SESSION_DESKTOP,Hyprland
# QT
env = QT_QPA_PLATFORM,wayland
env = QT_QPA_PLATFORMTHEME,qt6ct
env = QT_WAYLAND_DISABLE_WINDOWDECORATION,0
env = QT_AUTO_SCREEN_SCALE_FACTOR,1
# GDK
env = GDK_DEBUG,portals
env = GDK_SCALE,1
# Toolkit Backend
env = GDK_BACKEND,wayland
env = CLUTTER_BACKEND,wayland
# Mozilla
env = MOZ_ENABLE_WAYLAND,1
# Ozone
env = OZONE_PLATFORM,wayland
env = ELECTRON_OZONE_PLATFORM_HINT,wayland
# Extra
env = WINIT_UNIX_BACKEND,wayland
env = WLR_DRM_NO_ATOMIC,1
env = WLR_NO_HARDWARE_CURSORS,1
# Virtual machine display scaling
env = QT_SCALE_FACTOR_ROUNDING_POLICY=PassThrough
# For better VM performance
env = QEMU_AUDIO_DRV=pa

# ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
# ┃                           Keyboard                          ┃
# ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

input {
    kb_layout = $LAYOUT
    kb_variant = 
    kb_model =
    kb_options =
    numlock_by_default = true
    mouse_refocus = false

    follow_mouse = 1
    touchpad {
        # for desktop
        natural_scroll = false

        # for laptop
        # natural_scroll = yes
        # middle_button_emulation = true
        # clickfinger_behavior = false
        scroll_factor = 1.0  # Touchpad scroll factor
    }
    sensitivity = 0 # Pointer speed: -1.0 - 1.0, 0 means no modification.
}

# ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
# ┃                             Layout                          ┃
# ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

general {
    gaps_in = 6
    gaps_out = 8	
    gaps_workspaces = 50    # Gaps between workspaces
    border_size = 3
    col.active_border = $source_color
    col.inactive_border = $background
    layout = scrolling
    resize_on_border = true
    allow_tearing = true
}

group {
    col.border_active =  $source_color
    col.border_inactive = $background
    col.border_locked_active =  $primary_fixed_dim
    col.border_locked_inactive = $background
    
    groupbar {
        font_size = 14
        font_weight_active = heavy
        font_weight_inactive = heavy
        text_color = $surface_tint
        col.active =  $primary_fixed_dim
        col.inactive = $background
        col.locked_active =  $primary_fixed_dim
        col.locked_inactive = $background
        indicator_height = 4
        indicator_gap = 6
    
        # Additional styling options
        height = 10          # Height of the groupbar
        render_titles = true           # Show window titles
        scrolling = true              # Enable scrolling through titles
        
        # Gradients work too (like hyprbars)
        # col.active = $source_color $primary_fixed_dim 45deg
    }
}

dwindle {
    pseudotile = true
    preserve_split = true
}

master {
    new_status = slave
    new_on_active = after
    smart_resizing = true
    drop_at_cursor = true
}

scrolling {
    direction = right
    focus_fit_method = 0
    column_width = 0.5
}

gesture = 3, horizontal, workspace
gesture = 4, swipe, move,
gesture = 2, pinch, float
gestures {
    workspace_swipe_distance = 700
    workspace_swipe_cancel_ratio = 0.2
    workspace_swipe_min_speed_to_force = 5
    workspace_swipe_direction_lock = true
    workspace_swipe_direction_lock_threshold = 10
    workspace_swipe_create_new = true
}

binds {
  workspace_back_and_forth = true
  allow_workspace_cycles = true
  pass_mouse_when_bound = false
}

# ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
# ┃                          Decorations                        ┃
# ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

decoration {
    rounding = 15
    rounding_power = 2
    active_opacity = 0.85
    inactive_opacity = 0.85
    fullscreen_opacity = 1.0

    blur {
    enabled = true
    size = 2
    passes = 4
    new_optimizations = on
    ignore_opacity = true
        xray = false
        vibrancy = 0.24999999999999933
        noise = 0
    popups = true
    popups_ignorealpha = 0.8
        brightness = 1.0000000000000002
        contrast = 0.9999999999999997
        special = false
        vibrancy_darkness = 0.5000000000000002
    }

    shadow {
        enabled = true
        range = 12
        render_power = 4
        color = $scrim
    }
    dim_strength = 0.19999999999999973
    dim_inactive = false
}

# ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
# ┃                          Decorations                        ┃
# ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

decoration {
    rounding = 15
    rounding_power = 2
    active_opacity = 0.8499999999999999
    inactive_opacity = 0.8499999999999999
    fullscreen_opacity = 1.0

    blur {
    enabled = true
    size = 2
    passes = 4
    new_optimizations = on
    ignore_opacity = true
        xray = true
        vibrancy = 0.24999999999999933
        noise = 0
    popups = true
    popups_ignorealpha = 0.8
        brightness = 1.0000000000000002
        contrast = 0.9999999999999997
        special = false
        vibrancy_darkness = 0.5000000000000002
    }

    shadow {
        enabled = true
        range = 12
        render_power = 4
        color = $scrim
    }
    dim_strength = 0.19999999999999973
    dim_inactive = false
}

# ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
# ┃                      Window & layer rules                   ┃
# ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

windowrule = group barred, match:class .*
windowrule = pin on,border_size 0,match:title (candy.utils)
windowrule = pin on,border_size 0,move 960 45,match:title (candy.systemmonitor)
windowrule = pin on,border_size 0,move 420 45,match:title (candy.media)
windowrule = pin on,border_size 0,move 10 45,match:title (candy.weather)
windowrule = opacity 0.85 0.85,match:class ^(kitty|kitty-scratchpad|Alacritty|floating-installer|clock)$
windowrule = float on, center on,size 800 500,match:class (kitty-scratchpad)
windowrule = suppress_event maximize, match:class .* #nofocus,match:class ^$,match:title ^$,xwayland:1,floating:1,fullscreen:0,pinned:0
# Pavucontrol floating
windowrule = float on,match:class (.*org.pulseaudio.pavucontrol.*)
windowrule = size 700 600,match:class (.*org.pulseaudio.pavucontrol.*)
windowrule = center on,match:class (.*org.pulseaudio.pavucontrol.*)
#windowrule = pin on,match:class (.*org.pulseaudio.pavucontrol.*)
# Browser Picture in Picture
windowrule = float on, match:title ^(Picture-in-Picture)$
windowrule = pin on, match:title ^(Picture-in-Picture)$
windowrule = move 69.5% 4%, match:title ^(Picture-in-Picture)$
# Waypaper
windowrule = float on,match:class (.*waypaper.*)
windowrule = size 800 600,match:class (.*waypaper.*)
windowrule = center on,match:class (.*waypaper.*)
#windowrule = pin on,match:class (.*waypaper.*)
# Blueman Manager
windowrule = float on,match:class (blueman-manager)
windowrule = size 800 600,match:class (blueman-manager)
windowrule = center on,match:class (blueman-manager)
# Weather
windowrule = float on,match:class (org.gnome.Weather)
windowrule = size 700 600,match:class (org.gnome.Weather)
windowrule = center on,match:class (org.gnome.Weather)
#windowrule = pin on,match:class (org.gnome.Weather)
# Calendar
windowrule = float on,match:class (org.gnome.Calendar)
windowrule = size 820 600,match:class (org.gnome.Calendar)
windowrule = center on,match:class (org.gnome.Calendar)
#windowrule = pin on,match:class (org.gnome.Calendar)
# System Monitor
windowrule = float on,match:class (org.gnome.SystemMonitor)
windowrule = size 820 625,match:class (org.gnome.SystemMonitor)
windowrule = center on,match:class (org.gnome.SystemMonitor)
#windowrule = pin on,match:class (org.gnome.SystemMonitor)
# Files
windowrule = float on,match:title (Open Files)
windowrule = size 700 600,match:title (Open Files)
windowrule = center on,match:title (Open Files)
#windowrule = pin on,match:title (Open Files)

windowrule = float on,match:title (Select Copy Destination)
windowrule = size 700 600,match:title (Select Copy Destination)
windowrule = center on,match:title (Select Copy Destination)
#windowrule = pin on,match:title (Select Copy Destination)

windowrule = float on,match:title (Select Move Destination)
windowrule = size 700 600,match:title (Select Move Destination)
windowrule = center on,match:title (Select Move Destination)
#windowrule = pin on,match:title (Select Move Destination)

windowrule = float on,match:title (Save As)
windowrule = size 700 600,match:title (Save As)
windowrule = center on,match:title (Save As)
#windowrule = pin on,match:title (Save As)

windowrule = float on,match:title (Select files to send)
windowrule = size 700 600,match:title (Select files to send)
windowrule = center on,match:title (Select files to send)
#windowrule = pin on,match:title (Select files to send)

windowrule = float on,match:title (Bluetooth File Transfer)
#windowrule = pin on,match:title (Bluetooth File Transfer)
# nwg-look
windowrule = float on,match:class (nwg-look)
windowrule = size 700 600,match:class (nwg-look)
windowrule = center on,match:class (nwg-look)
#windowrule = pin on,match:class (nwg-look)
# CachyOS Hello
windowrule = float on,match:class (CachyOSHello)
windowrule = size 700 600,match:class (CachyOSHello)
windowrule = center on,match:class (CachyOSHello)
#windowrule = pin on,match:class (CachyOSHello)
# nwg-displays
windowrule = float on,match:class (nwg-displays)
windowrule = size 990 600,match:class (nwg-displays)
windowrule = center on,match:class (nwg-displays)
#windowrule = pin on,match:class (nwg-displays)
# System Mission Center
windowrule = float on, match:class (io.missioncenter.MissionCenter)
#windowrule = pin on, match:class (io.missioncenter.MissionCenter)
windowrule = center on, match:class (io.missioncenter.MissionCenter)
windowrule = size 900 600, match:class (io.missioncenter.MissionCenter)
# System Mission Center Preference Window
windowrule = float on, match:class (missioncenter), match:title ^(Preferences)$
#windowrule = pin on, match:class (missioncenter), match:title ^(Preferences)$
windowrule = center on, match:class (missioncenter), match:title ^(Preferences)$
# Gnome Calculator
windowrule = float on,match:class (org.gnome.Calculator)
windowrule = size 700 600,match:class (org.gnome.Calculator)
windowrule = center on,match:class (org.gnome.Calculator)
# Emoji Picker Smile
windowrule = float on,match:class (it.mijorus.smile)
#windowrule = pin on, match:class (it.mijorus.smile)
windowrule = move 100%-w-40 90,match:class (it.mijorus.smile)
# Hyprland Share Picker
windowrule = float on, match:class (hyprland-share-picker)
#windowrule = pin on, match:class (hyprland-share-picker)
windowrule = center on, match:title match:class (hyprland-share-picker)
windowrule = size 600 400,match:class (hyprland-share-picker)
# Hyprland Settings App
windowrule = float on,match:title (hyprviz)
windowrule = size 1000 625,match:title (hyprviz)
windowrule = center on,match:title (hyprviz)
# General floating
windowrule = float on,match:class (dotfiles-floating)
windowrule = size 1000 700,match:class (dotfiles-floating)
windowrule = center on,match:class (dotfiles-floating)
# Satty
windowrule = float on,match:title (satty)
windowrule = size 1000 565,match:title (satty)
windowrule = center on,match:title (satty)
# Float Necessary Windows
windowrule = float on, match:class ^(org.pulseaudio.pavucontrol)
windowrule = float on, match:class ^()$,match:title ^(Picture in picture)$
windowrule = float on, match:class ^()$,match:title ^(Save File)$
windowrule = float on, match:class ^()$,match:title ^(Open File)$
windowrule = float on, match:class ^(LibreWolf)$,match:title ^(Picture-in-Picture)$
##windowrule = float on, match:class ^(blueman-manager)$
windowrule = float on, match:class ^(xdg-desktop-portal-hyprland|xdg-desktop-portal-gtk|xdg-desktop-portal-kde)(.*)$
windowrule = float on, match:class ^(hyprpolkitagent|polkit-gnome-authentication-agent-1|org.org.kde.polkit-kde-authentication-agent-1)(.*)$
windowrule = float on, match:class ^(CachyOSHello)$
windowrule = float on, match:class ^(zenity)$
windowrule = float on, match:class ^()$,match:title ^(Steam - Self Updater)$
# Increase the opacity
windowrule = opacity 1.0, match:class ^(zen)$
# # windowrule = opacity 1.0, match:class ^(discord|armcord|webcord)$
# # windowrule = opacity 1.0, match:title ^(QQ|Telegram)$
# # windowrule = opacity 1.0, match:title ^(NetEase Cloud Music Gtk4)$
# General window rules
windowrule = float on, match:title ^(Picture-in-Picture)$
windowrule = size 460 260, match:title ^(Picture-in-Picture)$
windowrule = move 65%- 10%-, match:title ^(Picture-in-Picture)$
windowrule = float on, match:title ^(imv|mpv|danmufloat|termfloat|nemo|ncmpcpp)$
windowrule = move 25%-, match:title ^(imv|mpv|danmufloat|termfloat|nemo|ncmpcpp)$
windowrule = size 960 540, match:title ^(imv|mpv|danmufloat|termfloat|nemo|ncmpcpp)$
#windowrule = pin on, match:title ^(danmufloat)$
windowrule = rounding 5, match:title ^(danmufloat|termfloat)$
windowrule = animation slide right, match:class ^(kitty|Alacritty)$
#windowrule = no_blur on, match:class ^(org.mozilla.firefox)$
# Decorations related to floating windows on workspaces 1 to 10
##windowrule = bordersize 2, floating:1, onworkspace:w[fv1-10]
workspace = w[fv1-10], border_color c $source_color, float on #$on_primary_fixed_variant 90deg
##windowrule = rounding 8, floating:1, onworkspace:w[fv1-10]
# Decorations related to tiling windows on workspaces 1 to 10
##windowrule = bordersize 3, floating:0, onworkspace:f[1-10]
##windowrule = rounding 4, floating:0, onworkspace:f[1-10]
#windowrule = tile, match:title ^(Microsoft-edge)$
vwindowrule = tile, match:title ^(Brave-browser)$
#windowrule = tile, match:title ^(Chromium)$
windowrule = float on, match:title ^(pavucontrol)$
windowrule = float on, match:title ^(blueman-manager)$
windowrule = float on, match:title ^(nm-connection-editor)$
windowrule = float on, match:title ^(qalculate-gtk)$
# idleinhibit
windowrule = idle_inhibit fullscreen,match:class ([window]) # Available modes: none, always, focus, fullscreen
### no blur for specific classes
##windowrule = noblur,match:class ^(?!(nautilus|nwg-look|nwg-displays|zen))
## Windows Rules End #

windowrule = opacity 1.0 $& 1.0 $& 1,match:class ^(nautilus)$
windowrule = opacity 1.0 $& 1.0 $& 1,match:class ^(zen)$
# # windowrule = opacity 1.0 $& 1.0 $& 1,match:class ^(Brave-browser)$
windowrule = opacity 1.0 $& 1.0 $& 1,match:class ^(code-oss)$
windowrule = opacity 1.0 $& 1.0 $& 1,match:class ^([Cc]ode)$
# # windowrule = opacity 1.0 $& 1.0 $& 1,match:class ^(code-url-handler)$
# # windowrule = opacity 1.0 $& 1.0 $& 1,match:class ^(code-insiders-url-handler)$
# # windowrule = opacity 1.0 $& 1.0 $& 1,match:class ^(org.kde.dolphin)$
# # windowrule = opacity 1.0 $& 1.0 $& 1,match:class ^(org.kde.ark)$
windowrule = opacity 1.0 $& 1.0 $& 1,match:class ^(nwg-look)$
windowrule = opacity 1.0 $& 1.0 $& 1,match:class ^(qt5ct)$
windowrule = opacity 1.0 $& 1.0 $& 1,match:class ^(qt6ct)$
windowrule = opacity 1.0 $& 1.0 $& 1,match:class ^(kvantummanager)$
# # windowrule = opacity 1.0 $& 1.0 $& 1,match:class ^(org.pulseaudio.pavucontrol)$
# # windowrule = opacity 1.0 $& 1.0 $& 1,match:class ^(blueman-manager)$
# # windowrule = opacity 1.0 $& 1.0 $& 1,match:class ^(nm-applet)$
# # windowrule = opacity 1.0 $& 1.0 $& 1,match:class ^(nm-connection-editor)$
# # windowrule = opacity 1.0 $& 1.0 $& 1,match:class ^(org.kde.polkit-kde-authentication-agent-1)$
# # windowrule = opacity 1.0 $& 1.0 $& 1,match:class ^(polkit-gnome-authentication-agent-1)$
# # windowrule = opacity 1.0 $& 1.0 $& 1,match:class ^(org.freedesktop.impl.portal.desktop.gtk)$
# # windowrule = opacity 1.0 $& 1.0 $& 1,match:class ^(org.freedesktop.impl.portal.desktop.hyprland)$
# # windowrule = opacity 1.0 $& 1.0 $& 1,match:class ^([Ss]team)$
# # windowrule = opacity 1.0 $& 1.0 $& 1,match:class ^(steamwebhelper)$
windowrule = opacity 1.0 $& 1.0 $& 1,match:class ^([Ss]potify)$
windowrule = opacity 1.0 $& 1.0 $& 1,match:title ^(Spotify Free)$
windowrule = opacity 1.0 $& 1.0 $& 1,match:title ^(Spotify Premium)$
# # 
# # windowrule = opacity 1.0 1.0,match:class ^(com.github.rafostar.Clapper)$ # Clapper-Gtk
# # windowrule = opacity 1.0 1.0,match:class ^(com.github.tchx84.Flatseal)$ # Flatseal-Gtk
# # windowrule = opacity 1.0 1.0,match:class ^(hu.kramo.Cartridges)$ # Cartridges-Gtk
# # windowrule = opacity 1.0 1.0,match:class ^(com.obsproject.Studio)$ # Obs-Qt
# # windowrule = opacity 1.0 1.0,match:class ^(gnome-boxes)$ # Boxes-Gtk
# # windowrule = opacity 1.0 1.0,match:class ^(vesktop)$ # Vesktop
# # windowrule = opacity 1.0 1.0,match:class ^(discord)$ # Discord-Electron
# # windowrule = opacity 1.0 1.0,match:class ^(WebCord)$ # WebCord-Electron
# # windowrule = opacity 1.0 1.0,match:class ^(ArmCord)$ # ArmCord-Electron
# # windowrule = opacity 1.0 1.0,match:class ^(app.drey.Warp)$ # Warp-Gtk
# # windowrule = opacity 1.0 1.0,match:class ^(net.davidotek.pupgui2)$ # ProtonUp-Qt
# # windowrule = opacity 1.0 1.0,match:class ^(yad)$ # Protontricks-Gtk
# # windowrule = opacity 1.0 1.0,match:class ^(Signal)$ # Signal-Gtk
# # windowrule = opacity 1.0 1.0,match:class ^(io.github.alainm23.planify)$ # planify-Gtk
# # windowrule = opacity 1.0 1.0,match:class ^(io.gitlab.theevilskeleton.Upscaler)$ # Upscaler-Gtk
# # windowrule = opacity 1.0 1.0,match:class ^(com.github.unrud.VideoDownloader)$ # VideoDownloader-Gtk
# # windowrule = opacity 1.0 1.0,match:class ^(io.gitlab.adhami3310.Impression)$ # Impression-Gtk
# # windowrule = opacity 1.0 1.0,match:class ^(io.missioncenter.MissionCenter)$ # MissionCenter-Gtk
# # windowrule = opacity 1.0 1.0,match:class ^(io.github.flattool.Warehouse)$ # Warehouse-Gtk
windowrule = float on,match:class ^(org.kde.dolphin)$,match:title ^(Progress Dialog — Dolphin)$
windowrule = float on,match:class ^(org.kde.dolphin)$,match:title ^(Copying — Dolphin)$
windowrule = float on,match:title ^(About Mozilla Firefox)$
windowrule = float on,match:class ^(firefox)$,match:title ^(Picture-in-Picture)$
windowrule = float on,match:class ^(firefox)$,match:title ^(Library)$
windowrule = float on,match:class ^(kitty)$,match:title ^(top)$
windowrule = float on,match:class ^(kitty)$,match:title ^(btop)$
windowrule = float on,match:class ^(kitty)$,match:title ^(htop)$
windowrule = float on,match:class ^(vlc)$
windowrule = float on,match:class ^(eww-main-window)$
windowrule = float on,match:class ^(eww-notifications)$
windowrule = float on,match:class ^(kvantummanager)$
windowrule = float on,match:class ^(qt5ct)$
windowrule = float on,match:class ^(qt6ct)$
windowrule = float on,match:class ^(nwg-look)$
windowrule = float on,match:class ^(org.kde.ark)$
windowrule = float on,match:class ^(org.pulseaudio.pavucontrol)$
windowrule = float on,match:class ^(blueman-manager)$
windowrule = float on,match:class ^(nm-applet)$
windowrule = float on,match:class ^(nm-connection-editor)$
windowrule = float on,match:class ^(org.kde.polkit-kde-authentication-agent-1)$

windowrule = float on,match:class ^(Signal)$ # Signal-Gtk
windowrule = float on,match:class ^(com.github.rafostar.Clapper)$ # Clapper-Gtk
windowrule = float on,match:class ^(app.drey.Warp)$ # Warp-Gtk
windowrule = float on,match:class ^(net.davidotek.pupgui2)$ # ProtonUp-Qt
windowrule = float on,match:class ^(yad)$ # Protontricks-Gtk
windowrule = float on,match:class ^(eog)$ # Imageviewer-Gtk
windowrule = float on,match:class ^(io.github.alainm23.planify)$ # planify-Gtk
windowrule = float on,match:class ^(io.gitlab.theevilskeleton.Upscaler)$ # Upscaler-Gtk
windowrule = float on,match:class ^(com.github.unrud.VideoDownloader)$ # VideoDownloader-Gkk
windowrule = float on,match:class ^(io.gitlab.adhami3310.Impression)$ # Impression-Gtk
windowrule = float on,match:class ^(io.missioncenter.MissionCenter)$ # MissionCenter-Gtk
windowrule = float on,match:class (clipse) # ensure you have a floating window class set if you want this behavior
windowrule = size 622 652,match:class (clipse) # set the size of the window as necessary
#windowrule = noborder, fullscreen:1

# common modals
#windowrule = float on,match:title ^(Open File)$
#windowrule = layer:top,match:class hyprpolkitagent
windowrule = float on,match:title ^(Choose Files)$
windowrule = float on,match:title ^(Save As)$
windowrule = float on,match:title ^(Confirm to replace files)$
windowrule = float on,match:title ^(File Operation Progress)$
windowrule = float on,match:class ^(xdg-desktop-portal-gtk)$

# installer
windowrule = float on, match:class (floating-installer)
windowrule = center on, match:class (floating-installer)

# clock
windowrule = float on, center on, size 400 200, match:class (clock)

# Extra workspace & window rules 
# Workspaces Rules https://wiki.hyprland.org/0.45.0/Configuring/Workspace-Rules/ #
# workspace = 1, default:true, monitor:$priMon
# workspace = 6, default:true, monitor:$secMon
# Workspace selectors https://wiki.hyprland.org/0.45.0/Configuring/Workspace-Rules/#workspace-selectors
# workspace = r[1-5], monitor:$priMon
# workspace = r[6-10], monitor:$secMon
# workspace = special:scratchpad, on-created-empty:$applauncher
# no_gaps_when_only deprecated instead workspaces rules with selectors can do the same
# Smart gaps from 0.45.0 https://wiki.hyprland.org/0.45.0/Configuring/Workspace-Rules/#smart-gaps
#workspace = w[t1], gapsout:0, gapsin:0
#workspace = w[tg1], gapsout:0, gapsin:0
workspace = f[1], gapsout:0, gapsin:0
#windowrule = bordersize 2, floating:0, onworkspace:w[t1]
#windowrule = rounding 10, floating:0, onworkspace:w[t1]
#windowrule = bordersize 2, floating:0, onworkspace:w[tg1]
#windowrule = rounding 10, floating:0, onworkspace:w[tg1]
#windowrule = bordersize 2, floating:0, onworkspace:f[1]
#windowrule = rounding 10, floating:0, onworkspace:f[1]
windowrule = rounding 0, fullscreen true, border_size 0
#workspace = w[tv1-10], gapsout:6, gapsin:2
#workspace = f[1], gapsout:6, gapsin:2

workspace = 1, layoutopt:orientation:left
workspace = 2, layoutopt:orientation:right
workspace = 3, layoutopt:orientation:left
workspace = 4, layoutopt:orientation:right
workspace = 5, layoutopt:orientation:left
workspace = 6, layoutopt:orientation:right
workspace = 7, layoutopt:orientation:left
workspace = 8, layoutopt:orientation:right
workspace = 9, layoutopt:orientation:left
workspace = 10, layoutopt:orientation:right
# Workspaces Rules End #

# Layers Rules #
layerrule = animation slide top, match:namespace logout_dialog
layerrule = blur on,xray on,match:namespace rofi
layerrule = ignore_alpha 0.01,match:namespace rofi
layerrule = blur on,match:namespace notifications
layerrule = ignore_alpha 0.01,match:namespace notifications
layerrule = blur on,match:namespace swaync-notification-window
layerrule = ignore_alpha 0.01,match:namespace swaync-notification-window
layerrule = blur on,xray on,no_anim on,match:namespace swaync-control-center
layerrule = ignore_alpha 0.01,match:namespace swaync-control-center
layerrule = blur on,no_anim on,match:namespace nwg-dock
layerrule = ignore_alpha 0.01,match:namespace nwg-dock
layerrule = blur on,match:namespace logout_dialog
layerrule = ignore_alpha 0.01,match:namespace logout_dialog
layerrule = blur on,match:namespace gtk-layer-shell
layerrule = ignore_alpha 0.01,match:namespace gtk-layer-shell
layerrule = blur on,no_anim on,match:namespace bar-0
layerrule = ignore_alpha 0.01,match:namespace bar-0
layerrule = blur on,match:namespace dashboardmenu
layerrule = ignore_alpha 0.01,match:namespace dashboardmenu
layerrule = blur on,match:namespace calendarmenu
layerrule = ignore_alpha 0.01,match:namespace calendarmenu
layerrule = blur on,match:namespace notificationsmenu
layerrule = ignore_alpha 0.01,match:namespace notificationsmenu
layerrule = blur on,match:namespace networkmenu
layerrule = ignore_alpha 0.01,match:namespace networkmenu
layerrule = blur on,match:namespace mediamenu
layerrule = ignore_alpha 0.01,match:namespace mediamenu
layerrule = blur on,match:namespace energymenu
layerrule = ignore_alpha 0.01,match:namespace energymenu
layerrule = blur on,match:namespace bluetoothmenu
layerrule = ignore_alpha 0.01,match:namespace bluetoothmenu
layerrule = blur on,match:namespace audiomenu
layerrule = ignore_alpha 0.01,match:namespace audiomenu
layerrule = blur on,match:namespace hyprmenu
layerrule = ignore_alpha 0.01,match:namespace hyprmenu
# layerrule = animation popin 50%, waybar
# Layers Rules End #

# ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
# ┃                         Misc-settings                       ┃
# ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

misc {
    disable_hyprland_logo = true
    disable_splash_rendering = false
    initial_workspace_tracking = 1
}

# ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
# ┃                           Userprefs                         ┃
# ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛
# [NOTE!!] Add you personal settings from here and incase of an update copy them to the new file once this is changed to a backup

debug {
    suppress_errors = true
}

# ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
# ┃                            Plugins                          ┃
# ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

EOF
fi

            # Add default content to the custom_lock.conf file
            cat > "$HOME/.config/hyprcustom/custom_lock.conf" << 'EOF'
# ██╗  ██╗██╗   ██╗██████╗ ██████╗ ██╗      ██████╗  ██████╗██╗  ██╗
# ██║  ██║╚██╗ ██╔╝██╔══██╗██╔══██╗██║     ██╔═══██╗██╔════╝██║ ██╔╝
# ███████║ ╚████╔╝ ██████╔╝██████╔╝██║     ██║   ██║██║     █████╔╝ 
# ██╔══██║  ╚██╔╝  ██╔═══╝ ██╔══██╗██║     ██║   ██║██║     ██╔═██╗ 
# ██║  ██║   ██║   ██║     ██║  ██║███████╗╚██████╔╝╚██████╗██║  ██╗
# ╚═╝  ╚═╝   ╚═╝   ╚═╝     ╚═╝  ╚═╝╚══════╝ ╚═════╝  ╚═════╝╚═╝  ╚═╝

source = ~/.config/hypr/colors.conf

general {
    ignore_empty_input = true
    hide_cursor = true
}

auth {
    fingerprint {
        enabled = true
        ready_message = Scan fingerprint to unlock
        present_message = Scanning...
        retry_delay = 250 # in milliseconds
    }
}

background {
    monitor =
    path = ~/.config/background.png
    blur_passes = 4
    blur_sizes = 0
    vibrancy = 0.1696
    noise = 0.01
    contrast = 0.8916
}

input-field {
    monitor =
    size = 200, 50
    outline_thickness = 3
    dots_size = 0.25 # Scale of input-field height, 0.2 - 0.8
    dots_spacing = 0.2 # Scale of dots' absolute size, 0.0 - 1.0
    dots_center = true
    dots_rounding = -1 # -1 default circle, -2 follow input-field rounding
    outer_color = $primary_fixed_dim $on_secondary 90deg
    inner_color = $on_primary_fixed_variant
    font_color = $primary_fixed_dim
    font_family = C059 Bold Italic
    fade_on_empty = false
    fade_timeout = 1000 # Milliseconds before fade_on_empty is triggered.
    placeholder_text = <i><span>       $USER       </span></i># Text rendered in the input box when it's empty. # foreground="$inverse_primary ##ffffff99
    hide_input = false
    rounding = 20 # -1 means complete rounding (circle/oval)
    check_color = $rimary
    fail_color = $error # if authentication failed, changes outer_color and fail message color
    fail_text = <i>$FAIL <b>($ATTEMPTS)</b></i> # can be set to empty
    fail_transition = 300 # transition time in ms between normal outer_color and fail_color
    capslock_color = $primary_fixed_dim
    numlock_color = $primary_fixed_dim $on_secondary 90deg
    #bothlock_color = -1 # when both locks are active. -1 means don't change outer color (same for above)
    invert_numlock = false # change color if numlock is off
    swap_font_color = false # see below
    position = 0, 150
    halign = center
    valign = bottom
    shadow_passes = 10
    shadow_size = 20
    shadow_color = $shadow
    shadow_boost = 1.6
}

label {
    monitor =
    #date
    text = cmd[update:60000] date +"%A, %d %B %Y"
    color = $primary_fixed_dim
    font_size = 20
    font_family = C059 Bold
    position = 0, -35
    halign = center
    valign = top
}

label {
    monitor =
    #clock
    text = cmd[update:1000] echo "$TIME"
    color = $on_primary_fixed_variant
    font_size = 55
    font_family = C059 Bold Italic
    position = 0, -150
    halign = center
    valign = top
    shadow_passes = 5
    shadow_size = 10
}

#label {
    monitor =
    #text = ✝      $USER    ✝ #  $USER
    color = $primary_fixed_dim
    font_size = 20
    font_family = C059 Bold
    position = 0, 100
    halign = center
    valign = bottom
    shadow_passes = 5
    shadow_size = 10
}

image {
    monitor =
    path = ~/.config/lock.png #.face.icon
    size = 160  lesser side if not 1:1 ratio
    rounding = -1 # negative values mean circle
    border_size = 4
    border_color = $primary_fixed_dim $on_secondary 90deg
    rotate = 0 # degrees, counter-clockwise
    reload_time = -1 # seconds between reloading, 0 to reload with SIGUSR2
#    reload_cmd =  # command to get new path. if empty, old path will be used. don't run "follow" commands like tail -F
    position = 0, 0
    halign = center
    valign = center
}
EOF

if [ "$PANEL_CHOICE" = "waybar" ]; then

            # Add default content to the custom_keybinds.conf file
            cat > "$HOME/.config/hyprcustom/custom_keybinds.conf" << 'EOF'
# ██╗  ██╗███████╗██╗   ██╗██████╗ ██╗███╗   ██╗██████╗ ███████╗
# ██║ ██╔╝██╔════╝╚██╗ ██╔╝██╔══██╗██║████╗  ██║██╔══██╗██╔════╝
# █████╔╝ █████╗   ╚████╔╝ ██████╔╝██║██╔██╗ ██║██║  ██║███████╗
# ██╔═██╗ ██╔══╝    ╚██╔╝  ██╔══██╗██║██║╚██╗██║██║  ██║╚════██║
# ██║  ██╗███████╗   ██║   ██████╔╝██║██║ ╚████║██████╔╝███████║
# ╚═╝  ╚═╝╚══════╝   ╚═╝   ╚═════╝ ╚═╝╚═╝  ╚═══╝╚═════╝ ╚══════╝

#
$mainMod = SUPER
$HYPRSCRIPTS = ~/.config/hypr/scripts
$SCRIPTS = ~/.config/hyprcandy/scripts
$EDITOR = gedit # Change from the default editor to your prefered editor
$DISCORD = equibop
#

#### Kill active window ####

bind = $mainMod, Escape, killactive #Kill single active window
bind = $mainMod SHIFT, Escape, exec, hyprctl activewindow | grep pid | tr -d 'pid:' | xargs kill #Quit active window and all similar open instances

#### Rofi Menus ####

bind = $mainMod CTRL, R, exec, $HYPRSCRIPTS/rofi-menus.sh     #Launch utilities rofi-menu
bind = $mainMod, A, exec, rofi -show drun || pkill rofi      #Launch or kill/hide rofi application finder
bind = $mainMod, K, exec, $HYPRSCRIPTS/keybindings.sh     #Show keybindings
bind = $mainMod CTRL, A, exec, $HYPRSCRIPTS/animations.sh     #Select animations
bind = $mainMod CTRL, V, exec, $SCRIPTS/cliphist.sh     #Open clipboard manager
bind = $mainMod CTRL, E, exec, ~/.config/hyprcandy/settings/emojipicker.sh 		  #Open rofi emoji-picker
bind = $mainMod CTRL, G, exec, ~/.config/hyprcandy/settings/glyphpicker.sh 		  #Open rofi glyph-picker

#### Applications ####

bind = $mainMod, W, exec, waypaper #Waypaper
bind = ALT, W, exec, ~/.config/waypaper/wallpaper-cycle.sh  #Alternate wallpapers
bind = $mainMod, S, exec, spotify-launcher #Spotify
bind = $mainMod, D, exec, $DISCORD #Discord
bind = $mainMod, C, exec, DRI_PRIME=1 $EDITOR #Editor
bind = $mainMod, B, exec, DRI_PRIME=1 xdg-open "http://" #Launch your default browser
bind = $mainMod, Q, exec, kitty #Launch normal kitty instances
bind = $mainMod, Return, exec, DRI_PRIME=1 pypr toggle term #Launch a kitty scratchpad through pyprland
bind = $mainMod, O, exec, DRI_PRIME=1 /usr/bin/octopi #Launch octopi application finder
bind = $mainMod, E, exec, DRI_PRIME=1 nautilus #Launch the filemanager 
bind = $mainMod CTRL, C, exec, DRI_PRIME=1 gnome-calculator #Launch the calculator

#### Bar/Panel ####

bind = ALT, 1, exec, ~/.config/hyprcandy/hooks/kill_waybar_safe.sh #Hide/kill waybar and start automatic idle-inhibitor
bind = ALT, 2, exec, ~/.config/hyprcandy/hooks/restart_waybar.sh #Restart or reload waybar and stop automatic idle-inhibitor

#### Dock keybinds ####

bind = ALT, 3, exec, $SCRIPTS/toggle-dock.sh --restore #Hide/kill or launch dock
bind = ALT, 4, exec, ~/.config/hyprcandy/hooks/nwg_dock_status_display.sh #Dock status display

#### Status display ####

bind = ALT, 5, exec, ~/.config/hyprcandy/hooks/hyprland_status_display.sh #Hyprland status display

#### Recorder ####

# Wf--recorder (simple recorder) + slurp (allows to select a specific region of the monitor)
# {to list audio devices run "pactl list sources | grep Name"}   
bind = $mainMod, R, exec, bash -c 'wf-recorder -g -a --audio=bluez_output.78_15_2D_0D_BD_B7.1.monitor -f "$HOME/Videos/Recordings/recording-$(date +%Y%m%d-%H%M%S).mp4" $(slurp)' # Start recording
bind = Alt, R, exec, pkill -x wf-recorder #Stop recording

#### Hyprsunset ####

bind = Shift, H, exec, hyprctl hyprsunset gamma +10 #Increase gamma by 10%
bind = Alt, H, exec, hyprctl hyprsunset gamma -10 #Reduce gamma by 10%


#### Actions ####

bind = ALT, G, exec, $HYPRSCRIPTS/gamemode.sh						  #Toggle game-mode
#bind = $mainMod, M, exec, ~/.config/hypr/scripts/power.sh exit 				  #Logout
#bind = $mainMod,SPACE, hyprexpo:expo, toggle						  #Hyprexpo-plus workspaces overview
bind = $mainMod SHIFT, R, exec, $HYPRSCRIPTS/loadconfig.sh                                 #Reload Hyprland configuration
bind = $mainMod SHIFT, A, exec, $HYPRSCRIPTS/toggle-animations.sh                         #Toggle animations
bind = $mainMod, PRINT, exec, $HYPRSCRIPTS/screenshot.sh                                  #Take a screenshot
bind = $mainMod CTRL, Q, exec, $SCRIPTS/wlogout.sh            				  #Start wlogout ~/.config/hyprcandy/scripts
bind = $mainMod, V, exec, cliphist wipe 						  #Clear cliphist database
bind = $mainMod CTRL, D, exec, $ cliphist list | dmenu | cliphist delete 		  #Delete an old item
bind = $mainMod ALT, D, exec, $ cliphist delete-query "secret item"  			  #Delete an old item quering manually
bind = $mainMod ALT, S, exec, $ cliphist list | dmenu | cliphist decode | wl-copy    	  #Select an old item
bind = $mainMod ALT, O, exec, $HYPRSCRIPTS/window-opacity.sh                              #Change opacity
bind = $mainMod, L, exec, ~/.config/hypr/scripts/power.sh lock 				  #Lock


#### Workspaces ####

bind = SHIFT, TAB, exec, $SCRIPTS/overview.sh #Workspace overview

bind = $mainMod, 1, workspace, 1  #Open workspace 1
bind = $mainMod, 2, workspace, 2  #Open workspace 2
bind = $mainMod, 3, workspace, 3  #Open workspace 3
bind = $mainMod, 4, workspace, 4  #Open workspace 4
bind = $mainMod, 5, workspace, 5  #Open workspace 5
bind = $mainMod, 6, workspace, 6  #Open workspace 6
bind = $mainMod, 7, workspace, 7  #Open workspace 7
bind = $mainMod, 8, workspace, 8  #Open workspace 8
bind = $mainMod, 9, workspace, 9  #Open workspace 9
bind = $mainMod, 0, workspace, 10 #Open workspace 10

bind = $mainMod SHIFT, 1, movetoworkspace, 1  #Move active window to workspace 1
bind = $mainMod SHIFT, 2, movetoworkspace, 2  #Move active window to workspace 2
bind = $mainMod SHIFT, 3, movetoworkspace, 3  #Move active window to workspace 3
bind = $mainMod SHIFT, 4, movetoworkspace, 4  #Move active window to workspace 4
bind = $mainMod SHIFT, 5, movetoworkspace, 5  #Move active window to workspace 5
bind = $mainMod SHIFT, 6, movetoworkspace, 6  #Move active window to workspace 6
bind = $mainMod SHIFT, 7, movetoworkspace, 7  #Move active window to workspace 7
bind = $mainMod SHIFT, 8, movetoworkspace, 8  #Move active window to workspace 8
bind = $mainMod SHIFT, 9, movetoworkspace, 9  #Move active window to workspace 9
bind = $mainMod SHIFT, 0, movetoworkspace, 10 #Move active window to workspace 10

bind = $mainMod, Tab, workspace, m+1       #Open next workspace
bind = $mainMod SHIFT, Tab, workspace, m-1 #Open previous workspace

bind = $mainMod CTRL, 1, exec, $HYPRSCRIPTS/moveTo.sh 1  #Move all windows to workspace 1
bind = $mainMod CTRL, 2, exec, $HYPRSCRIPTS/moveTo.sh 2  #Move all windows to workspace 2
bind = $mainMod CTRL, 3, exec, $HYPRSCRIPTS/moveTo.sh 3  #Move all windows to workspace 3
bind = $mainMod CTRL, 4, exec, $HYPRSCRIPTS/moveTo.sh 4  #Move all windows to workspace 4
bind = $mainMod CTRL, 5, exec, $HYPRSCRIPTS/moveTo.sh 5  #Move all windows to workspace 5
bind = $mainMod CTRL, 6, exec, $HYPRSCRIPTS/moveTo.sh 6  #Move all windows to workspace 6
bind = $mainMod CTRL, 7, exec, $HYPRSCRIPTS/moveTo.sh 7  #Move all windows to workspace 7
bind = $mainMod CTRL, 8, exec, $HYPRSCRIPTS/moveTo.sh 8  #Move all windows to workspace 8
bind = $mainMod CTRL, 9, exec, $HYPRSCRIPTS/moveTo.sh 9  #Move all windows to workspace 9
bind = $mainMod CTRL, 0, exec, $HYPRSCRIPTS/moveTo.sh 10  #Move all windows to workspace 10

bind = $mainMod, mouse_down, workspace, e+1  #Open next workspace
bind = $mainMod, mouse_up, workspace, e-1    #Open previous workspace
bind = $mainMod CTRL, down, workspace, empty #Open the next empty workspace

#### Minimize windows using special workspaces ####

bind = CTRL SHIFT, 1, togglespecialworkspace, magic #Togle window from special workspace
bind = CTRL SHIFT, 2, movetoworkspace, +0 #Move window to special workspace 2 (Can be toggled with "$mainMod,1")
bind = CTRL SHIFT, 3, togglespecialworkspace, magic #Togle window to and from special workspace
bind = CTRL SHIFT, 4, movetoworkspace, special:magic #Move window to special workspace 4 (Can be toggled with "$mainMod,1")
bind = CTRL SHIFT, 5, togglespecialworkspace, magic #Togle window to and from special workspace


#### Windows ####

bind = $mainMod ALT, 1, movetoworkspacesilent, 1  #Move active window to workspace 1 silently
bind = $mainMod ALT, 2, movetoworkspacesilent, 2  #Move active window to workspace 2 silently
bind = $mainMod ALT, 3, movetoworkspacesilent, 3  #Move active window to workspace 3 silently
bind = $mainMod ALT, 4, movetoworkspacesilent, 4  #Move active window to workspace 4 silently
bind = $mainMod ALT, 5, movetoworkspacesilent, 5  #Move active window to workspace 5 silently
bind = $mainMod ALT, 6, movetoworkspacesilent, 6  #Move active window to workspace 6 silently
bind = $mainMod ALT, 7, movetoworkspacesilent, 7  #Move active window to workspace 7 silently
bind = $mainMod ALT, 8, movetoworkspacesilent, 8  #Move active window to workspace 8 silently
bind = $mainMod ALT, 9, movetoworkspacesilent, 9  #Move active window to workspace 9 silently
bind = $mainMod ALT, 0, movetoworkspacesilent, 10  #Move active window to workspace 10 silently 

bindm = $mainMod, Z, movewindow #Hold to move selected window
bindm = $mainMod, X, resizewindow #Hold to resize selected window

bind = $mainMod, F, fullscreen, 0                                                           #Set active window to fullscreen
bind = $mainMod SHIFT, M, fullscreen, 1                                                           #Maximize Window
bind = $mainMod CTRL, F, togglefloating                                                     #Toggle active windows into floating mode
bind = $mainMod CTRL, T, exec, $HYPRSCRIPTS/toggleallfloat.sh                               #Toggle all windows into floating mode
bind = $mainMod, J, togglesplit                                                             #Toggle split
bind = $mainMod, left, movefocus, l                                                         #Move focus left
bind = $mainMod, right, movefocus, r                                                        #Move focus right
bind = $mainMod, up, movefocus, u                                                           #Move focus up
bind = $mainMod, down, movefocus, d                                                         #Move focus down
bindm = $mainMod, mouse:272, movewindow                                                     #Move window with the mouse
bindm = $mainMod, mouse:273, resizewindow                                                   #Resize window with the mouse
bind = $mainMod SHIFT, right, resizeactive, 100 0                                           #Increase window width with keyboard
bind = $mainMod SHIFT, left, resizeactive, -100 0                                           #Reduce window width with keyboard
bind = $mainMod SHIFT, down, resizeactive, 0 100                                            #Increase window height with keyboard
bind = $mainMod SHIFT, up, resizeactive, 0 -100                                             #Reduce window height with keyboard
bind = $mainMod, G, togglegroup                                                             #Toggle window group
bind = $mainMod CTRL, left, changegroupactive, prev				  	    #Switch to the previous window in the group
bind = $mainMod CTRL, right, changegroupactive, next					    #Switch to the next window in the group
bind = $mainMod CTRL, K, swapsplit                                                               #Swapsplit
bind = $mainMod ALT, left, swapwindow, l                                                    #Swap tiled window left
bind = $mainMod ALT, right, swapwindow, r                                                   #Swap tiled window right
bind = $mainMod ALT, up, swapwindow, u                                                      #Swap tiled window up
bind = $mainMod ALT, down, swapwindow, d                                                    #Swap tiled window down
binde = ALT,Tab,cyclenext                                                                   #Cycle between windows
binde = ALT,Tab,bringactivetotop                                                            #Bring active window to the top
bind = ALT, S, layoutmsg, swapwithmaster master 					    #Switch current focused window to master
bind = $mainMod SHIFT, L, exec, hyprctl keyword general:layout "$(hyprctl getoption general:layout | grep -q 'dwindle' && echo 'master' || echo 'dwindle')" #Toggle between dwindle and master layout


#### Fn keys ####

bind = , XF86MonBrightnessUp, exec, brightnessctl -q s +10% && notify-send "Screen Brightness" "$(brightnessctl | grep -o '[0-9]*%' | head -1)" -t 1000  #Increase brightness by 10% 
bind = , XF86MonBrightnessDown, exec, brightnessctl -q s 10%- && notify-send "Screen Brightness" "$(brightnessctl | grep -o '[0-9]*%' | head -1)" -t 1000 #Reduce brightness by 10%
bind = , XF86AudioRaiseVolume, exec, pactl set-sink-mute @DEFAULT_SINK@ 0 && pactl set-sink-volume @DEFAULT_SINK@ +5% && notify-send "Volume" "$(pactl get-sink-volume @DEFAULT_SINK@ | grep -o '[0-9]*%' | head -1)" -t 1000
bind = , XF86AudioLowerVolume, exec, pactl set-sink-mute @DEFAULT_SINK@ 0 && pactl set-sink-volume @DEFAULT_SINK@ -5% && notify-send "Volume" "$(pactl get-sink-volume @DEFAULT_SINK@ | grep -o '[0-9]*%' | head -1)" -t 1000
bind = , XF86AudioMute, exec, pactl set-sink-mute @DEFAULT_SINK@ toggle && if pactl get-sink-mute @DEFAULT_SINK@ | grep -q 'yes'; then notify-send "Volume" "Muted" -t 1000; else notify-send "Volume" "$(pactl get-sink-volume @DEFAULT_SINK@ | grep -o '[0-9]*%' | head -1)" -t 1000; fi
bind = , XF86AudioPlay, exec, playerctl play-pause #Audio play pause
bind = , XF86AudioPause, exec, playerctl pause #Audio pause
bind = , XF86AudioNext, exec, playerctl next #Audio next
bind = , XF86AudioPrev, exec, playerctl previous #Audio previous
bind = , XF86AudioMicMute, exec, pactl set-source-mute @DEFAULT_SOURCE@ toggle #Toggle microphone
bind = , XF86Calculator, exec, ~/.config/hyprcandy/settings/calculator.sh  #Open calculator
bind = , XF86Lock, exec, hyprlock #Open screenlock

# Keyboard backlight controls with notifications
bind = , code:236, exec, brightnessctl -d smc::kbd_backlight s +10 && notify-send "Keyboard Backlight" "$(brightnessctl -d smc::kbd_backlight | grep -o '[0-9]*%' | head -1)" -t 1000
bind = , code:237, exec, brightnessctl -d smc::kbd_backlight s 10- && notify-send "Keyboard Backlight" "$(brightnessctl -d smc::kbd_backlight | grep -o '[0-9]*%' | head -1)" -t 1000

# Screen brightness controls with notifications
bind = Shift, F2, exec, brightnessctl -q s +10% && notify-send "Screen Brightness" "$(brightnessctl | grep -o '[0-9]*%' | head -1)" -t 1000
bind = Shift, F1, exec, brightnessctl -q s 10%- && notify-send "Screen Brightness" "$(brightnessctl | grep -o '[0-9]*%' | head -1)" -t 1000

# Volume mute toggle with notification
bind = Shift, F9, exec, pactl set-sink-mute @DEFAULT_SINK@ toggle && if pactl get-sink-mute @DEFAULT_SINK@ | grep -q 'yes'; then notify-send "Volume" "Muted" -t 1000; else notify-send "Volume" "$(pactl get-sink-volume @DEFAULT_SINK@ | grep -o '[0-9]*%' | head -1)" -t 1000; fi

# Volume controls with notifications
bind = Shift, F8, exec, pactl set-sink-mute @DEFAULT_SINK@ 0 && pactl set-sink-volume @DEFAULT_SINK@ +5% && notify-send "Volume" "$(pactl get-sink-volume @DEFAULT_SINK@ | grep -o '[0-9]*%' | head -1)" -t 1000
bind = Shift, F7, exec, pactl set-sink-mute @DEFAULT_SINK@ 0 && pactl set-sink-volume @DEFAULT_SINK@ -5% && notify-send "Volume" "$(pactl get-sink-volume @DEFAULT_SINK@ | grep -o '[0-9]*%' | head -1)" -t 1000

bind = Shift, F4, exec, playerctl play-pause #Toggle play/pause
bind = Shift, F6, exec, playerctl next #Play next video/song
bind = Shift, F5, exec, playerctl previous #Play previous video/song
EOF

else

            # Add default content to the custom_keybinds.conf file
            cat > "$HOME/.config/hyprcustom/custom_keybinds.conf" << 'EOF'
# ██╗  ██╗███████╗██╗   ██╗██████╗ ██╗███╗   ██╗██████╗ ███████╗
# ██║ ██╔╝██╔════╝╚██╗ ██╔╝██╔══██╗██║████╗  ██║██╔══██╗██╔════╝
# █████╔╝ █████╗   ╚████╔╝ ██████╔╝██║██╔██╗ ██║██║  ██║███████╗
# ██╔═██╗ ██╔══╝    ╚██╔╝  ██╔══██╗██║██║╚██╗██║██║  ██║╚════██║
# ██║  ██╗███████╗   ██║   ██████╔╝██║██║ ╚████║██████╔╝███████║
# ╚═╝  ╚═╝╚══════╝   ╚═╝   ╚═════╝ ╚═╝╚═╝  ╚═══╝╚═════╝ ╚══════╝

#
$mainMod = SUPER
$HYPRSCRIPTS = ~/.config/hypr/scripts
$SCRIPTS = ~/.config/hyprcandy/scripts
$EDITOR = gedit # Change from the default editor to your prefered editor
$DISCORD = equibop
#

#### Kill active window ####

bind = $mainMod, Escape, killactive #Kill single active window
bind = $mainMod SHIFT, Escape, exec, hyprctl activewindow | grep pid | tr -d 'pid:' | xargs kill #Quit active window and all similar open instances

#### Rofi Menus ####

bind = $mainMod CTRL, R, exec, $HYPRSCRIPTS/rofi-menus.sh     #Launch utilities rofi-menu
bind = $mainMod, A, exec, rofi -show drun || pkill rofi      #Launch or kill/hide rofi application finder
bind = $mainMod, K, exec, $HYPRSCRIPTS/keybindings.sh     #Show keybindings
bind = $mainMod CTRL, A, exec, $HYPRSCRIPTS/animations.sh     #Select animations
bind = $mainMod CTRL, V, exec, $SCRIPTS/cliphist.sh     #Open clipboard manager
bind = $mainMod CTRL, E, exec, ~/.config/hyprcandy/settings/emojipicker.sh 		  #Open rofi emoji-picker
bind = $mainMod CTRL, G, exec, ~/.config/hyprcandy/settings/glyphpicker.sh 		  #Open rofi glyph-picker

#### Applications ####

bind = $mainMod, W, exec, waypaper #Waypaper
bind = $mainMod, S, exec, spotify-launcher #Spotify
bind = $mainMod, D, exec, $DISCORD #Discord
bind = $mainMod, C, exec, DRI_PRIME=1 $EDITOR #Editor
bind = $mainMod, B, exec, DRI_PRIME=1 xdg-open "http://" #Launch your default browser
bind = $mainMod, Q, exec, kitty #Launch normal kitty instances
bind = $mainMod, Return, exec, DRI_PRIME=1 pypr toggle term #Launch a kitty scratchpad through pyprland
bind = $mainMod, O, exec, DRI_PRIME=1 /usr/bin/octopi #Launch octopi application finder
bind = $mainMod, E, exec, DRI_PRIME=1 nautilus #Launch the filemanager 
bind = $mainMod CTRL, C, exec, DRI_PRIME=1 gnome-calculator #Launch the calculator

#### Bar/Panel ####

bind = ALT, 1, exec, ~/.config/hyprcandy/hooks/kill_hyprpanel_safe.sh #Hide/kill hyprpanel and start automatic idle-inhibitor
bind = ALT, 2, exec, ~/.config/hyprcandy/hooks/restart_hyprpanel.sh #Restart or reload hyprpanel and stop automatic idle-inhibitor

#### Dock keybinds ####

bind = ALT, 3, exec, $SCRIPTS/toggle-dock.sh --restore #Hide/kill or launch dock
bind = ALT, 4, exec, ~/.config/hyprcandy/hooks/nwg_dock_status_display.sh #Dock status display

#### Status display ####

bind = ALT, 5, exec, ~/.config/hyprcandy/hooks/hyprland_status_display.sh #Hyprland status display

#### Recorder ####

# Wf--recorder (simple recorder) + slurp (allows to select a specific region of the monitor)
# {to list audio devices run "pactl list sources | grep Name"}   
bind = $mainMod, R, exec, bash -c 'wf-recorder -g -a --audio=bluez_output.78_15_2D_0D_BD_B7.1.monitor -f "$HOME/Videos/Recordings/recording-$(date +%Y%m%d-%H%M%S).mp4" $(slurp)' # Start recording
bind = Alt, R, exec, pkill -x wf-recorder #Stop recording

#### Hyprsunset ####

bind = Shift, H, exec, hyprctl hyprsunset gamma +10 #Increase gamma by 10%
bind = Alt, H, exec, hyprctl hyprsunset gamma -10 #Reduce gamma by 10%


#### Actions ####

bind = ALT, G, exec, $HYPRSCRIPTS/gamemode.sh						  #Toggle game-mode
#bind = $mainMod, M, exec, ~/.config/hypr/scripts/power.sh exit 				  #Logout
#bind = $mainMod,SPACE, hyprexpo:expo, toggle						  #Hyprexpo-plus workspaces overview
bind = $mainMod SHIFT, R, exec, $HYPRSCRIPTS/loadconfig.sh                                 #Reload Hyprland configuration
bind = $mainMod SHIFT, A, exec, $HYPRSCRIPTS/toggle-animations.sh                         #Toggle animations
bind = $mainMod, PRINT, exec, $HYPRSCRIPTS/screenshot.sh                                  #Take a screenshot
bind = $mainMod CTRL, Q, exec, $SCRIPTS/wlogout.sh            				  #Start wlogout ~/.config/hyprcandy/scripts
bind = $mainMod, V, exec, cliphist wipe 						  #Clear cliphist database
bind = $mainMod CTRL, D, exec, $ cliphist list | dmenu | cliphist delete 		  #Delete an old item
bind = $mainMod ALT, D, exec, $ cliphist delete-query "secret item"  			  #Delete an old item quering manually
bind = $mainMod ALT, S, exec, $ cliphist list | dmenu | cliphist decode | wl-copy    	  #Select an old item
bind = $mainMod ALT, O, exec, $HYPRSCRIPTS/window-opacity.sh                              #Change opacity
bind = $mainMod, L, exec, ~/.config/hypr/scripts/power.sh lock 				  #Lock


#### Workspaces ####

bind = SHIFT, TAB, exec, $SCRIPTS/overview.sh #Workspace overview

bind = $mainMod, 1, workspace, 1  #Open workspace 1
bind = $mainMod, 2, workspace, 2  #Open workspace 2
bind = $mainMod, 3, workspace, 3  #Open workspace 3
bind = $mainMod, 4, workspace, 4  #Open workspace 4
bind = $mainMod, 5, workspace, 5  #Open workspace 5
bind = $mainMod, 6, workspace, 6  #Open workspace 6
bind = $mainMod, 7, workspace, 7  #Open workspace 7
bind = $mainMod, 8, workspace, 8  #Open workspace 8
bind = $mainMod, 9, workspace, 9  #Open workspace 9
bind = $mainMod, 0, workspace, 10 #Open workspace 10

bind = $mainMod SHIFT, 1, movetoworkspace, 1  #Move active window to workspace 1
bind = $mainMod SHIFT, 2, movetoworkspace, 2  #Move active window to workspace 2
bind = $mainMod SHIFT, 3, movetoworkspace, 3  #Move active window to workspace 3
bind = $mainMod SHIFT, 4, movetoworkspace, 4  #Move active window to workspace 4
bind = $mainMod SHIFT, 5, movetoworkspace, 5  #Move active window to workspace 5
bind = $mainMod SHIFT, 6, movetoworkspace, 6  #Move active window to workspace 6
bind = $mainMod SHIFT, 7, movetoworkspace, 7  #Move active window to workspace 7
bind = $mainMod SHIFT, 8, movetoworkspace, 8  #Move active window to workspace 8
bind = $mainMod SHIFT, 9, movetoworkspace, 9  #Move active window to workspace 9
bind = $mainMod SHIFT, 0, movetoworkspace, 10 #Move active window to workspace 10

bind = $mainMod, Tab, workspace, m+1       #Open next workspace
bind = $mainMod SHIFT, Tab, workspace, m-1 #Open previous workspace

bind = $mainMod CTRL, 1, exec, $HYPRSCRIPTS/moveTo.sh 1  #Move all windows to workspace 1
bind = $mainMod CTRL, 2, exec, $HYPRSCRIPTS/moveTo.sh 2  #Move all windows to workspace 2
bind = $mainMod CTRL, 3, exec, $HYPRSCRIPTS/moveTo.sh 3  #Move all windows to workspace 3
bind = $mainMod CTRL, 4, exec, $HYPRSCRIPTS/moveTo.sh 4  #Move all windows to workspace 4
bind = $mainMod CTRL, 5, exec, $HYPRSCRIPTS/moveTo.sh 5  #Move all windows to workspace 5
bind = $mainMod CTRL, 6, exec, $HYPRSCRIPTS/moveTo.sh 6  #Move all windows to workspace 6
bind = $mainMod CTRL, 7, exec, $HYPRSCRIPTS/moveTo.sh 7  #Move all windows to workspace 7
bind = $mainMod CTRL, 8, exec, $HYPRSCRIPTS/moveTo.sh 8  #Move all windows to workspace 8
bind = $mainMod CTRL, 9, exec, $HYPRSCRIPTS/moveTo.sh 9  #Move all windows to workspace 9
bind = $mainMod CTRL, 0, exec, $HYPRSCRIPTS/moveTo.sh 10  #Move all windows to workspace 10

bind = $mainMod, mouse_down, workspace, e+1  #Open next workspace
bind = $mainMod, mouse_up, workspace, e-1    #Open previous workspace
bind = $mainMod CTRL, down, workspace, empty #Open the next empty workspace

#### Minimize windows using special workspaces ####

bind = CTRL SHIFT, 1, togglespecialworkspace, magic #Togle window from special workspace
bind = CTRL SHIFT, 2, movetoworkspace, +0 #Move window to special workspace 2 (Can be toggled with "$mainMod,1")
bind = CTRL SHIFT, 3, togglespecialworkspace, magic #Togle window to and from special workspace
bind = CTRL SHIFT, 4, movetoworkspace, special:magic #Move window to special workspace 4 (Can be toggled with "$mainMod,1")
bind = CTRL SHIFT, 5, togglespecialworkspace, magic #Togle window to and from special workspace


#### Windows ####

bind = $mainMod ALT, 1, movetoworkspacesilent, 1  #Move active window to workspace 1 silently
bind = $mainMod ALT, 2, movetoworkspacesilent, 2  #Move active window to workspace 2 silently
bind = $mainMod ALT, 3, movetoworkspacesilent, 3  #Move active window to workspace 3 silently
bind = $mainMod ALT, 4, movetoworkspacesilent, 4  #Move active window to workspace 4 silently
bind = $mainMod ALT, 5, movetoworkspacesilent, 5  #Move active window to workspace 5 silently
bind = $mainMod ALT, 6, movetoworkspacesilent, 6  #Move active window to workspace 6 silently
bind = $mainMod ALT, 7, movetoworkspacesilent, 7  #Move active window to workspace 7 silently
bind = $mainMod ALT, 8, movetoworkspacesilent, 8  #Move active window to workspace 8 silently
bind = $mainMod ALT, 9, movetoworkspacesilent, 9  #Move active window to workspace 9 silently
bind = $mainMod ALT, 0, movetoworkspacesilent, 10  #Move active window to workspace 10 silently 

bindm = $mainMod, Z, movewindow #Hold to move selected window
bindm = $mainMod, X, resizewindow #Hold to resize selected window

bind = $mainMod, F, fullscreen, 0                                                           #Set active window to fullscreen
bind = $mainMod SHIFT, M, fullscreen, 1                                                           #Maximize Window
bind = $mainMod CTRL, F, togglefloating                                                     #Toggle active windows into floating mode
bind = $mainMod CTRL, T, exec, $HYPRSCRIPTS/toggleallfloat.sh                               #Toggle all windows into floating mode
bind = $mainMod, J, togglesplit                                                             #Toggle split
bind = $mainMod, left, movefocus, l                                                         #Move focus left
bind = $mainMod, right, movefocus, r                                                        #Move focus right
bind = $mainMod, up, movefocus, u                                                           #Move focus up
bind = $mainMod, down, movefocus, d                                                         #Move focus down
bindm = $mainMod, mouse:272, movewindow                                                     #Move window with the mouse
bindm = $mainMod, mouse:273, resizewindow                                                   #Resize window with the mouse
bind = $mainMod SHIFT, right, resizeactive, 100 0                                           #Increase window width with keyboard
bind = $mainMod SHIFT, left, resizeactive, -100 0                                           #Reduce window width with keyboard
bind = $mainMod SHIFT, down, resizeactive, 0 100                                            #Increase window height with keyboard
bind = $mainMod SHIFT, up, resizeactive, 0 -100                                             #Reduce window height with keyboard
bind = $mainMod, G, togglegroup                                                             #Toggle window group
bind = $mainMod CTRL, left, changegroupactive, prev				  	    #Switch to the previous window in the group
bind = $mainMod CTRL, right, changegroupactive, next					    #Switch to the next window in the group
bind = $mainMod CTRL, K, swapsplit                                                               #Swapsplit
bind = $mainMod ALT, left, swapwindow, l                                                    #Swap tiled window left
bind = $mainMod ALT, right, swapwindow, r                                                   #Swap tiled window right
bind = $mainMod ALT, up, swapwindow, u                                                      #Swap tiled window up
bind = $mainMod ALT, down, swapwindow, d                                                    #Swap tiled window down
binde = ALT,Tab,cyclenext                                                                   #Cycle between windows
binde = ALT,Tab,bringactivetotop                                                            #Bring active window to the top
bind = ALT, S, layoutmsg, swapwithmaster master 					    #Switch current focused window to master
bind = $mainMod SHIFT, L, exec, hyprctl keyword general:layout "$(hyprctl getoption general:layout | grep -q 'dwindle' && echo 'master' || echo 'dwindle')" #Toggle between dwindle and master layout


#### Fn keys ####

bind = , XF86MonBrightnessUp, exec, brightnessctl -q s +10% && notify-send "Screen Brightness" "$(brightnessctl | grep -o '[0-9]*%' | head -1)" -t 1000  #Increase brightness by 10% 
bind = , XF86MonBrightnessDown, exec, brightnessctl -q s 10%- && notify-send "Screen Brightness" "$(brightnessctl | grep -o '[0-9]*%' | head -1)" -t 1000 #Reduce brightness by 10%
bind = , XF86AudioRaiseVolume, exec, pactl set-sink-mute @DEFAULT_SINK@ 0 && pactl set-sink-volume @DEFAULT_SINK@ +5% && notify-send "Volume" "$(pactl get-sink-volume @DEFAULT_SINK@ | grep -o '[0-9]*%' | head -1)" -t 1000
bind = , XF86AudioLowerVolume, exec, pactl set-sink-mute @DEFAULT_SINK@ 0 && pactl set-sink-volume @DEFAULT_SINK@ -5% && notify-send "Volume" "$(pactl get-sink-volume @DEFAULT_SINK@ | grep -o '[0-9]*%' | head -1)" -t 1000
bind = , XF86AudioMute, exec, pactl set-sink-mute @DEFAULT_SINK@ toggle && if pactl get-sink-mute @DEFAULT_SINK@ | grep -q 'yes'; then notify-send "Volume" "Muted" -t 1000; else notify-send "Volume" "$(pactl get-sink-volume @DEFAULT_SINK@ | grep -o '[0-9]*%' | head -1)" -t 1000; fi
bind = , XF86AudioPlay, exec, playerctl play-pause #Audio play pause
bind = , XF86AudioPause, exec, playerctl pause #Audio pause
bind = , XF86AudioNext, exec, playerctl next #Audio next
bind = , XF86AudioPrev, exec, playerctl previous #Audio previous
bind = , XF86AudioMicMute, exec, pactl set-source-mute @DEFAULT_SOURCE@ toggle #Toggle microphone
bind = , XF86Calculator, exec, ~/.config/hyprcandy/settings/calculator.sh  #Open calculator
bind = , XF86Lock, exec, hyprlock #Open screenlock

# Keyboard backlight controls with notifications
bind = , code:236, exec, brightnessctl -d smc::kbd_backlight s +10 && notify-send "Keyboard Backlight" "$(brightnessctl -d smc::kbd_backlight | grep -o '[0-9]*%' | head -1)" -t 1000
bind = , code:237, exec, brightnessctl -d smc::kbd_backlight s 10- && notify-send "Keyboard Backlight" "$(brightnessctl -d smc::kbd_backlight | grep -o '[0-9]*%' | head -1)" -t 1000

# Screen brightness controls with notifications
bind = Shift, F2, exec, brightnessctl -q s +10% && notify-send "Screen Brightness" "$(brightnessctl | grep -o '[0-9]*%' | head -1)" -t 1000
bind = Shift, F1, exec, brightnessctl -q s 10%- && notify-send "Screen Brightness" "$(brightnessctl | grep -o '[0-9]*%' | head -1)" -t 1000

# Volume mute toggle with notification
bind = Shift, F9, exec, pactl set-sink-mute @DEFAULT_SINK@ toggle && if pactl get-sink-mute @DEFAULT_SINK@ | grep -q 'yes'; then notify-send "Volume" "Muted" -t 1000; else notify-send "Volume" "$(pactl get-sink-volume @DEFAULT_SINK@ | grep -o '[0-9]*%' | head -1)" -t 1000; fi

# Volume controls with notifications
bind = Shift, F8, exec, pactl set-sink-mute @DEFAULT_SINK@ 0 && pactl set-sink-volume @DEFAULT_SINK@ +5% && notify-send "Volume" "$(pactl get-sink-volume @DEFAULT_SINK@ | grep -o '[0-9]*%' | head -1)" -t 1000
bind = Shift, F7, exec, pactl set-sink-mute @DEFAULT_SINK@ 0 && pactl set-sink-volume @DEFAULT_SINK@ -5% && notify-send "Volume" "$(pactl get-sink-volume @DEFAULT_SINK@ | grep -o '[0-9]*%' | head -1)" -t 1000

bind = Shift, F4, exec, playerctl play-pause #Toggle play/pause
bind = Shift, F6, exec, playerctl next #Play next video/song
bind = Shift, F5, exec, playerctl previous #Play previous video/song
EOF
fi

    # 🎨 Update Hyprland custom.conf with current username  
    USERNAME=$(whoami)      
    HYPRLAND_CUSTOM="$HOME/.config/hypr/hyprviz.conf"
    echo "🎨 Updating Hyprland custom.conf with current username..."		
    
    if [ -f "$HYPRLAND_CUSTOM" ]; then
        sed -i "s|\$USERNAME|$USERNAME|g" "$HYPRLAND_CUSTOM"
        echo "✅ Updated custom.conf PATH with username: $USERNAME"
    else
        echo "⚠️  File not found: $HYPRLAND_CUSTOM"
    fi
        fi
}

update_keybinds() {
    local CONFIG_FILE="$HOME/.config/hyprcustom/custom_keybinds.conf"
    
    # Check if config file exists
    if [ ! -f "$CONFIG_FILE" ]; then
        print_error "Config file not found: $CONFIG_FILE"
        return 1
    fi
    
    # Optional: Create backup (uncomment if needed)
    # cp "$CONFIG_FILE" "${CONFIG_FILE}.backup.$(date +%Y%m%d_%H%M%S)"
    # echo -e "${GREEN}Backup created${NC}"
    
    # Check current panel configuration to avoid unnecessary changes
    if grep -q "waybar" "$CONFIG_FILE" && [ "$PANEL_CHOICE" = "waybar" ]; then
        print_warning "Keybinds already set for waybar"
        return 0
    elif grep -q "hyprpanel" "$CONFIG_FILE" && [ "$PANEL_CHOICE" = "hyprpanel" ]; then
        print_warning "Keybinds already set for hyprpanel"
        return 0
    fi
    
    if [ "$PANEL_CHOICE" = "waybar" ]; then
        # Replace hyprpanel with waybar
        sed -i 's/hyprpanel/waybar/g' "$CONFIG_FILE"
        # Also update specific script paths that might reference hyprpanel
        sed -i 's/kill_hyprpanel_safe\.sh/kill_waybar_safe.sh/g' "$CONFIG_FILE"
        sed -i 's/restart_hyprpanel\.sh/restart_waybar.sh/g' "$CONFIG_FILE"
        echo -e "${GREEN}Updated keybinds for waybar${NC}"
    else
        # Replace waybar with hyprpanel
        sed -i 's/waybar/hyprpanel/g' "$CONFIG_FILE"
        # Also update specific script paths that might reference waybar
        sed -i 's/kill_waybar_safe\.sh/kill_hyprpanel_safe.sh/g' "$CONFIG_FILE"
        sed -i 's/restart_waybar\.sh/restart_hyprpanel.sh/g' "$CONFIG_FILE"
        echo -e "${GREEN}Updated keybinds for hyprpanel${NC}"
    fi
}

update_custom() {
    local CUSTOM_CONFIG_FILE="$HOME/.config/hypr/hyprviz.conf"
    
    # Check if custom config file exists
    if [ ! -f "$CUSTOM_CONFIG_FILE" ]; then
        print_error "Custom config file not found: $CUSTOM_CONFIG_FILE"
        return 1
    fi
    
    # Optional: Create backup (uncomment if needed)
    # cp "$CUSTOM_CONFIG_FILE" "${CUSTOM_CONFIG_FILE}.backup.$(date +%Y%m%d_%H%M%S)"
    # echo -e "${GREEN}Custom config backup created${NC}"
    
    if [ "$PANEL_CHOICE" = "waybar" ]; then
        # Replace bar-0 with waybar in layer rules
        sed -i '18s/exec-once = systemctl --user start hyprpanel/exec-once = waybar \&/g' "$CUSTOM_CONFIG_FILE"
        sed -i '22s/exec-once = systemctl --user start hyprpanel-idle-monitor/exec-once = systemctl --user start waybar-idle-monitor/g' "$CUSTOM_CONFIG_FILE"
        
        # Handle swaync line - uncomment if commented, or ensure it's uncommented
        if grep -q "^#.*exec-once = swaync &" "$CUSTOM_CONFIG_FILE"; then
            # Line is commented, uncomment it
            sed -i 's/^#\+\s*exec-once = swaync &/exec-once = swaync \&/g' "$CUSTOM_CONFIG_FILE"
        elif ! grep -q "^exec-once = swaync &" "$CUSTOM_CONFIG_FILE"; then
            # Line doesn't exist at all, add it (optional - you might want to handle this case)
            echo "exec-once = swaync &" >> "$CUSTOM_CONFIG_FILE"
        fi
        
        # Handle swww-daemon line - uncomment if commented
        if grep -q "^#.*exec-once = swww-daemon &" "$CUSTOM_CONFIG_FILE"; then
            # Line is commented, uncomment it
            sed -i 's/^#\+\s*exec-once = swww-daemon &/exec-once = swww-daemon \&/g' "$CUSTOM_CONFIG_FILE"
        elif ! grep -q "^exec-once = swww-daemon &" "$CUSTOM_CONFIG_FILE"; then
            # Line doesn't exist at all, add it (optional - you might want to handle this case)
            echo "exec-once = swww-daemon &" >> "$CUSTOM_CONFIG_FILE"
        fi
        sed -i 's/#exec-once = systemctl --user start waypaper-watcher/exec-once = systemctl --user start waypaper-watcher/g' "$CUSTOM_CONFIG_FILE"
        sed -i 's/layerrule = blur,bar-0/layerrule = blur,waybar/g' "$CUSTOM_CONFIG_FILE"
        sed -i 's/layerrule = ignorezero,bar-0/layerrule = ignorezero,waybar/g' "$CUSTOM_CONFIG_FILE"
        echo -e "${GREEN}Updated custom config layer rules for waybar${NC}"
    else
        # Replace bar-0 with hyprpanel in layer rules
        sed -i '18s/exec-once = waybar \&/exec-once = systemctl --user start hyprpanel/g' "$CUSTOM_CONFIG_FILE"
        sed -i '22s/exec-once = systemctl --user start waybar-idle-monitor/exec-once = systemctl --user start hyprpanel-idle-monitor/g' "$CUSTOM_CONFIG_FILE"
        
        # Handle swaync line - comment if uncommented
        if grep -q "^exec-once = swaync &" "$CUSTOM_CONFIG_FILE"; then
            # Line is uncommented, comment it
            sed -i 's/^exec-once = swaync &#exec-once = swaync \&/g' "$CUSTOM_CONFIG_FILE"
        fi
        
        # Handle swww-daemon line - comment if uncommented
        if grep -q "^exec-once = swww-daemon &" "$CUSTOM_CONFIG_FILE"; then
            # Line is uncommented, comment it
            sed -i 's/^exec-once = swww-daemon &#exec-once = swww-daemon \&/g' "$CUSTOM_CONFIG_FILE"
        fi
        
        sed -i 's/exec-once = swww-daemon &/#exec-once = swww-daemon \&/g' "$CUSTOM_CONFIG_FILE"
        sed -i 's/exec-once = systemctl --user start waypaper-watcher/#exec-once = systemctl --user start waypaper-watcher/g' "$CUSTOM_CONFIG_FILE"
        sed -i 's/layerrule = blur,waybar/layerrule = blur,bar-0/g' "$CUSTOM_CONFIG_FILE"
        sed -i 's/layerrule = ignorezero,waybar/layerrule = ignorezero,bar-0/g' "$CUSTOM_CONFIG_FILE"
        echo -e "${GREEN}Updated custom config layer rules for hyprpanel${NC}"
    fi
}

setup_gjs() {
# Create the GJS directory and files if they don't already exist
if [ ! -d "$HOME/.hyprcandy/GJS/src" ]; then
    mkdir -p "$HOME/.hyprcandy/GJS/src"
    echo "📁 Created the GJS directory"
fi

cd "$HOME/.hyprcandy/GJS"
rm -f toggle-control-center.sh toggle-media-player.sh toggle-system-monitor.sh toggle-weather-widget.sh
cd "$HOME"

cat > "$HOME/.hyprcandy/GJS/toggle-control-center.sh" << 'EOF'
#!/bin/bash

# Toggle Candy Utils - Fast launch (daemon stays running)
# No killing - daemon persists for instant widget launches

PID_FILE="$HOME/.cache/hyprcandy/pids/candy-daemon.pid"
DAEMON_SCRIPT="$HOME/.hyprcandy/GJS/candy-daemon.js"
TOGGLE_DIR="$HOME/.cache/hyprcandy/toggle"

mkdir -p "$TOGGLE_DIR"

# Start daemon if not running (0.3s sleep for faster launch)
if ! [ -f "$PID_FILE" ] || ! kill -0 "$(cat "$PID_FILE" 2>/dev/null)" 2>/dev/null; then
    gjs "$DAEMON_SCRIPT" &
    sleep 0.3
fi

# Toggle widget
touch "$TOGGLE_DIR/toggle-utils"
EOF
chmod +x "$HOME/.hyprcandy/GJS/toggle-control-center.sh"

cat > "$HOME/.hyprcandy/GJS/toggle-system-monitor.sh" << 'EOF'
#!/bin/bash

# Toggle System Monitor - Fast launch (daemon stays running)

PID_FILE="$HOME/.cache/hyprcandy/pids/candy-daemon.pid"
DAEMON_SCRIPT="$HOME/.hyprcandy/GJS/candy-daemon.js"
TOGGLE_DIR="$HOME/.cache/hyprcandy/toggle"

mkdir -p "$TOGGLE_DIR"

if ! [ -f "$PID_FILE" ] || ! kill -0 "$(cat "$PID_FILE" 2>/dev/null)" 2>/dev/null; then
    gjs "$DAEMON_SCRIPT" &
    sleep 0.3
fi

touch "$TOGGLE_DIR/toggle-system"
EOF
chmod +x "$HOME/.hyprcandy/GJS/toggle-system-monitor.sh"

cat > "$HOME/.hyprcandy/GJS/toggle-media-player.sh" << 'EOF'
#!/bin/bash

# Toggle Media Player - Fast launch (daemon stays running)

PID_FILE="$HOME/.cache/hyprcandy/pids/candy-daemon.pid"
DAEMON_SCRIPT="$HOME/.hyprcandy/GJS/candy-daemon.js"
TOGGLE_DIR="$HOME/.cache/hyprcandy/toggle"

mkdir -p "$TOGGLE_DIR"

if ! [ -f "$PID_FILE" ] || ! kill -0 "$(cat "$PID_FILE" 2>/dev/null)" 2>/dev/null; then
    gjs "$DAEMON_SCRIPT" &
    sleep 0.3
fi

touch "$TOGGLE_DIR/toggle-media"
EOF
chmod +x "$HOME/.hyprcandy/GJS/toggle-media-player.sh"

cat > "$HOME/.hyprcandy/GJS/toggle-weather-widget.sh" << 'EOF'
#!/bin/bash

# Toggle Weather Widget - Fast launch (daemon stays running)

PID_FILE="$HOME/.cache/hyprcandy/pids/candy-daemon.pid"
DAEMON_SCRIPT="$HOME/.hyprcandy/GJS/candy-daemon.js"
TOGGLE_DIR="$HOME/.cache/hyprcandy/toggle"

mkdir -p "$TOGGLE_DIR"

if ! [ -f "$PID_FILE" ] || ! kill -0 "$(cat "$PID_FILE" 2>/dev/null)" 2>/dev/null; then
    gjs "$DAEMON_SCRIPT" &
    sleep 0.3
fi

touch "$TOGGLE_DIR/toggle-weather"
EOF
chmod +x "$HOME/.hyprcandy/GJS/toggle-weather-widget.sh"

find "$HOME/.hyprcandy/GJS" -name "*.sh" -exec chmod +x {} \;
chmod +x "$HOME/.hyprcandy/GJS/candy-daemon.js"

echo "✅ Files and Apps setup complete"
}

# Function to setup keyboard layout
setup_keyboard_layout() {
    # Keyboard layout selection
    echo
    print_status "Keyboard Layout Configuration"
    echo "Select your keyboard layout (this will be applied to Hyprland):"
    echo "1) us - United States (default)"
    echo "2) gb - United Kingdom"
    echo "3) de - Germany"
    echo "4) fr - France"
    echo "5) es - Spain"
    echo "6) it - Italy"
    echo "7) cn - China"
    echo "8) ru - Russia"
    echo "9) jp - Japan"
    echo "10) kr - South Korea"
    echo "11) ar - Arabic"
    echo "12) il - Israel"
    echo "13) in - India"
    echo "14) tr - Turkey"
    echo "15) uz - Uzbekistan"
    echo "16) br - Brazil"
    echo "17) no - Norway"
    echo "18) pl - Poland"
    echo "19) nl - Netherlands"
    echo "20) se - Sweden"
    echo "21) fi - Finland"
    echo "22) custom - Enter your own layout code"
    echo
    echo -e "${CYAN}Note: For other countries not listed above, use option 22 (custom)${NC}"
    echo -e "${CYAN}Common examples: 'dvorak', 'colemak', 'ca' (Canada), 'au' (Australia), etc.${NC}"
    echo
    
    KEYBOARD_LAYOUT="us"  # Default layout
    
    while true; do
        echo -e "${YELLOW}Enter your choice (1-22, or press Enter for default 'us'):${NC}"
        read -r layout_choice
        
        # If empty input, use default
        if [ -z "$layout_choice" ]; then
            layout_choice=1
        fi
        
        case $layout_choice in
            1)
                KEYBOARD_LAYOUT="us"
                print_status "Selected: United States (us)"
                break
                ;;
            2)
                KEYBOARD_LAYOUT="gb"
                print_status "Selected: United Kingdom (gb)"
                break
                ;;
            3)
                KEYBOARD_LAYOUT="de"
                print_status "Selected: Germany (de)"
                break
                ;;
            4)
                KEYBOARD_LAYOUT="fr"
                print_status "Selected: France (fr)"
                break
                ;;
            5)
                KEYBOARD_LAYOUT="es"
                print_status "Selected: Spain (es)"
                break
                ;;
            6)
                KEYBOARD_LAYOUT="it"
                print_status "Selected: Italy (it)"
                break
                ;;
            7)
                KEYBOARD_LAYOUT="cn"
                print_status "Selected: China (cn)"
                break
                ;;
            8)
                KEYBOARD_LAYOUT="ru"
                print_status "Selected: Russia (ru)"
                break
                ;;
            9)
                KEYBOARD_LAYOUT="jp"
                print_status "Selected: Japan (jp)"
                break
                ;;
            10)
                KEYBOARD_LAYOUT="kr"
                print_status "Selected: South Korea (kr)"
                break
                ;;
            11)
                KEYBOARD_LAYOUT="ar"
                print_status "Selected: Arabic (ar)"
                break
                ;;
            12)
                KEYBOARD_LAYOUT="il"
                print_status "Selected: Israel (il)"
                break
                ;;
            13)
                KEYBOARD_LAYOUT="in"
                print_status "Selected: India (in)"
                break
                ;;
            14)
                KEYBOARD_LAYOUT="tr"
                print_status "Selected: Turkey (tr)"
                break
                ;;
            15)
                KEYBOARD_LAYOUT="uz"
                print_status "Selected: Uzbekistan (uz)"
                break
                ;;
            16)
                KEYBOARD_LAYOUT="br"
                print_status "Selected: Brazil (br)"
                break
                ;;
            17)
                KEYBOARD_LAYOUT="no"
                print_status "Selected: Norway (no)"
                break
                ;;
            18)
                KEYBOARD_LAYOUT="pl"
                print_status "Selected: Poland (pl)"
                break
                ;;
            19)
                KEYBOARD_LAYOUT="nl"
                print_status "Selected: Netherlands (nl)"
                break
                ;;
            20)
                KEYBOARD_LAYOUT="se"
                print_status "Selected: Sweden (se)"
                break
                ;;
            21)
                KEYBOARD_LAYOUT="fi"
                print_status "Selected: Finland (fi)"
                break
                ;;
            22)
                echo -e "${YELLOW}Enter your custom keyboard layout code (e.g., 'dvorak', 'colemak', 'ca', 'au'):${NC}"
                read -r custom_layout
                if [ -n "$custom_layout" ]; then
                    KEYBOARD_LAYOUT="$custom_layout"
                    print_status "Selected: Custom layout ($custom_layout)"
                    break
                else
                    print_error "Custom layout cannot be empty. Please try again."
                fi
                ;;
            *)
                print_error "Invalid choice. Please enter a number between 1-22."
                ;;
        esac
    done
    
        # Apply the keyboard layout to the custom.conf file
    CUSTOM_CONFIG_FILE="$HOME/.config/hypr/hyprviz.conf"
    
    if [ -f "$CUSTOM_CONFIG_FILE" ]; then
        sed -i "s/\$LAYOUT/$KEYBOARD_LAYOUT/g" "$CUSTOM_CONFIG_FILE"
        print_status "Keyboard layout '$KEYBOARD_LAYOUT' has been applied to custom.conf"
    else
        print_error "Custom config file not found at $CUSTOM_CONFIG_FILE"
        print_error "Please run setup_custom_config() first"
    fi

hyprctl reload

pgrep -x swww-daemon > /dev/null 2>&1 || swww-daemon &
sleep 1
swww img "$HOME/.hyprcandy/.config/background"

# Start the correct services

echo "🔄 Setting up services..."
systemctl --user daemon-reload

if [ "$PANEL_CHOICE" = "waybar" ]; then
    systemctl --user restart waybar.service waybar-idle-monitor.service waypaper-watcher.service background-watcher.service hyprlock-watcher.service rofi-font-watcher.service cursor-theme-watcher.service &>/dev/null
else
    systemctl --user restart hyprpanel.service hyprpanel-idle-monitor.service background-watcher.service rofi-font-watcher.service cursor-theme-watcher.service &>/dev/null
fi

systemctl enable --now bluetooth
echo "✅ Services set..."

    # 🔄 Reload Hyprland
    echo
    echo "🔄 Reloading Hyprland with 'hyprctl reload'..."
    if command -v hyprctl > /dev/null 2>&1; then
        if pgrep -x "Hyprland" > /dev/null; then
            hyprctl reload && echo "✅ Hyprland reloaded successfully." || echo "❌ Failed to reload Hyprland."
        else
            echo "ℹ️  Hyprland is not currently running. Configuration will be applied on next start and Hyprland login."
        fi
    else
        echo "⚠️  'hyprctl' not found. Skipping Hyprland reload. Run 'hyprctl reload' on next start and Hyprland login."
    fi

    print_success "HyprCandy configuration setup completed!"  
}

# Function to prompt for reboot
prompt_reboot() {
    echo
    print_success "Installation and configuration completed!"
    print_status "All packages have been installed and Hyprcandy configurations have been deployed."
    print_status "The $DISPLAY_MANAGER display manager has been enabled."
    echo
    print_warning "Reboot is recommended on new installs to ensure all changes take effect properly."
    echo
    echo -e "${YELLOW}Would you like to reboot now? (n/Y)${NC}"
    read -r reboot_choice
    case "$reboot_choice" in
        [nN][oO]|[nN])
            echo "✅ Starting chosen bar (reboot post install is advised)..."
            sleep 5
            if [ "$PANEL_CHOICE" = "waybar" ]; then
                qs -c overview >/dev/null 2>&1 &
                sleep 0.5
                rm -rf "$HOME/hyprcandyinstall" && systemctl --user restart waybar.service &>/dev/null
            else
                qs -c overview >/dev/null 2>&1 &
                sleep 0.5
                rm -rf "$HOME/hyprcandyinstall" && systemctl --user restart hyprpanel.service &>/dev/null
            fi
            ;;
        *)
            print_status "Restarting system..."
            sleep 2
            rm -rf "$HOME/hyprcandyinstall" && reboot
            ;;
    esac
}

# Main execution
main() {
    # Show multicolored ASCII art
    show_ascii_art
    
    print_status "This installer will set up a complete Hyprland environment with:"
    echo "  • Hyprland window manager and ecosystem"
    echo "  • Essential applications and utilities"
    echo "  • Pre-configured HyprCandy dotfiles"
    echo "  • Dynamically colored Hyprland environment"
    echo "  • Your choice of display manager (SDDM or GDM)"
    echo "  • Your choice of shell (Fish or Zsh) with comprehensive configuration"
    echo
    
    # Choose display manager first
    choose_display_manager
    echo
    
    # Choose a panel
    #choose_panel
    #echo

    # Choose a browser
    choose_browser
    echo
    
    # Choose shell
    choose_shell
    echo
    
    # Check for AUR helper or install one
    check_or_install_aur_helper
    
    echo
    print_status "Using $AUR_HELPER as AUR helper"
    
    # Build package list based on display manager and shell choice
    build_package_list
    
    # Ask for confirmation
    echo -e "${YELLOW}This will install ${#packages[@]} packages and setup HyprCandy configuration. Continue? (n/Y)${NC}"
    read -r response
    case "$response" in
        [nN][oO]|[nN])
            print_status "Installation cancelled."
            exit 0
            ;;
        *)
            install_packages
            ;;
    esac
    
    echo
    print_status "Package installation completed!"

     # Setup shell configuration
    echo
    print_status "Setting up shell configuration..."
    if [ "$SHELL_CHOICE" = "fish" ]; then
        setup_fish
    elif [ "$SHELL_CHOICE" = "zsh" ]; then
        setup_zsh
    fi
    
    # Automatically setup HyprCandy configuration
    print_status "Proceeding with HyprCandy configuration setup..."
    setup_hyprcandy
    
    # Enable display manager
    enable_display_manager

    # Setup default "custom.conf" file
    setup_custom_config

    # Update keybinds based on choice
    update_keybinds
    
    # Update custom config based on choice
    update_custom

    # Setup GJS
    setup_gjs

    # Setup keyboard layout
    setup_keyboard_layout
    
    # Configuration management tips
    echo
    print_status "Configuration management tips:"
    print_status "• Your HyprCandy configs are in: ~/.hyprcandy/"
    print_status "• Minor updates: cd ~/.hyprcandy && git pull && stow */"
    print_status "• Major updates: rerun the install script for updated apps and configs"
    print_status "• To remove a config: cd ~/.hyprcandy && stow -D <config_name> -t $HOME"
    print_status "• To reinstall a config: cd ~/.hyprcandy && stow -R <config_name> -t $HOME"
    
    # Display and wallpaper configuration notes
    echo
    echo -e "${CYAN}════════════════════════════════════════════════════════════════════════════════════════════════════════════${NC}"
    echo -e "${WHITE}                              🖥️  Post-Installation Configuration  🖼️${NC}"
    echo -e "${CYAN}════════════════════════════════════════════════════════════════════════════════════════════════════════════${NC}"
    echo
    print_status "After rebooting, you may want to configure the following:"
    echo
    echo -e "${PURPLE}📱 Display Configuration:${NC}"
    print_status "• Use ${YELLOW}nwg-displays${NC} to configure monitor scaling, resolution, and positioning"
    print_status "• Launch it from the application menu or run: ${CYAN}nwg-displays${NC}"
    print_status "• Adjust scaling for HiDPI displays if needed"
    echo
    echo -e "${PURPLE}🐚 Zsh Configuration:${NC}"
    print_status "• IMPORTANT: If you chose Zsh-shell then use ${CYAN}SUPER + Q${NC} to toggle Kitty and go through the Zsh setup"
    print_status "• IMPORTANT: (Remember to type ${YELLOW}n${NC}o at the end when asked to Apply changes to .zshrc since HyprCandy already has them applied)"
    print_status "• To configure Zsh, in the ${CYAN}Home${NC} directory edit ${CYAN}.hyprcandy-zsh.zsh${NC} or ${CYAN}.zshrc${NC}"
    print_status "• You can also rerun the script to switch from either one or regenerate HyprCandy's default Zsh shell setup"
    print_status "• You can also rerun the script to install Fish shell"
    print_status "• When both are installed switch at anytime by running ${CYAN}chsh -s /usr/bin/<name of shell>${NC} then reboot"
    echo
    echo -e "${PURPLE}🖼️ Wallpaper Setup (Hyprpanel):${NC}"
    print_status "• Through Hyprpanel's configuration interface in the ${CYAN}Theming${NC} section do the following:"
    print_status "• Under ${YELLOW}General Settings${NC} choose a wallpaper to apply where it says None"
    print_status "• Find default wallpapers check the ${CYAN}~/Pictures/Candy${NC} or ${CYAN}Candy${NC} folder"
    print_status "• Under ${YELLOW}Matugen Settings${NC} toggle the button to enable matugen color application"
    print_status "• If the wallpaper doesn't apply through the configuration interface, then toggle the button to apply wallpapers"
    print_status "• Ths will quickly reset swww and apply the background"
    print_status "• Remember to reload the dock with ${CYAN}SHIFT + K${NC} to update its colors"
    echo
    echo -e "${PURPLE}🎨 Font, Icon And Cursor Theming:${NC}"
    print_status "• Open the application-finder with SUPER + A and search for ${YELLOW}GTK Settings${NC} application"
    print_status "• Prefered font to set through nwg-look is ${CYAN}JetBrainsMono Nerd Font Propo Regular${NC} at size ${CYAN}10${NC}"
    print_status "• Use ${YELLOW}nwg-look${NC} to configure the system-font, tela-icons and cursor themes"
    print_status "• Cursor themes take effect after loging out and back in"
    echo
    echo -e "${PURPLE}🐟 Fish Configuration:${NC}"
    print_status "• To configure Fish edit, in the ${YELLOW}~/.config/fish${NC} directory edit the ${YELLOW}config.fish${NC} file"
    print_status "• You can also rerun the script to switch from either one or regenerate HyprCandy's default Fish shell setup"
    print_status "• You can also rerun the script to install Zsh shell"
    print_status "• When both are installed switch by running ${CYAN}chsh -s /usr/bin/<name of shell>${NC} then reboot"
    echo
    echo -e "${PURPLE}🔎 Browser Color Theming:${NC}"
    print_status "• If you chose Brave, go to ${YELLOW}Appearance${NC} in Settings and set the 'Theme' to ${CYAN}GTK${NC} and Brave colors to Same as Linux"
    print_status "• If you chose Firefox, install the ${YELLOW}pywalfox${NC} extension and run ${YELLOW}pywalfox update${NC} in kitty"
    print_status "• If you chose Zen Browser, for slight additional theming install the ${YELLOW}pywalfox${NC} extension and run ${YELLOW}pywalfox update${NC}"
    print_status "• If you chose Librewolf, you know what you're doing"
    echo
    echo -e "${PURPLE}🏠 Clean Home Directory:${NC}"
    print_status "• You can delete any stowed symlinks made in the 'Home' directory"
    echo
    echo -e "${CYAN}════════════════════════════════════════════════════════════════════════════════════════════════════════════${NC}"
    
    # Prompt for reboot
    prompt_reboot
}

# Run main function
main "$@"
