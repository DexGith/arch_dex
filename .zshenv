# ~/.zshenv
# This file sets the ENVIRONMENT for ALL shells (interactive and non-interactive).

# --- Standard Tools & Settings ---
export EDITOR=nvim
export MANPAGER='nvim +Man!'
export QT_QPA_PLATFORMTHEME=qt6ct # Crucial for Qt apps like Dolphin
export LS_COLORS="$LS_COLORS:ow=30;44:"

# --- Pyenv Initialization (CORRECTED ORDER) ---
# FIX #1: We must define PYENV_ROOT *before* we use it in the PATH.
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init --path)"
eval "$(pyenv init -)"

# --- Add Other Custom Directories to PATH ---
export PATH="$HOME/.local/bin:$PATH"
export PATH="$HOME/.cargo/bin:$PATH"

# FIX #2: I have cleaned up your broken script path. The brackets were incorrect.
export PATH="$PATH:$HOME/scripts/ddesk:$HOME/scripts/ddesk/nothing:$HOME/scripts/ddesk/obsidian"

# --- Keychain SSH Agent Initialization ---
# This ensures your SSH keys are available everywhere.
if [ -z "$SSH_AUTH_SOCK" ]; then
    eval $(keychain --eval --quiet id_ed25519)
    eval $(keychain --eval --quiet ssh)
fi
