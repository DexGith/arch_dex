# ~/.zshenv
# This file sets the ENVIRONMENT for ALL shells (interactive and non-interactive).
# This version is idempotent and will not create duplicate PATH entries.

# --- Standard Tools & Settings ---
export EDITOR=nvim
export MANPAGER='nvim +Man!'
export QT_QPA_PLATFORMTHEME=qt6ct
export LS_COLORS="$LS_COLORS:ow=30;44:"

# Define XDG directories early if you use them for other configs
export XDG_CONFIG_HOME=$HOME/.config
export DEV_ENV_HOME="$HOME/personal/dev" # if this is meant as an env var

# --- Helper functions to safely add to PATH ---
# Adds a directory to the end of the PATH if it's not already there.
addToPath() {
    if [ -d "$1" ] && [[ ":$PATH:" != *":$1:"* ]]; then
        export PATH="$PATH:$1"
    fi
}

# Adds a directory to the beginning of the PATH if it's not already there.
addToPathFront() {
    if [ -d "$1" ] && [[ ":$PATH:" != *":$1:"* ]]; then
        export PATH="$1:$PATH"
    fi
}

# --- Pyenv Initialization ---
# The pyenv init command handles its own PATH logic, so we just run it.
export PYENV_ROOT="$HOME/.pyenv"
addToPathFront "$PYENV_ROOT/bin" # Prepend pyenv bin first
eval "$(pyenv init --path)"
eval "$(pyenv init -)"

# --- Add Other Custom Directories to PATH ---
# Order matters: frequently used binaries usually go first.

# Prepend frequently used user binaries
addToPathFront "$HOME/.local/bin"
addToPathFront "$HOME/.cargo/bin" # Rust's cargo binaries
# addToPathFront "$HOME/.deno/bin"   # Deno binaries
# addToPathFront "$HOME/.local/go/bin" # User's Go binaries
# addToPathFront "$HOME/.local/apps"   # Generic local applications

# For NVM/N: if you use NVM/N, their initialization scripts will manage their PATH.
# If you manually install 'n', you might need this:
# addToPathFront "$HOME/.local/n/bin/"

# Specific script/project directories (often appended or placed where needed)
addToPath "$HOME/scripts/ddesk"
addToPath "$HOME/scripts/ddesk/]]"
addToPath "$HOME/scripts/ddesk/]"
addToPath "$HOME/scripts/ddesk/["
addToPath "$HOME/scripts/ddesk/nothing"
addToPath "$HOME/scripts/ddesk/obsidian"
# addToPath "$HOME/personal/ghostty/zig-out/bin" # Example of project-specific bin
# addToPath "$HOME/.sst/bin" # Example of framework-specific bin

# Other common paths you might need to prepend or append depending on preference
# addToPathFront "$HOME/.zig" # Zig compiler
# addToPathFront "$HOME/.local/.npm-global/bin" # Global NPM packages
# addToPathFront "$HOME/.local/odin" # Odin compiler
addToPathFront "$HOME/.local/scripts" # Your general purpose scripts

# Example of a system-wide Go path (if you installed Go system-wide)
# addToPathFront "/usr/local/go/bin"

# Example of a language server path
# addToPathFront "$HOME/personal/sumneko/bin"

# --- Keychain SSH Agent Initialization ---
if [ -z "$SSH_AUTH_SOCK" ]; then
    eval $(keychain --eval --quiet id_ed25519)
    eval $(keychain --eval --quiet ssh)
fi

# Clean up the helper functions so they don't pollute the shell
unset -f addToPath
unset -f addToPathFront
export PATH="$HOME/.npm-global/bin:$PATH"


# --- PASTE THIS BLOCK IN ITS PLACE ---

# --------------------------------------------------------------------
# Luarocks - Path configuration for locally installed Lua packages
# --------------------------------------------------------------------
# Set the search paths for Lua modules
export LUA_PATH='/usr/share/lua/5.1/?.lua;/usr/local/share/lua/5.1/?.lua;/usr/local/share/lua/5.1/?/init.lua;/usr/share/lua/5.1/?/init.lua;/usr/local/lib/lua/5.1/?.lua;/usr/local/lib/lua/5.1/?/init.lua;/usr/lib/lua/5.1/?.lua;/usr/lib/lua/5.1/?/init.lua;./?.lua;./?/init.lua;/home/dex/.luarocks/share/lua/5.1/?.lua;/home/dex/.luarocks/share/lua/5.1/?/init.lua'
export LUA_CPATH='/usr/local/lib/lua/5.1/?.so;/usr/lib/lua/5.1/?.so;/usr/local/lib/lua/5.1/loadall.so;/usr/lib/lua/5.1/loadall.so;./?.so;/home/dex/.luarocks/lib/lua/5.1/?.so'

# Safely add the luarocks executable path to the FRONT of the PATH variable
# We need to re-define the function here since it was unset earlier in the script.
addToPathFront() {
    if [ -d "$1" ] && [[ ":$PATH:" != *":$1:"* ]]; then
        export PATH="$1:$PATH"
    fi
}

addToPathFront "/home/dex/.luarocks/bin"
unset -f addToPathFront

