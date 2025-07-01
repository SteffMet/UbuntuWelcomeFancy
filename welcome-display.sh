#!/bin/bash
#
# Ubuntu Fancy Welcome Screen Display Script
# Author: SteffMet
# Description: Displays the configured welcome screen with system information
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
readonly CONFIG_DIR="/etc/ubuntu-welcome-fancy"
readonly USER_CONFIG_DIR="$HOME/.config/ubuntu-welcome-fancy"
readonly TEMPLATE_DIR="/opt/ubuntu-welcome-fancy/templates"
readonly USER_TEMPLATE_DIR="$USER_CONFIG_DIR/templates"

# Load configuration
load_config() {
    local global_config="$CONFIG_DIR/config.json"
    local user_config="$USER_CONFIG_DIR/user-config.json"
    
    # Set defaults
    TEMPLATE="modern"
    USER_NAME="$USER"
    GREETING="Welcome back"
    CUSTOM_MESSAGE=""
    SHOW_SYSTEM_INFO=true
    
    # Load global config if exists
    if [[ -f "$global_config" ]] && command -v jq &> /dev/null; then
        TEMPLATE=$(jq -r '.global_settings.default_template // "modern"' "$global_config")
        SHOW_SYSTEM_INFO=$(jq -r '.global_settings.show_system_info // true' "$global_config")
    fi
    
    # Load user config if exists (overrides global)
    if [[ -f "$user_config" ]] && command -v jq &> /dev/null; then
        TEMPLATE=$(jq -r '.template // "modern"' "$user_config")
        USER_NAME=$(jq -r '.personalisation.name // env.USER' "$user_config")
        GREETING=$(jq -r '.personalisation.greeting // "Welcome back"' "$user_config")
        CUSTOM_MESSAGE=$(jq -r '.personalisation.custom_message // ""' "$user_config")
    fi
}

# Get system information
get_system_info() {
    HOSTNAME=$(hostname)
    UPTIME=$(uptime -p | sed 's/up //')
    LOAD_AVG=$(uptime | awk -F'load average:' '{print $2}' | sed 's/^ *//')
    
    # Memory information
    if command -v free &> /dev/null; then
        MEMORY_INFO=$(free -h | awk 'NR==2{printf "Used: %s/%s (%.1f%%)", $3, $2, $3*100/$2}')
    else
        MEMORY_INFO="Memory info unavailable"
    fi
    
    # Disk information
    if command -v df &> /dev/null; then
        DISK_INFO=$(df -h / | awk 'NR==2{printf "Used: %s/%s (%s)", $3, $2, $5}')
    else
        DISK_INFO="Disk info unavailable"
    fi
    
    # Network information (primary interface)
    if command -v ip &> /dev/null; then
        LOCAL_IP=$(ip route get 1.1.1.1 2>/dev/null | awk '{print $7; exit}' || echo "No network")
    else
        LOCAL_IP="IP unavailable"
    fi
    
    # Current date and time
    CURRENT_DATE=$(date "+%A, %d %B %Y")
    CURRENT_TIME=$(date "+%H:%M:%S")
    
    # Last login information
    if command -v last &> /dev/null; then
        LAST_LOGIN=$(last -n 2 "$USER" | head -n 2 | tail -n 1 | awk '{print $3, $4, $5, $6}' || echo "Unknown")
    else
        LAST_LOGIN="Last login info unavailable"
    fi
    
    # Number of logged in users
    LOGGED_USERS=$(who | wc -l)
}

# Function to create a fancy border
create_border() {
    local width=${1:-80}
    local char=${2:-"═"}
    printf "%*s\n" "$width" | tr ' ' "$char"
}

