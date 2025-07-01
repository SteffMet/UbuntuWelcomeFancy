#!/bin/bash
#
# Ubuntu Welcome Template: Retro Terminal
# Author: SteffMet
# Description: A retro-styled terminal welcome screen with green monospace aesthetic
#

template_retro() {
    clear
    
    # Green on black retro style
    echo -e "\033[32m"  # Green text
    
    # ASCII art header
    cat << 'EOF'
    ╔════════════════════════════════════════════════════════════════════════════╗
    ║                                                                            ║
    ║    ██████╗ ███████╗████████╗██████╗  ██████╗     ████████╗███████╗██████╗  ║
    ║    ██╔══██╗██╔════╝╚══██╔══╝██╔══██╗██╔═══██╗    ╚══██╔══╝██╔════╝██╔══██╗ ║
    ║    ██████╔╝█████╗     ██║   ██████╔╝██║   ██║       ██║   █████╗  ██████╔╝ ║
    ║    ██╔══██╗██╔══╝     ██║   ██╔══██╗██║   ██║       ██║   ██╔══╝  ██╔══██╗ ║
    ║    ██║  ██║███████╗   ██║   ██║  ██║╚██████╔╝       ██║   ███████╗██║  ██║ ║
    ║    ╚═╝  ╚═╝╚══════╝   ╚═╝   ╚═╝  ╚═╝ ╚═════╝        ╚═╝   ╚══════╝╚═╝  ╚═╝ ║
    ║                                                                            ║
    ║                             U B U N T U   T E R M I N A L                  ║
    ║                                                                            ║
    ╚════════════════════════════════════════════════════════════════════════════╝
EOF
    
    echo -e "\033[0m"  # Reset colour
    echo
    
    # Matrix-style login sequence
    echo -e "\033[32m>>> TERMINAL ACCESS GRANTED <<<\033[0m"
    echo -e "\033[32m>>> ESTABLISHING CONNECTION...\033[0m"
    echo -e "\033[32m>>> CONNECTION ESTABLISHED\033[0m"
    echo
    
    # User information
    echo -e "\033[1;32m╭─[ USER AUTHENTICATION ]──────────────────────────────────────────────────╮\033[0m"
    echo -e "\033[32m│\033[0m  USER: \033[1;37m$USER_NAME\033[0m"
    echo -e "\033[32m│\033[0m  NODE: \033[1;37m$HOSTNAME\033[0m"
    echo -e "\033[32m│\033[0m  DATE: \033[1;37m$CURRENT_DATE\033[0m"
    echo -e "\033[32m│\033[0m  TIME: \033[1;37m$CURRENT_TIME\033[0m"
    echo -e "\033[1;32m╰───────────────────────────────────────────────────────────────────────────╯\033[0m"
    echo
    
    if [[ "$SHOW_SYSTEM_INFO" == "true" ]]; then
        echo -e "\033[1;32m╭─[ SYSTEM STATUS ]─────────────────────────────────────────────────────────╮\033[0m"
        echo -e "\033[32m│\033[0m  UPTIME........: \033[1;37m$UPTIME\033[0m"
        echo -e "\033[32m│\033[0m  LOAD..........: \033[1;37m$LOAD_AVG\033[0m"
        echo -e "\033[32m│\033[0m  MEMORY........: \033[1;37m$MEMORY_INFO\033[0m"
        echo -e "\033[32m│\033[0m  STORAGE.......: \033[1;37m$DISK_INFO\033[0m"
        echo -e "\033[32m│\033[0m  NETWORK.......: \033[1;37m$LOCAL_IP\033[0m"
        echo -e "\033[32m│\033[0m  USERS.........: \033[1;37m$LOGGED_USERS active session(s)\033[0m"
        echo -e "\033[1;32m╰───────────────────────────────────────────────────────────────────────────╯\033[0m"
        echo
    fi
    
    if [[ -n "$CUSTOM_MESSAGE" ]]; then
        echo -e "\033[1;32m╭─[ MESSAGE ]───────────────────────────────────────────────────────────────╮\033[0m"
        echo -e "\033[32m│\033[0m  \033[1;33m$CUSTOM_MESSAGE\033[0m"
        echo -e "\033[1;32m╰───────────────────────────────────────────────────────────────────────────╯\033[0m"
        echo
    fi
    
    # Blinking cursor effect
    echo -e "\033[32m>>> READY FOR COMMANDS\033[0m"
    echo -e "\033[32m>>> TYPE 'welcome-config' TO CUSTOMISE THIS SCREEN\033[0m"
    echo
}

# Call the template function
template_retro
