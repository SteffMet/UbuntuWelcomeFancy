# Ubuntu Fancy Welcome Screen

Transform your Ubuntu CLI login experience with beautiful, customisable welcome screens!

![Ubuntu Fancy Welcome](https://img.shields.io/badge/Ubuntu-Fancy%20Welcome-orange?style=for-the-badge&logo=ubuntu)
![Version](https://img.shields.io/badge/Version-1.0-blue?style=for-the-badge)
![Licence](https://img.shields.io/badge/Licence-MIT-green?style=for-the-badge)

Created by: **SteffMet** | GitHub: [SteffMet](https://github.com/SteffMet)

## 🌟 Features

- **Multiple Beautiful Templates**: Choose from modern, minimal, ASCII art, cyberpunk, rainbow, retro, elegant, and developer themes
- **Per-User Customisation**: Each user can have their own personalised welcome screen
- **System Information Display**: Show hostname, uptime, memory usage, disk space, and more
- **Easy Configuration**: Interactive configuration tools and JSON-based settings
- **Custom Templates**: Create your own welcome screen templates with full scripting support
- **Developer Features**: Git status, TODO lists, and coding shortcuts (developer template)
- **British English**: All documentation and interface text in proper British English

## 🚀 Quick Installation

```bash
# Clone the repository
git clone https://github.com/SteffMet/ubuntu-welcome-fancy.git
cd ubuntu-welcome-fancy

# Run the installer
chmod +x install-welcome.sh
./install-welcome.sh
```

The installer will:
- Check and install dependencies (figlet, lolcat, jq, etc.)
- Create necessary directories
- Install scripts and templates
- Set up bash integration
- Guide you through initial configuration

## 📋 Requirements

- Ubuntu 18.04+ (or compatible Debian-based distribution)
- Bash shell
- sudo access for installation

### Dependencies (automatically installed)
- `curl` - For potential future web features
- `git` - For repository management
- `nano` - For configuration editing
- `figlet` - For ASCII art text
- `lolcat` - For rainbow effects (optional)
- `jq` - For JSON configuration management

## 🎨 Available Templates

### Built-in Templates

1. **Modern** (default) - Clean, professional look with comprehensive system information
2. **Minimal** - Simple, lightweight display with essential information only
3. **ASCII** - Ubuntu ASCII art with system details
4. **Cyberpunk** - Futuristic, hacker-style interface with neon colours
5. **Rainbow** - Colourful display using lolcat effects
6. **Retro** - Green-on-black terminal aesthetic with matrix-style elements
7. **Elegant** - Sophisticated design with subtle colours and typography
8. **Developer** - Coding-focused with git status, shortcuts, and development tips

### Template Features

Each template can display:
- Personalised greeting with custom name
- Current date and time
- System hostname and uptime
- Memory and disk usage
- Network information
- Load averages
- Custom messages
- User-specific content

## ⚙️ Configuration

### Interactive Configuration
```bash
welcome-config
```

This opens an interactive menu where you can:
- Choose your template
- Set your display name
- Configure greeting messages
- Add custom messages
- Test your configuration

### Command-Line Configuration
```bash
# Set template
welcome-config --template modern

# Set display name
welcome-config --name "Your Name"

# Set greeting
welcome-config --greeting "Good day"

# Set custom message
welcome-config --message "Ready to code!"

# Clear custom message
welcome-config --message ""

# Test current configuration
welcome-config --test
```

### Direct File Editing
```bash
nano ~/.config/ubuntu-welcome-fancy/user-config.json
```

Example configuration:
```json
{
    "user": "steff",
    "template": "developer",
    "personalisation": {
        "name": "Steff",
        "greeting": "Welcome back",
        "custom_message": "Let's build something amazing today!",
        "favourite_quote": ""
    },
    "display_options": {
        "show_last_login": true,
        "show_todo": true,
        "show_calendar": false,
        "show_git_status": true
    }
}
```

## 🎭 Template Management

### Interactive Template Manager
```bash
welcome-templates
```

Features:
- List all available templates
- Preview templates before applying
- Create custom templates
- Edit existing custom templates
- Delete custom templates
- Export templates for sharing

### Command-Line Template Management
```bash
# List all templates
welcome-templates --list

# Preview a specific template
welcome-templates --preview cyberpunk

# Create a new template
welcome-templates --create
```

## 🛠️ Creating Custom Templates

### Template Structure

Custom templates are bash scripts that define a function and use predefined variables:

```bash
#!/bin/bash
#
# Custom Welcome Template: MyTemplate
# Author: Your Name
#

template_mytemplate() {
    clear
    
    # Your custom welcome screen code here
    echo -e "${CYAN}Welcome to $HOSTNAME${NC}"
    echo -e "${WHITE}Hello, $USER_NAME!${NC}"
    echo -e "${GRAY}$CURRENT_DATE at $CURRENT_TIME${NC}"
    
    if [[ "$SHOW_SYSTEM_INFO" == "true" ]]; then
        echo -e "${YELLOW}System Info:${NC}"
        echo -e "  Uptime: $UPTIME"
        echo -e "  Memory: $MEMORY_INFO"
    fi
    
    if [[ -n "$CUSTOM_MESSAGE" ]]; then
        echo -e "${PURPLE}$CUSTOM_MESSAGE${NC}"
    fi
}

# Call the template function
template_mytemplate
```

### Available Variables

Templates have access to these variables:
- `USER_NAME` - User's display name
- `GREETING` - Greeting message
- `CUSTOM_MESSAGE` - User's custom message
- `HOSTNAME` - System hostname
- `UPTIME` - System uptime
- `LOAD_AVG` - System load average
- `MEMORY_INFO` - Memory usage information
- `DISK_INFO` - Disk usage information
- `LOCAL_IP` - Local IP address
- `CURRENT_DATE` - Current date
- `CURRENT_TIME` - Current time
- `LAST_LOGIN` - Last login information
- `LOGGED_USERS` - Number of logged users
- `SHOW_SYSTEM_INFO` - Boolean for showing system info

### Available Colours

Pre-defined colour variables:
- `${RED}`, `${GREEN}`, `${YELLOW}`, `${BLUE}`, `${PURPLE}`, `${CYAN}`
- `${WHITE}`, `${GRAY}`, `${NC}` (No Colour)

### Template Locations

- System templates: `/opt/ubuntu-welcome-fancy/templates/`
- User templates: `~/.config/ubuntu-welcome-fancy/templates/`

## 📁 File Structure

```
/opt/ubuntu-welcome-fancy/          # Main installation directory
├── scripts/
│   ├── welcome-display.sh          # Main display script
│   ├── welcome-config.sh           # Configuration manager
│   └── template-manager.sh         # Template manager
└── templates/                      # System templates
    ├── retro.sh
    ├── elegant.sh
    └── developer.sh

/etc/ubuntu-welcome-fancy/          # System configuration
└── config.json                     # Global settings

~/.config/ubuntu-welcome-fancy/     # User configuration
├── user-config.json               # User settings
├── templates/                     # Custom templates
└── todo.txt                      # TODO list (developer template)
```

## 🔧 Advanced Configuration

### Global Configuration
System administrators can configure global settings in `/etc/ubuntu-welcome-fancy/config.json`:

```json
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
```

### Disabling Welcome Screen
To temporarily disable the welcome screen:
```bash
export WELCOME_DISABLED=1
```

To permanently disable for a user:
```bash
# Comment out the welcome screen section in ~/.bashrc
nano ~/.bashrc
```

## 🐛 Troubleshooting

### Welcome Screen Not Appearing
1. Check if the script is executable:
   ```bash
   ls -la /opt/ubuntu-welcome-fancy/scripts/welcome-display.sh
   ```

2. Verify bash integration:
   ```bash
   grep -n "Ubuntu Fancy Welcome" ~/.bashrc
   ```

3. Test manually:
   ```bash
   /opt/ubuntu-welcome-fancy/scripts/welcome-display.sh
   ```

### Configuration Issues
1. Validate JSON configuration:
   ```bash
   jq . ~/.config/ubuntu-welcome-fancy/user-config.json
   ```

2. Reset to defaults:
   ```bash
   welcome-config --reset
   ```

3. Check permissions:
   ```bash
   ls -la ~/.config/ubuntu-welcome-fancy/
   ```

### Template Problems
1. Check template syntax:
   ```bash
   bash -n ~/.config/ubuntu-welcome-fancy/templates/your-template.sh
   ```

2. Test template directly:
   ```bash
   bash ~/.config/ubuntu-welcome-fancy/templates/your-template.sh
   ```

## 🤝 Contributing

Contributions are welcome! Please feel free to:

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests if applicable
5. Submit a pull request

### Development Guidelines
- Follow bash best practices
- Use British English spelling and terminology
- Test on multiple Ubuntu versions
- Document any new features
- Maintain backwards compatibility

## 📄 Licence

This project is licensed under the MIT Licence - see below for details:

```
MIT Licence

Copyright (c) 2025 SteffMet

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicence, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
```

## 🙏 Acknowledgements

- Ubuntu community for the inspiration
- ASCII art generators for template designs
- Open source contributors who make projects like this possible

## 📞 Support

- **GitHub Issues**: [Report bugs or request features](https://github.com/SteffMet/ubuntu-welcome-fancy/issues)
- **GitHub Discussions**: [Community support and ideas](https://github.com/SteffMet/ubuntu-welcome-fancy/discussions)

## 🔄 Updates

Check for updates by pulling the latest version from GitHub:

```bash
cd ubuntu-welcome-fancy
git pull origin main
./install-welcome.sh
```

---

**Enjoy your beautiful new Ubuntu welcome experience!** 🎉

Made with ❤️ by [SteffMet](https://github.com/SteffMet)