# Function to centre text
centre_text() {
    local text="$1"
    local width=${2:-80}
    local padding=$(( (width - ${#text}) / 2 ))
    printf "%*s%s%*s\n" $padding "" "$text" $padding ""
}

# Template: Modern
template_modern() {
    clear
    echo -e "${PURPLE}"
    create_border 80 "═"
    echo -e "${WHITE}"
    centre_text "Ubuntu Fancy Welcome" 80
    centre_text "$HOSTNAME" 80
    echo -e "${PURPLE}"
    create_border 80 "═"
    echo -e "${NC}\n"
    
    # Greeting section
    echo -e "${CYAN}╭─ Greetings ──────────────────────────────────────────────────────────────╮${NC}"
    echo -e "${WHITE}│  $GREETING, ${GREEN}$USER_NAME${WHITE}!$(printf "%*s" $((69 - ${#GREETING} - ${#USER_NAME})) "")│${NC}"
    echo -e "${WHITE}│  Today is $CURRENT_DATE$(printf "%*s" $((55 - ${#CURRENT_DATE})) "")│${NC}"
    echo -e "${WHITE}│  Current time: $CURRENT_TIME$(printf "%*s" $((61 - ${#CURRENT_TIME})) "")│${NC}"
    if [[ -n "$CUSTOM_MESSAGE" ]]; then
        echo -e "${YELLOW}│  $CUSTOM_MESSAGE$(printf "%*s" $((75 - ${#CUSTOM_MESSAGE})) "")│${NC}"
    fi
    echo -e "${CYAN}╰──────────────────────────────────────────────────────────────────────────╯${NC}\n"
    
    if [[ "$SHOW_SYSTEM_INFO" == "true" ]]; then
        # System information section
        echo -e "${BLUE}╭─ System Information ─────────────────────────────────────────────────────╮${NC}"
        echo -e "${WHITE}│  Hostname: ${GREEN}$HOSTNAME$(printf "%*s" $((66 - ${#HOSTNAME})) "")${WHITE}│${NC}"
        echo -e "${WHITE}│  Uptime: ${YELLOW}$UPTIME$(printf "%*s" $((68 - ${#UPTIME})) "")${WHITE}│${NC}"
        echo -e "${WHITE}│  Load Average: ${YELLOW}$LOAD_AVG$(printf "%*s" $((61 - ${#LOAD_AVG})) "")${WHITE}│${NC}"
        echo -e "${WHITE}│  Memory: ${CYAN}$MEMORY_INFO$(printf "%*s" $((68 - ${#MEMORY_INFO})) "")${WHITE}│${NC}"
        echo -e "${WHITE}│  Disk (/): ${CYAN}$DISK_INFO$(printf "%*s" $((66 - ${#DISK_INFO})) "")${WHITE}│${NC}"
        echo -e "${WHITE}│  IP Address: ${GREEN}$LOCAL_IP$(printf "%*s" $((64 - ${#LOCAL_IP})) "")${WHITE}│${NC}"
        echo -e "${WHITE}│  Logged Users: ${PURPLE}$LOGGED_USERS$(printf "%*s" $((62 - ${#LOGGED_USERS})) "")${WHITE}│${NC}"
        echo -e "${BLUE}╰──────────────────────────────────────────────────────────────────────────╯${NC}\n"
    fi
    
    # Quick tips
    echo -e "${GREEN}╭─ Quick Commands ──────────────────────────────────────────────────────────╮${NC}"
    echo -e "${WHITE}│  welcome-config     Configure your welcome screen                         │${NC}"
    echo -e "${WHITE}│  welcome-templates  Manage and switch templates                           │${NC}"
    echo -e "${WHITE}│  nano ~/.config/ubuntu-welcome-fancy/user-config.json  Edit settings      │${NC}"
    echo -e "${GREEN}╰──────────────────────────────────────────────────────────────────────────╯${NC}\n"
}

# Template: Minimal
template_minimal() {
    clear
    echo -e "${GREEN}┌─ Welcome to $HOSTNAME ─┐${NC}"
    echo -e "${WHITE}│ User: ${CYAN}$USER_NAME${NC}"
    echo -e "${WHITE}│ Time: ${YELLOW}$CURRENT_TIME${NC}"
    if [[ "$SHOW_SYSTEM_INFO" == "true" ]]; then
        echo -e "${WHITE}│ Uptime: ${PURPLE}$UPTIME${NC}"
        echo -e "${WHITE}│ Load: ${RED}$LOAD_AVG${NC}"
    fi
    echo -e "${GREEN}└─────────────────────┘${NC}\n"
    
    if [[ -n "$CUSTOM_MESSAGE" ]]; then
        echo -e "${YELLOW}💬 $CUSTOM_MESSAGE${NC}\n"
    fi
}

# Template: ASCII Art
template_ascii() {
    clear
    
    # Ubuntu ASCII art (if figlet is available)
    if command -v figlet &> /dev/null; then
        echo -e "${PURPLE}"
        figlet -f small "Ubuntu" 2>/dev/null || echo "UBUNTU"
        echo -e "${NC}"
    else
        echo -e "${PURPLE}  _   _ ____  _   _ _   _ _____ _   _ ${NC}"
        echo -e "${PURPLE} | | | | __ )| | | | \ | |_   _| | | |${NC}"
        echo -e "${PURPLE} | | | |  _ \| | | |  \| | | | | | | |${NC}"
        echo -e "${PURPLE} | |_| | |_) | |_| | |\  | | | | |_| |${NC}"
        echo -e "${PURPLE}  \___/|____/ \___/|_| \_| |_|  \___/ ${NC}\n"
    fi
    
    echo -e "${WHITE}Welcome back, ${GREEN}$USER_NAME${WHITE}!${NC}"
    echo -e "${GRAY}$CURRENT_DATE at $CURRENT_TIME${NC}\n"
    
    if [[ "$SHOW_SYSTEM_INFO" == "true" ]]; then
        echo -e "${CYAN}📊 System Status:${NC}"
        echo -e "   ${WHITE}Host:${NC} $HOSTNAME"
        echo -e "   ${WHITE}Uptime:${NC} $UPTIME"
        echo -e "   ${WHITE}Memory:${NC} $MEMORY_INFO"
        echo -e "   ${WHITE}Disk:${NC} $DISK_INFO"
        echo -e "   ${WHITE}IP:${NC} $LOCAL_IP\n"
    fi
    
    if [[ -n "$CUSTOM_MESSAGE" ]]; then
        echo -e "${YELLOW}✨ $CUSTOM_MESSAGE${NC}\n"
    fi
}

# Template: Cyberpunk
template_cyberpunk() {
    clear
    
    # Cyberpunk-style header
    echo -e "${PURPLE}╔═══════════════════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${PURPLE}║${RED} ██████╗██╗   ██╗██████╗ ███████╗██████╗ ██████╗ ██╗   ██╗███╗   ██╗██╗  ██╗${PURPLE} ║${NC}"
    echo -e "${PURPLE}║${RED}██╔════╝╚██╗ ██╔╝██╔══██╗██╔════╝██╔══██╗██╔══██╗██║   ██║████╗  ██║██║ ██╔╝${PURPLE} ║${NC}"
    echo -e "${PURPLE}║${RED}██║      ╚████╔╝ ██████╔╝█████╗  ██████╔╝██████╔╝██║   ██║██╔██╗ ██║█████╔╝ ${PURPLE} ║${NC}"
    echo -e "${PURPLE}║${RED}██║       ╚██╔╝  ██╔══██╗██╔══╝  ██╔══██╗██╔═══╝ ██║   ██║██║╚██╗██║██╔═██╗ ${PURPLE} ║${NC}"
    echo -e "${PURPLE}║${RED}╚██████╗   ██║   ██████╔╝███████╗██║  ██║██║     ╚██████╔╝██║ ╚████║██║  ██╗${PURPLE} ║${NC}"
    echo -e "${PURPLE}║${RED} ╚═════╝   ╚═╝   ╚═════╝ ╚══════╝╚═╝  ╚═╝╚═╝      ╚═════╝ ╚═╝  ╚═══╝╚═╝  ╚═╝${PURPLE} ║${NC}"
    echo -e "${PURPLE}╚═══════════════════════════════════════════════════════════════════════════╝${NC}\n"
    
    echo -e "${CYAN}► SYSTEM ACCESS GRANTED ◄${NC}"
    echo -e "${GREEN}► USER: ${WHITE}$USER_NAME${NC}"
    echo -e "${GREEN}► NODE: ${WHITE}$HOSTNAME${NC}"
    echo -e "${GREEN}► TIME: ${WHITE}$CURRENT_TIME${NC}\n"
    
    if [[ "$SHOW_SYSTEM_INFO" == "true" ]]; then
        echo -e "${YELLOW}► SYSTEM STATUS ◄${NC}"
        echo -e "${RED}┃${NC} UPTIME.....: ${WHITE}$UPTIME${NC}"
        echo -e "${RED}┃${NC} MEMORY.....: ${WHITE}$MEMORY_INFO${NC}"
        echo -e "${RED}┃${NC} STORAGE....: ${WHITE}$DISK_INFO${NC}"
        echo -e "${RED}┃${NC} NETWORK....: ${WHITE}$LOCAL_IP${NC}"
        echo -e "${RED}┃${NC} LOAD.......: ${WHITE}$LOAD_AVG${NC}\n"
    fi
    
    if [[ -n "$CUSTOM_MESSAGE" ]]; then
        echo -e "${PURPLE}► MESSAGE: ${WHITE}$CUSTOM_MESSAGE${NC}\n"
    fi
    
    echo -e "${RED}► WARNING: UNAUTHORISED ACCESS WILL BE PROSECUTED ◄${NC}\n"
}

# Template: Rainbow (if lolcat is available)
template_rainbow() {
    clear
    
    local content="
╔══════════════════════════════════════════════════════════════════════════╗
║                                                                          ║
║                         🌈 RAINBOW UBUNTU 🌈                            ║
║                                                                          ║
║                      Welcome back, $USER_NAME!                           ║
║                                                                          ║
╚══════════════════════════════════════════════════════════════════════════╝

📅 Date: $CURRENT_DATE
🕒 Time: $CURRENT_TIME
🖥️  Host: $HOSTNAME
⏱️  Uptime: $UPTIME"

    if command -v lolcat &> /dev/null; then
        echo "$content" | lolcat
    else
        echo -e "${PURPLE}$content${NC}"
    fi
    
    echo ""
    
    if [[ -n "$CUSTOM_MESSAGE" ]]; then
        local custom_content="✨ $CUSTOM_MESSAGE"
        if command -v lolcat &> /dev/null; then
            echo "$custom_content" | lolcat
        else
            echo -e "${YELLOW}$custom_content${NC}"
        fi
        echo ""
    fi
}

# Main function to display welcome screen
main() {
    # Don't show if running in a script or non-interactive shell
    if [[ ! -t 0 ]] || [[ -n "${WELCOME_DISABLED:-}" ]]; then
        return 0
    fi
    
    load_config
    get_system_info
    
    # Call the appropriate template function
    case "$TEMPLATE" in
        "modern"|"")
            template_modern
            ;;
        "minimal")
            template_minimal
            ;;
        "ascii")
            template_ascii
            ;;
        "cyberpunk")
            template_cyberpunk
            ;;
        "rainbow")
            template_rainbow
            ;;
        *)
            # Try to load custom template if it exists
            if [[ -f "$USER_TEMPLATE_DIR/$TEMPLATE.sh" ]]; then
                source "$USER_TEMPLATE_DIR/$TEMPLATE.sh"
            elif [[ -f "$TEMPLATE_DIR/$TEMPLATE.sh" ]]; then
                source "$TEMPLATE_DIR/$TEMPLATE.sh"
            else
                template_modern  # Fallback to modern template
            fi
            ;;
    esac
}

# Run main function
main "$@"
