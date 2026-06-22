# My Dotfiles

This repository contains my personal configuration files (dotfiles) for ZSH, Neovim, Quickshell and more.

THE SETUP SCRIPT LITERALLY DELETES ALL THE LISTED EXISTING CONFIGURATION FILES FROM YOUR `.config` BEFORE INSTALLING THE NEW ONES. I ONLY USE IT ON FRESH INSTALLS AND WHEN I HAVE ALREADY RAN IT ONCE AND KEEP UPDATING MY CONFIGS. 

IF FOR WHATEVER REASON YOU WANT TO USE THIS, MAKE BACKUPS OF ANY TOOLS YOU ARE INSTALLING (SEE BELOW, CHECK THE `./install.sh` SCRIPT).

## How to Use

1. Clone the repo to `~/dotfiles`:

```bash
git clone https://github.com/dzavadindev/.dotfiles.git ~/dotfiles
```

2. Run the setup script. 

```bash
cd ~/dotfiles
./setup.sh
```

## Another remarks

### Tools Used

- `flameshot` - Screenshot utility. A bit funky on hypr, but does the job for me.
- WIP `hamr` - As much as I wanted to write my own launcher with quickshell, this just has everything
- `greetd` and `tui-greet` - Using a simple TUI based display manager
- `hyprland` - window manager
- `kitty` - terminal emulator
- `nvim` - text editor
- `quickshell` - custom shell elements like the waybar
- `yazi` - TUI file explorer

### Known bugs

1. When installing, the script may die on the setup of greetd. Changing your display manager means disabling the display manager for some time.
