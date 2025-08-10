#!/bin/bash
#
# This script syncs personal configuration files from this Arch Linux system
# into this git repository. It correctly separates system packages from user configs.

set -e

# --- Configuration ---
REPO_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &> /dev/null && pwd)
HOME_DIR=~

# --- List of YOUR personal config files/dirs to back up ---

# --- System Level Configs ---
SYSTEM_FILES_TO_SYNC=(
    "/etc/fstab"
    "/etc/pacman.conf"
    "/etc/default/grub"
    "/etc/sudoers"
    "/etc/hostname"
    "/etc/locale.gen"
    "/etc/vconsole.conf"
    "/etc/keyd/default.conf"
)
SYSTEM_DIRS_TO_SYNC=(
    "/etc/sudoers.d"
    "/usr/local/bin"
    # Be careful with these systemd dirs; they can contain many default files.
    # "/etc/systemd/system"
    # "/etc/systemd/user"
)

# --- NEW: Dotfiles in your Home folder ---
# Add single dotfiles from your home directory (~) here.
HOME_FILES_TO_SYNC=(
    ".zshrc"
    ".gitconfig"
    ".tmux.conf"
    ".bashrc"
    ".vimrc"
    ".bash_logout"
    ".nanorc"
    ".profile"
    ".xbindkeysrc"
    ".xmodmaprc"
    ".Xresources"
    ".Xdefaults"
    ".Xauthority"
)

# Add directories from your HOME folder here.
HOME_DIRS_TO_SYNC=(
    "scripts"
    "Home/K/Keepassxc"
    ".config/alacritty"
    ".config/espanso"
    ".config/copyq"
    ".config/autostart"
    ".config/kitty"
    ".config/keepassxc"
    ".config/Deskflow"
    ".config/nvim"
    ".config/input-remapper-2"
    ".config/openbox"
    ".config/openrazer"
    ".config/rofi"
    ".config/skippy-xd"
    ".config/sublime-text"
    ".config/sxhkd"
    ".config/tmux-sessionizer"
    ".config/waybar"
    ".local/share/applications"
    ".local/share/tmux"
    ".local/share/copyq"
    ".local/share/fonts"
    ".local/state/nvim"
    ".local/state/syncthing"
    ".local/scripts"
    ".local/bin"
)
# --- End of Configuration ---


echo "🔵 Starting personalized sync..."
echo "   Repo Destination: $REPO_DIR"
echo ""

# --- 1. Generate Package Lists ---
echo "📦 Generating package lists..."
pacman -Qqe > "$REPO_DIR/package_list_explicit.txt"
pacman -Qqm > "$REPO_DIR/package_list_foreign.txt"
echo "   - Done."
echo ""

# --- 2. Sync Home Directory Configs ---
echo "🏠 Syncing files & directories from your Home folder ($HOME_DIR)..."

# Sync single dotfiles from home
for file in "${HOME_FILES_TO_SYNC[@]}"; do
    source_path="$HOME_DIR/$file"
    dest_path="$REPO_DIR/$file" # Note: Places them in a "Home" subdir in the repo

    if [ -f "$source_path" ]; then
        echo "   - Syncing file: ~/$file"
        # Ensure the destination directory exists
        mkdir -p "$(dirname "$dest_path")"
        rsync -av "$source_path" "$dest_path"
    else
        echo "   - WARNING: File ~/$file not found. Skipping."
    fi
done

# Sync whole directories from home
for dir in "${HOME_DIRS_TO_SYNC[@]}"; do
    source_path="$HOME_DIR/$dir"
    dest_path="$REPO_DIR/$dir"
    
    if [ -d "$source_path" ]; then
        echo "   - Syncing dir:  ~/$dir/"
        mkdir -p "$(dirname "$dest_path")"
        rsync -av --delete "$source_path/" "$dest_path/"
    else
        echo "   - WARNING: Directory ~/$dir not found. Skipping."
    fi
done
echo ""

# --- 3. Sync Specific System Files & Dirs ---
echo "⚙️  Syncing specific system-level configs..."
for file_path in "${SYSTEM_FILES_TO_SYNC[@]}"; do
    if [ -e "$file_path" ]; then
        echo "   - Syncing file: $file_path"
        rsync -avR "$file_path" "$REPO_DIR/"
    else
        echo "   - WARNING: File $file_path not found. Skipping."
    fi
done

for dir_path in "${SYSTEM_DIRS_TO_SYNC[@]}"; do
    if [ -d "$dir_path" ]; then
        echo "   - Syncing dir:  $dir_path/"
        rsync -avR --delete "$dir_path/" "$REPO_DIR/"
    else
        echo "   - WARNING: Directory $dir_path not found. Skipping."
    fi
done

echo ""
echo "✅ Sync complete! Your personal configs are backed up."
echo "Run 'git status' to see what has changed."
