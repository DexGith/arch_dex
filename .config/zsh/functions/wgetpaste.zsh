# /home/dex/.config/zsh/functions/wgetpaste.zsh

# -----------------------------------------------------------------------------
#  Clipboard Command-Line Tools (inspired by Espanso triggers)
# -----------------------------------------------------------------------------

# A helper function to get clipboard content reliably
# It automatically uses wl-paste on Wayland or xclip on X11.
# A helper function to get clipboard content reliably.
# This version CHECKS THE SESSION TYPE before choosing a tool.
_get_clip() {
  # Check the session type using the standard $XDG_SESSION_TYPE variable
  if [[ "$XDG_SESSION_TYPE" == "wayland" ]]; then
    # We are in a Wayland session, so use wl-paste
    if command -v wl-paste >/dev/null; then
      wl-paste --no-newline
    else
      echo "Error: You are in a Wayland session, but 'wl-paste' is not installed." >&2
      echo "Please install the 'wl-clipboard' package." >&2
      return 1
    fi
  else
    # We assume an X11 session (or fallback), so use xclip
    if command -v xclip >/dev/null; then
      xclip -o -selection clipboard
    else
      echo "Error: You are in an X11 session, but 'xclip' is not installed." >&2
      echo "Please install the 'xclip' package." >&2
      return 1
    fi
  fi
}
# (P)astebin: Pastes clipboard content to a pastebin service using wgetpaste
# This is a much cleaner version of your ;;pbin; trigger.
Rbin() {
  _get_clip | wgetpaste -r -C
}

Pbin() {
  _get_clip | wgetpaste -C
}


# (G)repbin: Greps content from a URL on the clipboard.
# Accepts all standard grep arguments.
# Usage: Gbin -i "error"
#        Gbin "some pattern"
Gbin() {
  local url=$(_get_clip)
  if [[ -z "$url" ]]; then return 1; fi # Exit if clipboard is empty

  local grep_input
  # This is the magic part: 'read' with a prompt
  read 'grep_input?Grep > '

  # If the user just presses Enter or Ctrl+D, exit gracefully
  if [[ -z "$grep_input" ]]; then
    echo "No pattern entered. Aborting." >&2
    return 1
  fi

  # Use ${(z)...} to safely split the user's input into words for grep
  # This correctly handles input like: -i "some phrase"
  grep ${(z)grep_input} <(curl -sL "$url")
}
# (V)imbin: Opens content from a URL on the clipboard directly in Vim.
# Usage: Vbin
Vbin() {
  local url=$(_get_clip)
  if [[ -z "$url" ]]; then return 1; fi # Exit if clipboard is empty

  # The '-' tells vim to read from standard input (stdin)
  curl -sL "$url" | vim -
}

# Cbin is a common alias for copying, so let's call it Curlbin
# (C)urlbin: Curls the URL on the clipboard and prints the output to the terminal
# Usage: Curlbin
#        Curlbin | grep "something"
Cbin() {
    local url=$(_get_clip)
    if [[ -z "$url" ]]; then return 1; fi # Exit if clipboard is empty

    curl -sL "$url"
}

Obin() {
    local url=$(_get_clip)
    if [[ -z "$url" ]]; then return 1; fi # Exit if clipboard is empty

    curl -sL "$url" | less
}
