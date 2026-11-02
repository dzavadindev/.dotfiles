# PSA: DO NOT EVER JUST RUN SCRIPTS FROM THE INTERNET

```
IF FOR WHATEVER REASON YOU WANT TO USE THIS, MAKE BACKUPS OF ANY TOOLS YOU ARE INSTALLING (SEE BELOW, CHECK THE `./install.sh` SCRIPT).
```

# My Dotfiles

This repository contains my personal configuration files (dotfiles) for zsh, hyprland, nvim, opencode and more.

## How to Use

1. Clone the repo to `~/dotfiles` (make sure to grab submodules):

```bash
git clone --recursive https://github.com/dzavadindev/.dotfiles.git ~/dotfiles
# or for existing repos
git submodules update --init --recursive
```

2. Run the setup script. 

```bash
cd ~/dotfiles
./setup.sh
```

## Another remarks

### Tools Used

// THIS NEEDS TO BE REDONE :D
// I ALSO NEED TO CLEAN THE REPO

### Known bugs

1. When installing, the script may die on the setup of greetd. Changing your display manager means disabling the display manager for some time.
