#!/usr/bin/env bash

# --- Configuration ---
#----------------------

DOTFILES_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
BACKUP_DIR="$HOME/.dotfiles_backup/$(date +%Y%m%d_%H%M%S)"
SCRIPTS_DIR="$DOTFILES_DIR/scripts"

# Define folders array, starting with 'common' for "all systems" dotfiles
folders=("common")

if [[ "$OSTYPE" == "darwin"* ]]; then
    echo "macOS detected"
    folders+=("macos")
elif [[ "$REMOTE_CONTAINERS" == "true" ]] || [[ "$OSTYPE" == "linux-gnu"* ]]; then
    echo "Linux detected."
    folders+=("linux")
fi


# --- Functions ---
# -----------------

link_file() {
    local source_file=$1
    local target_file=$2

    # 1. Check if target is already a valid symlink
    if [ -L "$target_file" ] && [ "$(readlink "$target_file")" == "$source_file" ]; then
        echo "   [OK] $target_file is already linked."
        return
    fi

    # 2. Backup existing regular file (not a symlink)
    if [ -e "$target_file" ] && [ ! -L "$target_file" ]; then
        echo "   [BACKUP] Moving existing $target_file to $BACKUP_DIR"
        mkdir -p "$BACKUP_DIR"
        mv "$target_file" "$BACKUP_DIR/"
    fi

    # 3. Create the symlink
    # Ensure parent directory exists (handle nested configs like .config/nvim/init.vim)
    mkdir -p "$(dirname "$target_file")"
    ln -sf "$source_file" "$target_file"
    echo "   [LINK] Linked $target_file -> $source_file"
}

run_scripts() {
    local folder_name=$1
    local target_dir="$SCRIPTS_DIR/$folder_name"

    if [ -d "$target_dir" ]; then
        echo "------------------------------------------------"
        echo "Running scripts for: $folder_name"
        
        # Loop through files in that directory
        for script in "$target_dir"/*; do
            # Only run if it is a file and is executable
            if [ -f "$script" ] && [ -x "$script" ]; then
                echo "   [EXEC] Running $(basename "$script")..."
                "$script"
            elif [ -f "$script" ]; then
                echo "   [SKIP] $(basename "$script") is not executable (chmod +x)."
            fi
        done
    fi
}


# --- Main Execution ---
# ----------------------

echo "Starting dotfiles installation..."
echo "Dotfiles directory: $DOTFILES_DIR"

for folder in "${folders[@]}"; do
    echo "------------------------------------------------"
    echo "Processing folder: $folder"
    
    # Find all files in the folder (including hidden ones, excluding . and ..)
    # We use 'find' to handle recursion if you have folders like .config/ inside common/
    find "$DOTFILES_DIR/$folder" -type f -not -name '.gitkeep' | while read -r file; do
        
        # Strip the repo path prefix to get the relative path
        # e.g. /home/user/dotfiles/common/.bashrc -> .bashrc
        rel_path="${file#$DOTFILES_DIR/$folder/}"
        
        # Construct the target path in home directory
        target_path="$HOME/$rel_path"
        
        link_file "$file" "$target_path"
    done
done

for folder in "${folders[@]}"; do
    run_scripts "$folder"
done

echo "------------------------------------------------"
echo "Done! Restart your shell to see changes."