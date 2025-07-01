#!/bin/bash
#
# Ubuntu Fancy Welcome Screen Uninstaller
# Author: SteffMet
# Description: Removes Ubuntu Fancy Welcome Screen from the system
#

set -euo pipefail

# Colours
readonly RED='\033[0;31m'
readonly GREEN='\033[0;32m'
readonly YELLOW='\033[1;33m'
readonly BLUE='\033[0;34m'
readonly PURPLE='\033[0;35m'
readonly CYAN='\033[0;36m'
readonly NC='\033[0m'

# Configuration
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

# Function to display header
show_header() {
    clear
    echo -e "${PURPLE}"
    cat << 'EOF'
    ╔══════════════════════════════════════════════════════════════════╗
    ║                                                                  ║
    ║        Ubuntu Fancy Welcome Screen Uninstaller                  ║
    ║                                                                  ║
    ║        This will remove the welcome screen system from          ║
    ║        your Ubuntu installation.                                 ║
    ║                                                                  ║
    ║        Created by: SteffMet                                      ║
    ║                                                                  ║
    ╚══════════════════════════════════════════════════════════════════╝
EOF
    echo -e "${NC}\n"
}

# Function to confirm uninstallation
confirm_uninstall() {
    echo -e "${YELLOW}This will remove:${NC}"
    echo "  • All welcome screen scripts and templates"
    echo "  • System configuration files"
    echo "  • Bash profile integration"
    echo "  • Command-line shortcuts"
    echo
    echo -e "${CYAN}Your personal configuration will be preserved in:${NC}"
    echo "  • $USER_CONFIG_DIR"
    echo
    
    read -p "Are you sure you want to uninstall Ubuntu Fancy Welcome Screen? (y/N): " confirm
    
    if [[ ! "$confirm" =~ ^[Yy]$ ]]; then
        print_status "Uninstallation cancelled."
        exit 0
    fi
}

# Function to remove bash integration
remove_bash_integration() {
    print_status "Removing bash profile integration..."
    
    if [[ -f ~/.bashrc ]]; then
        # Create backup
        cp ~/.bashrc ~/.bashrc.backup.$(date +%Y%m%d_%H%M%S)
        print_status "Backup created: ~/.bashrc.backup.$(date +%Y%m%d_%H%M%S)"
        
        # Remove the welcome screen section
        if grep -q "Ubuntu Fancy Welcome Screen" ~/.bashrc; then
            # Remove the entire section
            sed -i '/# Ubuntu Fancy Welcome Screen/,/^fi$/d' ~/.bashrc
            print_success "Bash integration removed from ~/.bashrc"
        else
            print_warning "No bash integration found in ~/.bashrc"
        fi
    else
        print_warning "~/.bashrc not found"
    fi
}

# Function to remove system files
remove_system_files() {
    print_status "Removing system files..."
    
    # Remove command-line shortcuts
    if [[ -L /usr/local/bin/welcome-config ]]; then
        sudo rm -f /usr/local/bin/welcome-config
        print_success "Removed welcome-config command"
    fi
    
    if [[ -L /usr/local/bin/welcome-templates ]]; then
        sudo rm -f /usr/local/bin/welcome-templates
        print_success "Removed welcome-templates command"
    fi
    
    # Remove main installation directory
    if [[ -d "$INSTALL_DIR" ]]; then
        sudo rm -rf "$INSTALL_DIR"
        print_success "Removed installation directory: $INSTALL_DIR"
    fi
    
    # Remove system configuration
    if [[ -d "$CONFIG_DIR" ]]; then
        sudo rm -rf "$CONFIG_DIR"
        print_success "Removed system configuration: $CONFIG_DIR"
    fi
}

# Function to handle user configuration
handle_user_config() {
    if [[ -d "$USER_CONFIG_DIR" ]]; then
        echo
        print_warning "Your personal configuration still exists at: $USER_CONFIG_DIR"
        read -p "Would you like to remove your personal configuration as well? (y/N): " remove_user_config
        
        if [[ "$remove_user_config" =~ ^[Yy]$ ]]; then
            # Create backup first
            local backup_dir="$HOME/ubuntu-welcome-fancy-backup-$(date +%Y%m%d_%H%M%S)"
            cp -r "$USER_CONFIG_DIR" "$backup_dir"
            print_status "Backup created: $backup_dir"
            
            rm -rf "$USER_CONFIG_DIR"
            print_success "Personal configuration removed"
            print_status "Backup available at: $backup_dir"
        else
            print_status "Personal configuration preserved at: $USER_CONFIG_DIR"
            echo -e "${CYAN}You can manually remove it later with:${NC} rm -rf $USER_CONFIG_DIR"
        fi
    fi
}

# Function to show completion message
show_completion() {
    echo
    echo -e "${GREEN}"
    cat << 'EOF'
    ╔══════════════════════════════════════════════════════════════════╗
    ║                                                                  ║
    ║                    Uninstallation Completed!                    ║
    ║                                                                  ║
    ║  Ubuntu Fancy Welcome Screen has been removed from your system. ║
    ║                                                                  ║
    ║  To complete the removal, please:                               ║
    ║  1. Log out and log back in, OR                                 ║
    ║  2. Run: source ~/.bashrc                                       ║
    ║                                                                  ║
    ║  Thank you for using Ubuntu Fancy Welcome Screen!              ║
    ║                                                                  ║
    ╚══════════════════════════════════════════════════════════════════╝
EOF
    echo -e "${NC}\n"
}

# Function to check if already uninstalled
check_installation() {
    if [[ ! -d "$INSTALL_DIR" ]] && [[ ! -d "$CONFIG_DIR" ]]; then
        print_warning "Ubuntu Fancy Welcome Screen does not appear to be installed."
        
        # Check for bash integration
        if [[ -f ~/.bashrc ]] && grep -q "Ubuntu Fancy Welcome Screen" ~/.bashrc; then
            print_status "Found bash integration remnants. Cleaning up..."
            remove_bash_integration
        fi
        
        exit 0
    fi
}

# Main uninstallation function
main() {
    show_header
    
    print_status "Checking current installation..."
    check_installation
    
    confirm_uninstall
    
    print_status "Starting uninstallation process..."
    
    remove_bash_integration
    remove_system_files
    handle_user_config
    
    show_completion
    
    print_success "Uninstallation completed successfully!"
}

# Check if running as root
if [[ $EUID -eq 0 ]]; then
    print_error "This script should not be run as root."
    print_status "Please run as a regular user. The script will use sudo when needed."
    exit 1
fi

# Run main function
main "$@"
