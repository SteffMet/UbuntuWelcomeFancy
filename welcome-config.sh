#!/bin/bash
#
# Ubuntu Fancy Welcome Screen Configuration Manager
# Author: SteffMet
# Description: Interactive configuration tool for customising welcome screens
#

set -euo pipefail

# Colours
readonly RED='\033[0;31m'
readonly GREEN='\033[0;32m'
readonly YELLOW='\033[1;33m'
readonly BLUE='\033[0;34m'
readonly PURPLE='\033[0;35m'
readonly CYAN='\033[0;36m'
readonly WHITE='\033[1;37m'
readonly NC='\033[0m'

# Configuration paths
readonly CONFIG_DIR="/etc/ubuntu-welcome-fancy"
readonly USER_CONFIG_DIR="$HOME/.config/ubuntu-welcome-fancy"
readonly TEMPLATE_DIR="/opt/ubuntu-welcome-fancy/templates"
readonly USER_TEMPLATE_DIR="$USER_CONFIG_DIR/templates"

# Ensure user config directory exists
mkdir -p "$USER_CONFIG_DIR"

# Function to print coloured output
print_header() {
    clear
    echo -e "${PURPLE}"
    cat << 'EOF'
╔══════════════════════════════════════════════════════════════════════════╗
║                                                                          ║
║               Ubuntu Fancy Welcome Screen Configuration                  ║
║                                                                          ║
║               Customise your Ubuntu login experience!                   ║
║                                                                          ║
╚══════════════════════════════════════════════════════════════════════════╝
EOF
    echo -e "${NC}\n"
}

print_success() {
    echo -e "${GREEN}✓ $1${NC}"
}

print_error() {
    echo -e "${RED}✗ $1${NC}"
}

print_info() {
    echo -e "${CYAN}ℹ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠ $1${NC}"
}

# Function to create default user config if it doesn't exist
create_user_config() {
    local config_file="$USER_CONFIG_DIR/user-config.json"
    
    if [[ ! -f "$config_file" ]]; then
        cat > "$config_file" << EOF
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
        print_success "Created default user configuration"
    fi
}

# Function to get current config value
get_config_value() {
    local key="$1"
    local config_file="$USER_CONFIG_DIR/user-config.json"
    
    if [[ -f "$config_file" ]] && command -v jq &> /dev/null; then
        jq -r "$key // empty" "$config_file" 2>/dev/null || echo ""
    else
        echo ""
    fi
}

# Function to set config value
set_config_value() {
    local key="$1"
    local value="$2"
    local config_file="$USER_CONFIG_DIR/user-config.json"
    
    if command -v jq &> /dev/null; then
        local temp_file=$(mktemp)
        jq --arg val "$value" "$key = \$val" "$config_file" > "$temp_file" && mv "$temp_file" "$config_file"
        return $?
    else
        print_error "jq is required for configuration management"
        return 1
    fi
}

