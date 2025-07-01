#!/bin/bash
#
# Ubuntu Fancy Welcome Screen Template Manager
# Author: SteffMet
# Description: Manage and create custom welcome screen templates
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
readonly GRAY='\033[0;37m'
readonly NC='\033[0m'

# Configuration paths
readonly TEMPLATE_DIR="/opt/ubuntu-welcome-fancy/templates"
readonly USER_TEMPLATE_DIR="$HOME/.config/ubuntu-welcome-fancy/templates"

# Ensure user template directory exists
mkdir -p "$USER_TEMPLATE_DIR"

# Function to print coloured output
print_header() {
    clear
    echo -e "${PURPLE}"
    cat << 'EOF'
╔══════════════════════════════════════════════════════════════════════════╗
║                                                                          ║
║               Ubuntu Fancy Welcome Screen Template Manager              ║
║                                                                          ║
║               Create and manage custom welcome templates                 ║
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

# Function to list all available templates
list_templates() {
    print_header
    echo -e "${CYAN}Available Templates${NC}\n"
    
    echo -e "${GREEN}Built-in Templates:${NC}"
    echo "  • modern     - Clean, professional look with comprehensive system info"
    echo "  • minimal    - Simple, lightweight display with essential info"
    echo "  • ascii      - ASCII art with Ubuntu branding and system details"
    echo "  • cyberpunk  - Futuristic, hacker-style interface with neon colours"
    echo "  • rainbow    - Colourful display using lolcat (requires lolcat package)"
    echo
    
    # List custom templates
    if [[ -d "$USER_TEMPLATE_DIR" ]]; then
        local custom_templates=($(find "$USER_TEMPLATE_DIR" -name "*.sh" -type f 2>/dev/null | sort))
        if [[ ${#custom_templates[@]} -gt 0 ]]; then
            echo -e "${YELLOW}Custom Templates:${NC}"
            for template in "${custom_templates[@]}"; do
                local name=$(basename "$template" .sh)
                echo "  • $name (custom)"
            done
            echo
        fi
    fi
    
    read -p "Press Enter to continue..."
}

# Function to preview a template
preview_template() {
    local template_name="$1"
    
    print_header
    echo -e "${CYAN}Template Preview: $template_name${NC}\n"
    
    print_info "Previewing template..."
    echo -e "${GRAY}─────────────────────────────────────────────────────────────────────────${NC}"
    
    # Temporarily set the template and show preview
    if [[ -x "/opt/ubuntu-welcome-fancy/scripts/welcome-display.sh" ]]; then
        # Create temporary config for preview
        local temp_config=$(mktemp)
        cat > "$temp_config" << EOF
{
    "user": "$USER",
    "template": "$template_name",
    "personalisation": {
        "name": "$USER",
        "greeting": "Welcome back",
        "custom_message": "This is a preview of the $template_name template"
    }
}
EOF
        
        # Set environment variable to use temp config
        USER_CONFIG_DIR=$(dirname "$temp_config") /opt/ubuntu-welcome-fancy/scripts/welcome-display.sh
        rm -f "$temp_config"
    else
        print_error "Welcome display script not found"
    fi
    
    echo -e "${GRAY}─────────────────────────────────────────────────────────────────────────${NC}"
    read -p "Press Enter to continue..."
}

# Function to create a new custom template
create_template() {
    print_header
    echo -e "${CYAN}Create New Custom Template${NC}\n"
    
    read -p "Enter name for new template: " template_name
    
    if [[ -z "$template_name" ]]; then
        print_error "Template name cannot be empty"
        read -p "Press Enter to continue..."
        return
    fi
    
    # Check if template already exists
    if [[ -f "$USER_TEMPLATE_DIR/$template_name.sh" ]]; then
        print_warning "Template '$template_name' already exists"
        read -p "Overwrite? (y/N): " overwrite
        if [[ ! "$overwrite" =~ ^[Yy]$ ]]; then
            return
        fi
    fi
    
    # Template selection menu
    echo -e "\nChoose a base template to customise:"
    echo "  1. Start from scratch (blank template)"
    echo "  2. Copy from modern template"
    echo "  3. Copy from minimal template"
    echo "  4. Copy from ascii template"
    echo "  5. Copy from cyberpunk template"
    echo
    
    read -p "Choose option [1-5]: " base_choice
    
    local template_file="$USER_TEMPLATE_DIR/$template_name.sh"
    
    case "$base_choice" in
        1)
            create_blank_template "$template_file" "$template_name"
            ;;
        2)
            copy_builtin_template "modern" "$template_file" "$template_name"
            ;;
        3)
            copy_builtin_template "minimal" "$template_file" "$template_name"
            ;;
        4)
            copy_builtin_template "ascii" "$template_file" "$template_name"
            ;;
        5)
            copy_builtin_template "cyberpunk" "$template_file" "$template_name"
            ;;
        *)
            print_error "Invalid option"
            return
            ;;
    esac
    
    chmod +x "$template_file"
    print_success "Template '$template_name' created successfully!"
    
    read -p "Would you like to edit it now? (Y/n): " edit_choice
    if [[ ! "$edit_choice" =~ ^[Nn]$ ]]; then
        nano "$template_file"
        print_info "Template editing completed"
    fi
    
    read -p "Would you like to preview the new template? (Y/n): " preview_choice
    if [[ ! "$preview_choice" =~ ^[Nn]$ ]]; then
        preview_template "$template_name"
    fi
}

