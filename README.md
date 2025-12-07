# dots

A simple cross-platform way to set up my dotfiles.

## Directory Structure
```
~/dotfiles
├── install.sh            # The install script
├── common/               # Files for ALL systems
│   ├── .bashrc
│   ├── .gitconfig
|   |__ .config/
|       |__ starship.toml # File in ~/.config/  
├── macos/                # Files only for Mac
│   ├── .zshrc
│   └── .zshenv
├── linux/                # Files only for Linux/DevContainers
│   └── .bash_aliases     # (Example: Linux-specific aliases)
└── scripts/
    ├── common/             # Scripts to run on all systems
    ├── linux/              # Scripts to run on Linux (e.g., setup-git-completion.sh)
    └── macos/              # Scripts to run on macOS
```


## Installation

1.  Clone the repository:
    ```bash
    git clone https://github.com/lalver1/dots.git ~/dots
    ```
2.  Run the installer:
    ```bash
    cd ~/dots
    ./install.sh
    ```
3.  Restart your shell.


## How `install.sh` Works

The installation script is idempotent (can be run multiple times safely) and handles OS detection, backups, and symlinking automatically.

### 1\. OS Detection & Configuration

The script initializes by detecting the environment. It starts with the `common` folder and appends OS-specific folders to a processing array.

  * **macOS:** Detected via `OSTYPE == darwin*`. Adds `macos` folder.
  * **Linux / Dev Containers:** Detected via `OSTYPE == linux-gnu*` or `REMOTE_CONTAINERS == true`. Adds `linux` folder.

### 2\. The Symlink Logic (`link_file`)

The script iterates through every file in the targeted folders and performs the following checks using the `link_file` function:

1.  **Check for Existing Link:** If the file at the target path is *already* a symlink pointing to the correct dotfile, it skips it (`[OK]`).
2.  **Backup:** If a file exists at the target path but is a *real file* (not a symlink), it is moved to `~/.dotfiles_backup/<timestamp>/`. This ensures no data is lost.
3.  **Link:** It creates a symbolic link (`ln -sf`) pointing from the home directory to the dotfiles repo.
      * *Recursion:* It uses `find` to preserve directory structure (e.g., `common/.config/nvim/init.vim` correctly links to `~/.config/nvim/init.vim`).

### 3\. Setup Scripts (`run_scripts`)

After symlinking, the installer looks into `scripts/<os_name>/`.

  * It iterates through executable files in that folder.
  * It executes them to handle tasks that cannot be solved via symlinks (e.g., installing packages, setting defaults, or appending to files).


## Adding New Configs

### To add a simple file (e.g., `.zshrc`):

1.  Place the file in `common/.zshrc` (for all OS) or `macos/.zshrc` (for Mac only).
2.  Run `./install.sh`.

### To add a setup task (e.g., install Homebrew packages):

1.  Create a script: `scripts/macos/install_brew.sh`.
2.  Make it executable: `chmod +x scripts/macos/install_brew.sh`.
3.  Run `./install.sh`.