# Function to list available templates
list_templates() {
    echo -e "${CYAN}Available templates:${NC}"
    
    # Built-in templates
    echo -e "  ${GREEN}Built-in templates:${NC}"
    echo "    • modern     - Clean, professional look with system info"
    echo "    • minimal    - Simple, lightweight display"
    echo "    • ascii      - ASCII art with Ubuntu branding"
    echo "    • cyberpunk  - Futuristic, hacker-style interface"
    echo "    • rainbow    - Colourful display (requires lolcat)"
    
    # Custom templates
    if [[ -d "$USER_TEMPLATE_DIR" ]] && [[ -n "$(ls -A "$USER_TEMPLATE_DIR" 2>/dev/null)" ]]; then
        echo -e "  ${YELLOW}Custom templates:${NC}"
        for template in "$USER_TEMPLATE_DIR"/*.sh; do
            if [[ -f "$template" ]]; then
                local name=$(basename "$template" .sh)
                echo "    • $name (custom)"
            fi
        done
    fi
}

# Function to preview a template
preview_template() {
    local template="$1"
    
    print_info "Previewing template: $template"
    echo -e "${GRAY}─────────────────────────────────────────────────────────────────────────${NC}"
    
    # Temporarily set the template and show preview
    local original_template=$(get_config_value '.template')
    set_config_value '.template' "$template"
    
    # Run the welcome display script
    if [[ -x "/opt/ubuntu-welcome-fancy/scripts/welcome-display.sh" ]]; then
        WELCOME_DISABLED="" /opt/ubuntu-welcome-fancy/scripts/welcome-display.sh
    else
        print_error "Welcome display script not found"
    fi
    
    # Restore original template
    set_config_value '.template' "$original_template"
    
    echo -e "${GRAY}─────────────────────────────────────────────────────────────────────────${NC}"
}

# Function to configure template
configure_template() {
    print_header
    echo -e "${CYAN}Template Configuration${NC}\n"
    
    list_templates
    echo
    
    local current_template=$(get_config_value '.template')
    echo -e "Current template: ${GREEN}$current_template${NC}"
    echo
    
    read -p "Enter template name (or 'list' to see options again): " template_choice
    
    case "$template_choice" in
        "list")
            configure_template
            return
            ;;
        "")
            return
            ;;
        *)
            # Validate template exists
            if [[ "$template_choice" =~ ^(modern|minimal|ascii|cyberpunk|rainbow)$ ]] || \
               [[ -f "$USER_TEMPLATE_DIR/$template_choice.sh" ]] || \
               [[ -f "$TEMPLATE_DIR/$template_choice.sh" ]]; then
                
                set_config_value '.template' "$template_choice"
                print_success "Template set to: $template_choice"
                
                read -p "Would you like to preview this template? (y/N): " preview_choice
                if [[ "$preview_choice" =~ ^[Yy]$ ]]; then
                    preview_template "$template_choice"
                fi
            else
                print_error "Template '$template_choice' not found"
                read -p "Press Enter to continue..."
            fi
            ;;
    esac
}

# Function to configure personalisation
configure_personalisation() {
    print_header
    echo -e "${CYAN}Personalisation Configuration${NC}\n"
    
    local current_name=$(get_config_value '.personalisation.name')
    local current_greeting=$(get_config_value '.personalisation.greeting')
    local current_message=$(get_config_value '.personalisation.custom_message')
    
    echo -e "Current settings:"
    echo -e "  Name: ${GREEN}$current_name${NC}"
    echo -e "  Greeting: ${GREEN}$current_greeting${NC}"
    echo -e "  Custom message: ${GREEN}$current_message${NC}"
    echo
    
    # Configure display name
    read -p "Display name [$current_name]: " new_name
    if [[ -n "$new_name" ]]; then
        set_config_value '.personalisation.name' "$new_name"
        print_success "Display name updated"
    fi
    
    # Configure greeting
    read -p "Greeting message [$current_greeting]: " new_greeting
    if [[ -n "$new_greeting" ]]; then
        set_config_value '.personalisation.greeting' "$new_greeting"
        print_success "Greeting message updated"
    fi
    
    # Configure custom message
    echo "Custom message (leave empty to clear):"
    read -p "[$current_message]: " new_message
    set_config_value '.personalisation.custom_message' "$new_message"
    if [[ -n "$new_message" ]]; then
        print_success "Custom message updated"
    else
        print_success "Custom message cleared"
    fi
}

# Function to test current configuration
test_configuration() {
    print_header
    echo -e "${CYAN}Testing Current Configuration${NC}\n"
    
    print_info "Displaying your current welcome screen configuration..."
    echo
    
    if [[ -x "/opt/ubuntu-welcome-fancy/scripts/welcome-display.sh" ]]; then
        WELCOME_DISABLED="" /opt/ubuntu-welcome-fancy/scripts/welcome-display.sh
    else
        print_error "Welcome display script not found"
    fi
    
    echo
    read -p "Press Enter to return to menu..."
}

# Function to edit configuration file directly
edit_config_file() {
    local config_file="$USER_CONFIG_DIR/user-config.json"
    
    print_header
    echo -e "${CYAN}Direct Configuration File Editing${NC}\n"
    
    print_info "Opening configuration file in nano..."
    print_warning "Be careful when editing JSON - invalid syntax will break the configuration!"
    echo
    
    if [[ -f "$config_file" ]]; then
        # Create backup
        cp "$config_file" "$config_file.backup"
        print_info "Backup created: $config_file.backup"
        
        # Open in nano
        nano "$config_file"
        
        # Validate JSON after editing
        if command -v jq &> /dev/null; then
            if jq . "$config_file" >/dev/null 2>&1; then
                print_success "Configuration file is valid"
            else
                print_error "Invalid JSON detected! Restoring backup..."
                mv "$config_file.backup" "$config_file"
                read -p "Press Enter to continue..."
            fi
        else
            print_warning "Cannot validate JSON (jq not available)"
        fi
    else
        print_error "Configuration file not found"
        read -p "Press Enter to continue..."
    fi
}

# Function to reset configuration
reset_configuration() {
    print_header
    echo -e "${CYAN}Reset Configuration${NC}\n"
    
    print_warning "This will reset all your personalisation settings to defaults."
    read -p "Are you sure you want to continue? (y/N): " confirm
    
    if [[ "$confirm" =~ ^[Yy]$ ]]; then
        # Backup current config
        local config_file="$USER_CONFIG_DIR/user-config.json"
        if [[ -f "$config_file" ]]; then
            cp "$config_file" "$config_file.backup.$(date +%Y%m%d_%H%M%S)"
            print_info "Backup created"
        fi
        
        # Remove current config to trigger recreation
        rm -f "$config_file"
        create_user_config
        
        print_success "Configuration reset to defaults"
    else
        print_info "Reset cancelled"
    fi
    
    read -p "Press Enter to continue..."
}

# Function to show help
show_help() {
    print_header
    echo -e "${CYAN}Help & Information${NC}\n"
    
    echo -e "${WHITE}Configuration Files:${NC}"
    echo "  • User config: ~/.config/ubuntu-welcome-fancy/user-config.json"
    echo "  • Global config: /etc/ubuntu-welcome-fancy/config.json"
    echo
    
    echo -e "${WHITE}Templates:${NC}"
    echo "  • System templates: /opt/ubuntu-welcome-fancy/templates/"
    echo "  • User templates: ~/.config/ubuntu-welcome-fancy/templates/"
    echo
    
    echo -e "${WHITE}Available Commands:${NC}"
    echo "  • welcome-config      - This configuration tool"
    echo "  • welcome-templates   - Template management tool"
    echo
    
    echo -e "${WHITE}Manual Configuration:${NC}"
    echo "  You can edit the configuration file directly:"
    echo "  nano ~/.config/ubuntu-welcome-fancy/user-config.json"
    echo
    
    echo -e "${WHITE}Troubleshooting:${NC}"
    echo "  • If welcome screen doesn't appear, check ~/.bashrc"
    echo "  • Logout and login again to see changes"
    echo "  • Use 'source ~/.bashrc' to test without logout"
    echo
    
    read -p "Press Enter to return to menu..."
}

# Main menu
show_main_menu() {
    while true; do
        print_header
        echo -e "${WHITE}Configuration Options:${NC}\n"
        
        echo -e "  ${GREEN}1.${NC} Configure template"
        echo -e "  ${GREEN}2.${NC} Configure personalisation"
        echo -e "  ${GREEN}3.${NC} Test current configuration"
        echo -e "  ${GREEN}4.${NC} Edit configuration file directly"
        echo -e "  ${GREEN}5.${NC} Reset configuration to defaults"
        echo -e "  ${GREEN}6.${NC} Help & information"
        echo -e "  ${GREEN}q.${NC} Quit"
        echo
        
        read -p "Choose an option [1-6, q]: " choice
        
        case "$choice" in
            1) configure_template ;;
            2) configure_personalisation ;;
            3) test_configuration ;;
            4) edit_config_file ;;
            5) reset_configuration ;;
            6) show_help ;;
            q|Q) 
                echo -e "${GREEN}Goodbye!${NC}"
                exit 0
                ;;
            *)
                print_error "Invalid option. Please choose 1-6 or q."
                sleep 1
                ;;
        esac
    done
}

# Main function
main() {
    # Check if jq is available
    if ! command -v jq &> /dev/null; then
        print_error "jq is required for configuration management"
        print_info "Install with: sudo apt install jq"
        exit 1
    fi
    
    # Ensure user config exists
    create_user_config
    
    # If arguments provided, handle them
    case "${1:-}" in
        --template|-t)
            if [[ -n "${2:-}" ]]; then
                set_config_value '.template' "$2"
                print_success "Template set to: $2"
            else
                print_error "Template name required"
                exit 1
            fi
            ;;
        --name|-n)
            if [[ -n "${2:-}" ]]; then
                set_config_value '.personalisation.name' "$2"
                print_success "Display name set to: $2"
            else
                print_error "Name required"
                exit 1
            fi
            ;;
        --greeting|-g)
            if [[ -n "${2:-}" ]]; then
                set_config_value '.personalisation.greeting' "$2"
                print_success "Greeting set to: $2"
            else
                print_error "Greeting message required"
                exit 1
            fi
            ;;
        --message|-m)
            if [[ -n "${2:-}" ]]; then
                set_config_value '.personalisation.custom_message' "$2"
                print_success "Custom message set to: $2"
            else
                set_config_value '.personalisation.custom_message' ""
                print_success "Custom message cleared"
            fi
            ;;
        --test)
            test_configuration
            ;;
        --help|-h|help)
            echo "Ubuntu Fancy Welcome Screen Configuration"
            echo
            echo "Usage: $0 [OPTIONS]"
            echo
            echo "Options:"
            echo "  -t, --template NAME     Set template"
            echo "  -n, --name NAME         Set display name"
            echo "  -g, --greeting MSG      Set greeting message"
            echo "  -m, --message MSG       Set custom message (empty to clear)"
            echo "  --test                  Test current configuration"
            echo "  -h, --help              Show this help"
            echo
            echo "Interactive mode: $0 (no arguments)"
            ;;
        "")
            # No arguments - show interactive menu
            show_main_menu
            ;;
        *)
            print_error "Unknown option: $1"
            print_info "Use --help for usage information"
            exit 1
            ;;
    esac
}

# Run main function
main "$@"
