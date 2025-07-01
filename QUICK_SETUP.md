# Ubuntu Fancy Welcome Screen - Quick Setup Guide

## 🚀 Quick Start (5 Minutes)

### Step 1: Download and Install
```bash
# Clone from GitHub
git clone https://github.com/SteffMet/ubuntu-welcome-fancy.git
cd ubuntu-welcome-fancy

# Make installer executable and run
chmod +x install-welcome.sh
./install-welcome.sh
```

### Step 2: Follow the Interactive Setup
The installer will:
1. Install dependencies (figlet, lolcat, jq)
2. Ask for your preferred template
3. Ask for your display name
4. Ask for custom greeting (optional)

### Step 3: Test Your Welcome Screen
```bash
# Option 1: Reload bash configuration
source ~/.bashrc

# Option 2: Test directly
welcome-config --test

# Option 3: Log out and log back in
```

## ⚡ Quick Commands

```bash
# Configure your welcome screen
welcome-config

# Change template quickly
welcome-config --template cyberpunk

# Manage templates
welcome-templates

# Preview a template
welcome-templates --preview elegant
```

## 🎨 Template Quick Reference

| Template   | Description |
|------------|-------------|
| `modern`   | Clean, professional (default) |
| `minimal`  | Simple, lightweight |
| `ascii`    | Ubuntu ASCII art |
| `cyberpunk`| Futuristic hacker style |
| `rainbow`  | Colourful (needs lolcat) |
| `retro`    | Green terminal matrix style |
| `elegant`  | Sophisticated typography |
| `developer`| Coding-focused with git status |

## 🛠️ One-Line Customisations

```bash
# Set your name
welcome-config --name "Your Name"

# Add a daily message
welcome-config --message "Ready to code today!"

# Quick template switch
welcome-config --template developer && welcome-config --test
```

## 🔧 Troubleshooting

**Welcome screen not showing?**
```bash
# Check if installed correctly
ls -la /opt/ubuntu-welcome-fancy/scripts/

# Test manually
/opt/ubuntu-welcome-fancy/scripts/welcome-display.sh

# Check bashrc integration
grep "Ubuntu Fancy Welcome" ~/.bashrc
```

**Missing colours or effects?**
```bash
# Install missing packages
sudo apt update
sudo apt install figlet lolcat
```

## 📱 Pro Tips

1. **Multiple Users**: Each user gets their own config automatically
2. **Custom Templates**: Create your own in `~/.config/ubuntu-welcome-fancy/templates/`
3. **Git Integration**: Use the `developer` template for git status
4. **TODO Lists**: Developer template supports TODO lists at `~/.config/ubuntu-welcome-fancy/todo.txt`

## 🎯 Popular Configurations

### For Developers
```bash
welcome-config --template developer --name "Dev Name" --message "Let's build something amazing!"
```

### For System Admins
```bash
welcome-config --template cyberpunk --name "Admin" --message "System monitoring active"
```

### For Minimal Setup
```bash
welcome-config --template minimal --name "User"
```

### For Fun
```bash
welcome-config --template rainbow --name "Rainbow User" --message "Have a colourful day!"
```

That's it! You now have a beautiful, customised Ubuntu welcome screen! 🎉

For more advanced features, see the full [README.md](README.md)
