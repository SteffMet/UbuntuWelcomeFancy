#!/bin/bash
#
# Ubuntu Fancy Welcome Screen Installer
# Author: SteffMet
# Description: Installs and configures beautiful custom welcome screens for Ubuntu CLI
# 
# This script creates customisable welcome screens that display when users log in
# Features:
# - Multiple beautiful templates included
# - Per-user customisation support
# - Easy configuration via settings file
# - Automatic system information display
# - Colour-coded output with ASCII art
#
# Usage: ./install-welcome.sh
#

set -euo pipefail

# Colours for output
readonly RED='\033[0;31m'
readonly GREEN='\033[0;32m'
readonly YELLOW='\033[1;33m'
readonly BLUE='\033[0;34m'
readonly PURPLE='\033[0;35m'
readonly CYAN='\033[0;36m'
readonly NC='\033[0m' # No Colour

# Configuration
readonly SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
readonly INSTALL_DIR="/opt/ubuntu-welcome-fancy"
readonly CONFIG_DIR="/etc/ubuntu-welcome-fancy"
readonly USER_CONFIG_DIR="$HOME/.config/ubuntu-welcome-fancy"

# Function to print coloured output
print_status() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

# Function to display fancy header
show_header() {
    clear
    echo -e "${PURPLE}"
    cat << 'EOF'
    ╔══════════════════════════════════════════════════════════════════╗
    ║                                                                  ║
    ║        Ubuntu Fancy Welcome Screen Installer v1.0               ║
    ║                                                                  ║
    ║        Transform your Ubuntu CLI login experience with          ║
    ║        beautiful, customisable welcome screens!                 ║
    ║                                                                  ║
    ║        Created by: SteffMet                                      ║
    ║        GitHub: https://github.com/SteffMet                      ║
    ║                                                                  ║
    ╚══════════════════════════════════════════════════════════════════╝
EOF
    echo -e "${NC}\n"
}

# Function to check if running as root
check_root() {
    if [[ $EUID -eq 0 ]]; then
        print_error "This script should not be run as root."
        print_status "Please run as a regular user. The script will use sudo when needed."
        exit 1
    fi
}

