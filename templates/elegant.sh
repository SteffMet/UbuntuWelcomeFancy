#!/bin/bash
#
# Ubuntu Welcome Template: Elegant
# Author: SteffMet
# Description: A sophisticated, elegant welcome screen with subtle colours and typography
#

template_elegant() {
    clear
    
    # Elegant border using Unicode box drawing characters
    echo -e "\033[38;5;67m"  # Soft blue colour
    echo "    ╭──────────────────────────────────────────────────────────────────────────╮"
    echo "    │                                                                          │"
    echo -e "    │  \033[1;37m                        Welcome to Ubuntu                           \033[38;5;67m│"
    echo "    │                                                                          │"
    echo -e "    │  \033[0;37m                   A Sophisticated Computing Experience             \033[38;5;67m│"
    echo "    │                                                                          │"
    echo "    ╰──────────────────────────────────────────────────────────────────────────╯"
    echo -e "\033[0m"
    echo
    
    # Greeting section with elegant typography
    echo -e "\033[38;5;67m┌─ \033[1;37mGreetings\033[38;5;67m ────────────────────────────────────────────────────────┐\033[0m"
    echo -e "\033[38;5;67m│\033[0m"
    echo -e "\033[38;5;67m│\033[0m  Good $(date +%p | tr '[:upper:]' '[:lower:]'), \033[1;37m$USER_NAME\033[0m"
    echo -e "\033[38;5;67m│\033[0m  Today is \033[38;5;103m$CURRENT_DATE\033[0m"
    echo -e "\033[38;5;67m│\033[0m  The time is \033[38;5;103m$CURRENT_TIME\033[0m"
    
    if [[ -n "$CUSTOM_MESSAGE" ]]; then
        echo -e "\033[38;5;67m│\033[0m"
        echo -e "\033[38;5;67m│\033[0m  \033[3;38;5;180m\"$CUSTOM_MESSAGE\"\033[0m"
    fi
    
    echo -e "\033[38;5;67m│\033[0m"
    echo -e "\033[38;5;67m└────────────────────────────────────────────────────────────────────────┘\033[0m"
    echo
    
    if [[ "$SHOW_SYSTEM_INFO" == "true" ]]; then
        # System information with refined presentation
        echo -e "\033[38;5;67m┌─ \033[1;37mSystem Overview\033[38;5;67m ────────────────────────────────────────────────────┐\033[0m"
        echo -e "\033[38;5;67m│\033[0m"
        
        # Hostname with icon
        echo -e "\033[38;5;67m│\033[0m  \033[38;5;103m🖥️  Hostname\033[0m        \033[1;37m$HOSTNAME\033[0m"
        
        # Uptime with elegant formatting
        echo -e "\033[38;5;67m│\033[0m  \033[38;5;103m⏱️  System Uptime\033[0m   \033[1;37m$UPTIME\033[0m"
        
        # Load average
        echo -e "\033[38;5;67m│\033[0m  \033[38;5;103m📊 Load Average\033[0m    \033[1;37m$LOAD_AVG\033[0m"
        
        # Memory usage
        echo -e "\033[38;5;67m│\033[0m  \033[38;5;103m💾 Memory Usage\033[0m    \033[1;37m$MEMORY_INFO\033[0m"
        
        # Disk usage
        echo -e "\033[38;5;67m│\033[0m  \033[38;5;103m💿 Storage (/)\033[0m     \033[1;37m$DISK_INFO\033[0m"
        
        # Network
        echo -e "\033[38;5;67m│\033[0m  \033[38;5;103m🌐 IP Address\033[0m      \033[1;37m$LOCAL_IP\033[0m"
        
        # Active sessions
        echo -e "\033[38;5;67m│\033[0m  \033[38;5;103m👥 Active Users\033[0m    \033[1;37m$LOGGED_USERS\033[0m"
        
        echo -e "\033[38;5;67m│\033[0m"
        echo -e "\033[38;5;67m└────────────────────────────────────────────────────────────────────────┘\033[0m"
        echo
    fi
    
    # Productivity section
    echo -e "\033[38;5;67m┌─ \033[1;37mProductivity Tools\033[38;5;67m ──────────────────────────────────────────────────┐\033[0m"
    echo -e "\033[38;5;67m│\033[0m"
    echo -e "\033[38;5;67m│\033[0m  \033[38;5;103m⚙️  Configure welcome\033[0m      \033[38;5;145mwelcome-config\033[0m"
    echo -e "\033[38;5;67m│\033[0m  \033[38;5;103m🎨 Manage templates\033[0m        \033[38;5;145mwelcome-templates\033[0m"
    echo -e "\033[38;5;67m│\033[0m  \033[38;5;103m📝 Edit settings directly\033[0m   \033[38;5;145mnano ~/.config/ubuntu-welcome-fancy/user-config.json\033[0m"
    echo -e "\033[38;5;67m│\033[0m"
    echo -e "\033[38;5;67m└────────────────────────────────────────────────────────────────────────┘\033[0m"
    echo
    
    # Inspirational quote section
    local quotes=(
        "\"Simplicity is the ultimate sophistication.\" - Leonardo da Vinci"
        "\"The best way to predict the future is to create it.\" - Peter Drucker"
        "\"Innovation distinguishes between a leader and a follower.\" - Steve Jobs"
        "\"Technology is a useful servant but a dangerous master.\" - Christian Lous Lange"
        "\"The advance of technology is based on making it fit in so that you don't really even notice it.\" - Bill Gates"
    )
    
    local random_quote=${quotes[$RANDOM % ${#quotes[@]}]}
    
    echo -e "\033[38;5;67m┌─ \033[1;37mDaily Inspiration\033[38;5;67m ──────────────────────────────────────────────────────┐\033[0m"
    echo -e "\033[38;5;67m│\033[0m"
    echo -e "\033[38;5;67m│\033[0m  \033[3;38;5;180m$random_quote\033[0m"
    echo -e "\033[38;5;67m│\033[0m"
    echo -e "\033[38;5;67m└────────────────────────────────────────────────────────────────────────┘\033[0m"
    echo
}

# Call the template function
template_elegant
