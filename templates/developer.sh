#!/bin/bash
#
# Ubuntu Welcome Template: Developer
# Author: SteffMet
# Description: A developer-focused welcome screen with git status, todo list, and coding tips
#

template_developer() {
    clear
    
    # Developer-style header
    echo -e "\033[38;5;39m"  # Bright blue
    cat << 'EOF'
    ╔══════════════════════════════════════════════════════════════════════════╗
    ║  ____                 _                          ____            _      ║
    ║ |  _ \  _____   _____| | ___  _ __   ___ _ __    |  _ \  ___  ___| | __  ║
    ║ | | | |/ _ \ \ / / _ \ |/ _ \| '_ \ / _ \ '__|   | | | |/ _ \/ __| |/ /  ║
    ║ | |_| |  __/\ V /  __/ | (_) | |_) |  __/ |      | |_| |  __/\__ \   <   ║
    ║ |____/ \___| \_/ \___|_|\___/| .__/ \___|_|      |____/ \___||___/_|\_\  ║
    ║                             |_|                                        ║
    ╚══════════════════════════════════════════════════════════════════════════╝
EOF
    echo -e "\033[0m"
    echo
    
    # Welcome message
    echo -e "\033[1;37m┌─ Welcome Back, \033[38;5;39m$USER_NAME\033[1;37m! ─┐\033[0m"
    echo -e "\033[37m│ Ready to code? Let's build something amazing! │\033[0m"
    echo -e "\033[1;37m└─ $(date +'%A, %d %B %Y at %H:%M') ─┘\033[0m"
    echo
    
    if [[ -n "$CUSTOM_MESSAGE" ]]; then
        echo -e "\033[38;5;214m💬 $CUSTOM_MESSAGE\033[0m"
        echo
    fi
    
    # Quick system info for developers
    if [[ "$SHOW_SYSTEM_INFO" == "true" ]]; then
        echo -e "\033[38;5;39m╭─ System Status ─────────────────────────────────────────────────────────╮\033[0m"
        echo -e "\033[37m│ 🖥️  Host: \033[1;37m$HOSTNAME\033[37m │ ⏱️  Uptime: \033[1;37m$UPTIME\033[37m │\033[0m"
        echo -e "\033[37m│ 💾 Memory: \033[1;37m$MEMORY_INFO\033[37m │\033[0m"
        echo -e "\033[37m│ 💿 Disk: \033[1;37m$DISK_INFO\033[37m │\033[0m"
        echo -e "\033[37m│ 🌐 IP: \033[1;37m$LOCAL_IP\033[37m │ 📊 Load: \033[1;37m$LOAD_AVG\033[37m │\033[0m"
        echo -e "\033[38;5;39m╰─────────────────────────────────────────────────────────────────────────╯\033[0m"
        echo
    fi
    
    # Git status if in a git repository
    if [[ -d ".git" ]] || git rev-parse --git-dir > /dev/null 2>&1; then
        echo -e "\033[38;5;39m╭─ Git Repository Status ────────────────────────────────────────────────╮\033[0m"
        
        local git_branch=$(git branch --show-current 2>/dev/null || echo "unknown")
        local git_status=$(git status --porcelain 2>/dev/null | wc -l)
        local git_commits=$(git log --oneline -n 5 2>/dev/null | wc -l)
        
        echo -e "\033[37m│ 🌿 Branch: \033[1;32m$git_branch\033[0m"
        
        if [[ "$git_status" -gt 0 ]]; then
            echo -e "\033[37m│ 📝 Changes: \033[1;33m$git_status uncommitted change(s)\033[0m"
        else
            echo -e "\033[37m│ ✅ Status: \033[1;32mClean working directory\033[0m"
        fi
        
        echo -e "\033[37m│ 📈 Recent commits: \033[1;37m$git_commits\033[0m"
        echo -e "\033[38;5;39m╰─────────────────────────────────────────────────────────────────────────╯\033[0m"
        echo
    fi
    
    # Development shortcuts
    echo -e "\033[38;5;39m╭─ Developer Shortcuts ──────────────────────────────────────────────────╮\033[0m"
    echo -e "\033[37m│ 📁 List projects:        \033[1;37mls ~/\033[0m"
    echo -e "\033[37m│ 🔧 Edit welcome config:  \033[1;37mwelcome-config\033[0m"
    echo -e "\033[37m│ 🎨 Manage templates:     \033[1;37mwelcome-templates\033[0m"
    echo -e "\033[37m│ 🐳 Docker status:        \033[1;37mdocker ps\033[0m"
    echo -e "\033[37m│ 📦 Node version:         \033[1;37mnode --version\033[0m"
    echo -e "\033[37m│ 🐍 Python version:       \033[1;37mpython3 --version\033[0m"
    echo -e "\033[38;5;39m╰─────────────────────────────────────────────────────────────────────────╯\033[0m"
    echo
    
    # Random coding tip
    local coding_tips=(
        "💡 Tip: Use 'git commit -m \"message\"' for quick commits"
        "💡 Tip: 'history | grep command' helps find previously used commands"
        "💡 Tip: Use 'code .' to open current directory in VS Code"
        "💡 Tip: 'find . -name \"*.py\"' searches for Python files"
        "💡 Tip: 'grep -r \"pattern\" .' searches text in all files"
        "💡 Tip: Use 'curl -s url | jq' to pretty-print JSON APIs"
        "💡 Tip: 'watch -n 1 command' runs a command every second"
        "💡 Tip: 'ps aux | grep process' finds running processes"
    )
    
    local random_tip=${coding_tips[$RANDOM % ${#coding_tips[@]}]}
    
    echo -e "\033[38;5;214m$random_tip\033[0m"
    echo
    
    # Simple TODO reminder
    local todo_file="$HOME/.config/ubuntu-welcome-fancy/todo.txt"
    if [[ -f "$todo_file" ]] && [[ -s "$todo_file" ]]; then
        echo -e "\033[38;5;39m╭─ Your TODO List ───────────────────────────────────────────────────────╮\033[0m"
        local todo_count=$(wc -l < "$todo_file")
        echo -e "\033[37m│ 📝 You have \033[1;33m$todo_count\033[37m pending task(s)\033[0m"
        echo -e "\033[37m│ 👀 View: \033[1;37mcat ~/.config/ubuntu-welcome-fancy/todo.txt\033[0m"
        echo -e "\033[37m│ ✏️  Edit: \033[1;37mnano ~/.config/ubuntu-welcome-fancy/todo.txt\033[0m"
        echo -e "\033[38;5;39m╰─────────────────────────────────────────────────────────────────────────╯\033[0m"
        echo
    else
        echo -e "\033[38;5;39m╭─ TODO List ─────────────────────────────────────────────────────────────╮\033[0m"
        echo -e "\033[37m│ 📝 No pending tasks! Create a todo list with:\033[0m"
        echo -e "\033[37m│ 📝 \033[1;37mecho \"Your task\" >> ~/.config/ubuntu-welcome-fancy/todo.txt\033[0m"
        echo -e "\033[38;5;39m╰─────────────────────────────────────────────────────────────────────────╯\033[0m"
        echo
    fi
}

# Call the template function
template_developer