# Function to check dependencies
check_dependencies() {
    print_status "Checking dependencies..."
    
    local deps=("curl" "git" "nano" "figlet" "lolcat")
    local missing_deps=()
    
    for dep in "${deps[@]}"; do
        if ! command -v "$dep" &> /dev/null; then
            missing_deps+=("$dep")
        fi
    done
    
    if [[ ${#missing_deps[@]} -gt 0 ]]; then
        print_warning "Missing dependencies: ${missing_deps[*]}"
        print_status "Installing missing packages..."
        sudo apt update
        sudo apt install -y "${missing_deps[@]}"
    fi
    
    print_success "All dependencies satisfied!"
}

# Function to create directory structure
create_directories() {
    print_status "Creating directory structure..."
    
    # System directories (require sudo)
    sudo mkdir -p "$INSTALL_DIR"/{scripts,templates,themes}
    sudo mkdir -p "$CONFIG_DIR"
    
    # User directories
    mkdir -p "$USER_CONFIG_DIR"/{templates,themes}
    
    print_success "Directory structure created!"
}

# Function to install core scripts
install_core_scripts() {
    print_status "Installing core scripts..."
    
    # Copy welcome script to system location
    sudo cp "$SCRIPT_DIR"/welcome-display.sh "$INSTALL_DIR/scripts/"
    sudo cp "$SCRIPT_DIR"/template-manager.sh "$INSTALL_DIR/scripts/"
    sudo cp "$SCRIPT_DIR"/welcome-config.sh "$INSTALL_DIR/scripts/"
    
    # Make scripts executable
    sudo chmod +x "$INSTALL_DIR/scripts"/*.sh
    
    # Create symlinks for easy access
    sudo ln -sf "$INSTALL_DIR/scripts/welcome-config.sh" /usr/local/bin/welcome-config
    sudo ln -sf "$INSTALL_DIR/scripts/template-manager.sh" /usr/local/bin/welcome-templates
    
    print_success "Core scripts installed!"
}

# Function to install templates
install_templates() {
    print_status "Installing welcome screen templates..."
    
    # Copy templates to system location
    sudo cp -r "$SCRIPT_DIR"/templates/* "$INSTALL_DIR/templates/"
    
    # Copy default user templates
    cp -r "$SCRIPT_DIR"/templates/* "$USER_CONFIG_DIR/templates/"
    
    print_success "Templates installed!"
}

# Function to create default configuration
create_default_config() {
    print_status "Creating default configuration..."
    
    # System-wide default config
    sudo tee "$CONFIG_DIR/config.json" > /dev/null << 'EOF'
{
    "version": "1.0",
    "global_settings": {
        "enabled": true,
        "default_template": "modern",
        "show_system_info": true,
        "show_weather": false,
        "animation_speed": "normal",
        "colour_scheme": "auto"
    },
    "system_info": {
        "show_hostname": true,
        "show_uptime": true,
        "show_load": true,
        "show_memory": true,
        "show_disk": true,
        "show_network": true,
        "show_users": false
    },
    "per_user_templates": {
        "enabled": true,
        "fallback_to_global": true
    }
}
EOF

    # User-specific config
    tee "$USER_CONFIG_DIR/user-config.json" > /dev/null << EOF
{
    "user": "$USER",
    "template": "modern",
    "personalisation": {
        "name": "$USER",
        "greeting": "Welcome back",
        "custom_message": "",
        "favourite_quote": ""
    },
    "display_options": {
        "show_last_login": true,
        "show_todo": false,
        "show_calendar": false,
        "show_git_status": false
    }
}
EOF

    print_success "Configuration files created!"
}

# Function to setup bash profile integration
setup_bash_integration() {
    print_status "Setting up bash profile integration..."
    
    local bashrc_addition='
# Ubuntu Fancy Welcome Screen
if [[ $- == *i* ]] && [[ -z "$WELCOME_SHOWN" ]]; then
    export WELCOME_SHOWN=1
    if [[ -x "/opt/ubuntu-welcome-fancy/scripts/welcome-display.sh" ]]; then
        /opt/ubuntu-welcome-fancy/scripts/welcome-display.sh
    fi
fi'
    
    # Check if already added to avoid duplicates
    if ! grep -q "Ubuntu Fancy Welcome Screen" ~/.bashrc; then
        echo "$bashrc_addition" >> ~/.bashrc
        print_success "Bash profile integration added!"
    else
        print_warning "Bash profile integration already exists."
    fi
}

# Function to run initial configuration
run_initial_config() {
    print_status "Running initial configuration..."
    
    echo -e "${CYAN}Let's set up your welcome screen preferences!${NC}\n"
    
    # Ask for template preference
    echo "Available templates:"
    ls "$INSTALL_DIR/templates" | sed 's/^/  - /'
    echo
    
    read -p "Which template would you like to use? (default: modern): " template_choice
    template_choice=${template_choice:-modern}
    
    # Update user config
    jq --arg template "$template_choice" '.template = $template' "$USER_CONFIG_DIR/user-config.json" > tmp.$$.json && mv tmp.$$.json "$USER_CONFIG_DIR/user-config.json"
    
    # Ask for personalisation
    read -p "What would you like to be called? (default: $USER): " display_name
    display_name=${display_name:-$USER}
    
    jq --arg name "$display_name" '.personalisation.name = $name' "$USER_CONFIG_DIR/user-config.json" > tmp.$$.json && mv tmp.$$.json "$USER_CONFIG_DIR/user-config.json"
    
    read -p "Enter a custom greeting message (optional): " custom_greeting
    if [[ -n "$custom_greeting" ]]; then
        jq --arg greeting "$custom_greeting" '.personalisation.custom_message = $greeting' "$USER_CONFIG_DIR/user-config.json" > tmp.$$.json && mv tmp.$$.json "$USER_CONFIG_DIR/user-config.json"
    fi
    
    print_success "Initial configuration completed!"
}

# Function to show completion message
show_completion() {
    clear
    echo -e "${GREEN}"
    cat << 'EOF'
    ╔══════════════════════════════════════════════════════════════════╗
    ║                                                                  ║
    ║                    Installation Completed!                      ║
    ║                                                                  ║
    ║  Your Ubuntu Fancy Welcome Screen is now installed and ready!   ║
    ║                                                                  ║
    ║  Available commands:                                             ║
    ║    welcome-config    - Configure your welcome screen            ║
    ║    welcome-templates - Manage templates                         ║
    ║                                                                  ║
    ║  Configuration files:                                           ║
    ║    ~/.config/ubuntu-welcome-fancy/user-config.json             ║
    ║                                                                  ║
    ║  To see your new welcome screen, log out and log back in,       ║
    ║  or run: source ~/.bashrc                                       ║
    ║                                                                  ║
    ║  Enjoy your beautiful new Ubuntu experience!                    ║
    ║                                                                  ║
    ╚══════════════════════════════════════════════════════════════════╝
EOF
    echo -e "${NC}\n"
}

# Main installation function
main() {
    show_header
    
    print_status "Starting Ubuntu Fancy Welcome Screen installation..."
    
    check_root
    check_dependencies
    create_directories
    install_core_scripts
    install_templates
    create_default_config
    setup_bash_integration
    run_initial_config
    
    show_completion
    
    print_success "Installation completed successfully!"
    print_status "Please log out and log back in to see your new welcome screen!"
}

# Run main function
main "$@"