# Function to create a blank template
create_blank_template() {
    local template_file="$1"
    local template_name="$2"
    
    cat > "$template_file" << EOF
#!/bin/bash
#
# Custom Welcome Template: $template_name
# Created: $(date)
# Author: $USER
#

# This function will be called by the welcome display script
# You have access to all the system information variables:
# - USER_NAME, GREETING, CUSTOM_MESSAGE
# - HOSTNAME, UPTIME, LOAD_AVG, MEMORY_INFO, DISK_INFO, LOCAL_IP
# - CURRENT_DATE, CURRENT_TIME, LAST_LOGIN, LOGGED_USERS
# - SHOW_SYSTEM_INFO (boolean)

template_${template_name}() {
    clear
    
    # Your custom welcome screen code goes here
    echo -e "\${CYAN}╔══════════════════════════════════════════════════════════════════════════╗\${NC}"
    echo -e "\${CYAN}║\${NC}                                                                          \${CYAN}║\${NC}"
    echo -e "\${CYAN}║\${NC}                     Welcome to \${GREEN}\$HOSTNAME\${NC}                          \${CYAN}║\${NC}"
    echo -e "\${CYAN}║\${NC}                                                                          \${CYAN}║\${NC}"
    echo -e "\${CYAN}╚══════════════════════════════════════════════════════════════════════════╝\${NC}"
    echo
    
    echo -e "\${WHITE}Hello, \${GREEN}\$USER_NAME\${WHITE}!\${NC}"
    echo -e "\${GRAY}\$CURRENT_DATE at \$CURRENT_TIME\${NC}"
    echo
    
    if [[ "\$SHOW_SYSTEM_INFO" == "true" ]]; then
        echo -e "\${YELLOW}System Information:\${NC}"
        echo -e "  Uptime: \$UPTIME"
        echo -e "  Load: \$LOAD_AVG"
        echo -e "  Memory: \$MEMORY_INFO"
        echo
    fi
    
    if [[ -n "\$CUSTOM_MESSAGE" ]]; then
        echo -e "\${PURPLE}📝 \$CUSTOM_MESSAGE\${NC}"
        echo
    fi
    
    # Add your custom content here
    echo -e "\${CYAN}💡 Tip: Edit this template at ~/.config/ubuntu-welcome-fancy/templates/$template_name.sh\${NC}"
    echo
}

# Call the template function
template_${template_name}
EOF
}

# Function to copy from built-in template
copy_builtin_template() {
    local base_template="$1"
    local template_file="$2"
    local template_name="$3"
    
    # Extract the template function from welcome-display.sh
    local welcome_script="/opt/ubuntu-welcome-fancy/scripts/welcome-display.sh"
    
    if [[ -f "$welcome_script" ]]; then
        # Create template file with header
        cat > "$template_file" << EOF
#!/bin/bash
#
# Custom Welcome Template: $template_name
# Based on: $base_template template
# Created: $(date)
# Author: $USER
#

EOF
        
        # Extract the template function
        sed -n "/^template_${base_template}()/,/^}$/p" "$welcome_script" >> "$template_file"
        
        # Replace function name
        sed -i "s/template_${base_template}/template_${template_name}/g" "$template_file"
        
        # Add function call at the end
        echo -e "\n# Call the template function\ntemplate_${template_name}" >> "$template_file"
        
        print_info "Template based on '$base_template' created"
    else
        print_error "Base template script not found"
        create_blank_template "$template_file" "$template_name"
    fi
}

# Function to edit an existing template
edit_template() {
    print_header
    echo -e "${CYAN}Edit Custom Template${NC}\n"
    
    # List custom templates
    local custom_templates=($(find "$USER_TEMPLATE_DIR" -name "*.sh" -type f 2>/dev/null | sort))
    
    if [[ ${#custom_templates[@]} -eq 0 ]]; then
        print_warning "No custom templates found"
        read -p "Press Enter to continue..."
        return
    fi
    
    echo "Available custom templates:"
    for i in "${!custom_templates[@]}"; do
        local name=$(basename "${custom_templates[$i]}" .sh)
        echo "  $((i+1)). $name"
    done
    echo
    
    read -p "Enter template number or name: " selection
    
    local template_file=""
    if [[ "$selection" =~ ^[0-9]+$ ]] && [[ "$selection" -le "${#custom_templates[@]}" ]] && [[ "$selection" -gt 0 ]]; then
        template_file="${custom_templates[$((selection-1))]}"
    else
        # Try to find by name
        if [[ -f "$USER_TEMPLATE_DIR/$selection.sh" ]]; then
            template_file="$USER_TEMPLATE_DIR/$selection.sh"
        else
            print_error "Template not found: $selection"
            read -p "Press Enter to continue..."
            return
        fi
    fi
    
    local template_name=$(basename "$template_file" .sh)
    print_info "Editing template: $template_name"
    nano "$template_file"
    
    print_success "Template editing completed"
    
    read -p "Would you like to preview the updated template? (Y/n): " preview_choice
    if [[ ! "$preview_choice" =~ ^[Nn]$ ]]; then
        preview_template "$template_name"
    fi
}

# Function to delete a custom template
delete_template() {
    print_header
    echo -e "${CYAN}Delete Custom Template${NC}\n"
    
    # List custom templates
    local custom_templates=($(find "$USER_TEMPLATE_DIR" -name "*.sh" -type f 2>/dev/null | sort))
    
    if [[ ${#custom_templates[@]} -eq 0 ]]; then
        print_warning "No custom templates found"
        read -p "Press Enter to continue..."
        return
    fi
    
    echo "Available custom templates:"
    for i in "${!custom_templates[@]}"; do
        local name=$(basename "${custom_templates[$i]}" .sh)
        echo "  $((i+1)). $name"
    done
    echo
    
    read -p "Enter template number or name to delete: " selection
    
    local template_file=""
    if [[ "$selection" =~ ^[0-9]+$ ]] && [[ "$selection" -le "${#custom_templates[@]}" ]] && [[ "$selection" -gt 0 ]]; then
        template_file="${custom_templates[$((selection-1))]}"
    else
        # Try to find by name
        if [[ -f "$USER_TEMPLATE_DIR/$selection.sh" ]]; then
            template_file="$USER_TEMPLATE_DIR/$selection.sh"
        else
            print_error "Template not found: $selection"
            read -p "Press Enter to continue..."
            return
        fi
    fi
    
    local template_name=$(basename "$template_file" .sh)
    
    print_warning "This will permanently delete the template: $template_name"
    read -p "Are you sure? (y/N): " confirm
    
    if [[ "$confirm" =~ ^[Yy]$ ]]; then
        rm -f "$template_file"
        print_success "Template '$template_name' deleted"
    else
        print_info "Deletion cancelled"
    fi
    
    read -p "Press Enter to continue..."
}

# Function to show template development help
show_template_help() {
    print_header
    echo -e "${CYAN}Template Development Help${NC}\n"
    
    echo -e "${WHITE}Available Variables:${NC}"
    echo "  USER_NAME        - User's display name"
    echo "  GREETING         - Greeting message"
    echo "  CUSTOM_MESSAGE   - User's custom message"
    echo "  HOSTNAME         - System hostname"
    echo "  UPTIME           - System uptime"
    echo "  LOAD_AVG         - System load average"
    echo "  MEMORY_INFO      - Memory usage information"
    echo "  DISK_INFO        - Disk usage information"
    echo "  LOCAL_IP         - Local IP address"
    echo "  CURRENT_DATE     - Current date"
    echo "  CURRENT_TIME     - Current time"
    echo "  LAST_LOGIN       - Last login information"
    echo "  LOGGED_USERS     - Number of logged users"
    echo "  SHOW_SYSTEM_INFO - Boolean for showing system info"
    echo
    
    echo -e "${WHITE}Available Colours:${NC}"
    echo -e "  \${RED}RED\${NC}           \${GREEN}GREEN\${NC}         \${YELLOW}YELLOW\${NC}"
    echo -e "  \${BLUE}BLUE\${NC}          \${PURPLE}PURPLE\${NC}        \${CYAN}CYAN\${NC}"
    echo -e "  \${WHITE}WHITE\${NC}         \${GRAY}GRAY\${NC}          \${NC}NC (No Colour)\${NC}"
    echo
    
    echo -e "${WHITE}Template Structure:${NC}"
    echo "  1. Define a function named 'template_<name>()'"
    echo "  2. Use available variables and colours"
    echo "  3. Call the function at the end of the file"
    echo "  4. Make the file executable (chmod +x)"
    echo
    
    echo -e "${WHITE}Template Locations:${NC}"
    echo "  Custom templates: ~/.config/ubuntu-welcome-fancy/templates/"
    echo "  System templates: /opt/ubuntu-welcome-fancy/templates/"
    echo
    
    echo -e "${WHITE}Testing Templates:${NC}"
    echo "  Use 'welcome-config --test' to test your current configuration"
    echo "  Use the preview function in this menu"
    echo
    
    read -p "Press Enter to continue..."
}

# Function to export/import templates
export_template() {
    print_header
    echo -e "${CYAN}Export Template${NC}\n"
    
    # List custom templates
    local custom_templates=($(find "$USER_TEMPLATE_DIR" -name "*.sh" -type f 2>/dev/null | sort))
    
    if [[ ${#custom_templates[@]} -eq 0 ]]; then
        print_warning "No custom templates found"
        read -p "Press Enter to continue..."
        return
    fi
    
    echo "Available custom templates:"
    for i in "${!custom_templates[@]}"; do
        local name=$(basename "${custom_templates[$i]}" .sh)
        echo "  $((i+1)). $name"
    done
    echo
    
    read -p "Enter template number or name to export: " selection
    
    local template_file=""
    if [[ "$selection" =~ ^[0-9]+$ ]] && [[ "$selection" -le "${#custom_templates[@]}" ]] && [[ "$selection" -gt 0 ]]; then
        template_file="${custom_templates[$((selection-1))]}"
    else
        if [[ -f "$USER_TEMPLATE_DIR/$selection.sh" ]]; then
            template_file="$USER_TEMPLATE_DIR/$selection.sh"
        else
            print_error "Template not found: $selection"
            read -p "Press Enter to continue..."
            return
        fi
    fi
    
    local template_name=$(basename "$template_file" .sh)
    local export_file="$HOME/${template_name}_template.sh"
    
    cp "$template_file" "$export_file"
    print_success "Template exported to: $export_file"
    print_info "You can share this file with others or back it up"
    
    read -p "Press Enter to continue..."
}

# Main menu
show_main_menu() {
    while true; do
        print_header
        echo -e "${WHITE}Template Management Options:${NC}\n"
        
        echo -e "  ${GREEN}1.${NC} List all templates"
        echo -e "  ${GREEN}2.${NC} Preview a template"
        echo -e "  ${GREEN}3.${NC} Create new custom template"
        echo -e "  ${GREEN}4.${NC} Edit custom template"
        echo -e "  ${GREEN}5.${NC} Delete custom template"
        echo -e "  ${GREEN}6.${NC} Export template"
        echo -e "  ${GREEN}7.${NC} Template development help"
        echo -e "  ${GREEN}q.${NC} Quit"
        echo
        
        read -p "Choose an option [1-7, q]: " choice
        
        case "$choice" in
            1) list_templates ;;
            2) 
                echo
                read -p "Enter template name to preview: " template_name
                if [[ -n "$template_name" ]]; then
                    preview_template "$template_name"
                fi
                ;;
            3) create_template ;;
            4) edit_template ;;
            5) delete_template ;;
            6) export_template ;;
            7) show_template_help ;;
            q|Q) 
                echo -e "${GREEN}Goodbye!${NC}"
                exit 0
                ;;
            *)
                print_error "Invalid option. Please choose 1-7 or q."
                sleep 1
                ;;
        esac
    done
}

# Main function
main() {
    # Handle command line arguments
    case "${1:-}" in
        --list|-l)
            list_templates
            ;;
        --preview|-p)
            if [[ -n "${2:-}" ]]; then
                preview_template "$2"
            else
                print_error "Template name required for preview"
                exit 1
            fi
            ;;
        --create|-c)
            create_template
            ;;
        --help|-h|help)
            echo "Ubuntu Fancy Welcome Screen Template Manager"
            echo
            echo "Usage: $0 [OPTIONS]"
            echo
            echo "Options:"
            echo "  -l, --list              List all available templates"
            echo "  -p, --preview NAME      Preview a specific template"
            echo "  -c, --create            Create a new custom template"
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
