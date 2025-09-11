# ~/.zshrc file for zsh interactive shells.
xset r rate 176 59

# 1) git oh-my-zsh
# requirements, zsh shell, curl or wget
# sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# 2) get zsh-vi-mode
# git clone https://github.com/jeffreytse/zsh-vi-mode \
#   $ZSH_CUSTOM/plugins/zsh-vi-mode


KEYTIMEOUT=1

ZVM_VI_INSERT_ESCAPE_BINDKEY=JJ

# Source the plugin now td_hat it's installed via AUR


# ~/.zshrc file for zsh interactive shells.
KEYTIMEOUT=1

ZVM_VI_INSERT_ESCAPE_BINDKEY=JJ

ZSH_THEME=""

export ZSH="$HOME/.oh-my-zsh"

# 2. Define which plugins you want to load
#    (list the names separated by spaces inside the parentheses)

plugins+=(zsh-vi-mode)


# 3. Load Oh My Zsh itself. This MUST be the last line.
source "$ZSH/oh-my-zsh.sh"


# Source the plugin now that it's installed via AUR
# source /usr/share/zsh/plugins/zsh-vi-mode/zsh-vi-mode.plugin.zsh

# --- FZF Integration with zsh-vi-mode ---
# This function will be run automatically by the plugin after it loads.
function zvm_after_init() {
  # Load fzf keybindings and completions
  source <(fzf --zsh)


   # --- Re-bind Custom Keys for Vi Insert and Normal Modes ---

  # --- Application Launchers (Both Modes) ---
  bindkey -s -M viins '^f' "tmux-sessionizer\r"
  bindkey -s -M vicmd '^f' "tmux-sessionizer\r"
  bindkey -s -M viins '\eh' "tmux-sessionizer -s 0\r"
  bindkey -s -M vicmd '\eh' "tmux-sessionizer -s 0\r"
  bindkey -s -M viins '\et' "tmux-sessionizer -s 1\r"
  bindkey -s -M vicmd '\et' "tmux-sessionizer -s 1\r"
  bindkey -s -M viins '\en' "tmux-sessionizer -s 2\r"
  bindkey -s -M vicmd '\en' "tmux-sessionizer -s 2\r"
  bindkey -s -M viins '\es' "tmux-sessionizer -s 3\r"
  bindkey -s -M vicmd '\es' "tmux-sessionizer -s 3\r"
  bindkey -s -M viins '\eb' "tmux-sessionizer -s 4\r"
  bindkey -s -M vicmd '\eb' "tmux-sessionizer -s 4\r"


  # --- General Editing & Navigation (Mostly for Insert Mode) ---
  # Some are also bound in Normal mode for a consistent experience,
  # overriding some default Vi keybindings.

  # Unbind Ctrl+S to prevent terminal freeze
  bindkey -r -M viins '^S'
  bindkey -r -M vicmd '^S'

  # Line editing
  bindkey -M viins '^U' backward-kill-line
  bindkey -M viins '^K' kill-line
  bindkey -M vicmd '^K' kill-line 

  # Word/Char editing
  bindkey -M viins '^[[3;5~' kill-word      # Ctrl+Delete
  bindkey -M vicmd '^[[3;5~' kill-word      # Ctrl+Delete
  bindkey -M viins '^[[3~'   delete-char    # Delete
  bindkey -M viins '^[[1;5C' forward-word   # Ctrl+Right
  bindkey -M vicmd '^[[1;5C' forward-word
  bindkey -M viins '^[[1;5D' backward-word  # Ctrl+Left
  bindkey -M vicmd '^[[1;5D' backward-word

  # Line Navigation (Emacs style)
  bindkey -M viins '^A' beginning-of-line # Ctrl+A
  bindkey -M vicmd '^A' beginning-of-line
  bindkey -M viins '^E' end-of-line     # Ctrl+E
  bindkey -M vicmd '^E' end-of-line
  bindkey -M viins '^[[H' beginning-of-line # Home
  bindkey -M vicmd '^[[H' beginning-of-line
  bindkey -M viins '^[[F' end-of-line       # End
  bindkey -M vicmd '^[[F' end-of-line

  # # History/Buffer Navigation
  # bindkey -M viins '^[[5~' beginning-of-buffer-or-history # Page Up
  # bindkey -M vicmd '^[[5~' beginning-of-buffer-or-history
  # bindkey -M viins '^[[6~' end-of-buffer-or-history       # Page Down
  # bindkey -M vicmd '^[[6~' end-of-buffer-or-history

  # Yank/Paste/Undo
  bindkey -M viins '^[[Z' undo # Shift+Tab
  bindkey -M vicmd '^[[Z' undo
  bindkey -M viins '^Y' yank
  bindkey -M viins '\ey' yank-pop

  # --- Special Bindings & Custom Widgets ---
  
  # Insert a newline in the prompt
  # NOTE: Not bound in vicmd mode, as 'j' is used for navigation.
  bindkey -M viins '^J' self-insert
  bindkey -M vicmd '^J' self-insert

  # History expansion on space
  # NOTE: Not bound in vicmd mode, as 'space' is used for navigation.
  bindkey -M viins ' ' magic-space

  # Toggle prompt style
  bindkey -M viins '^P' toggle_oneline_prompt
  bindkey -M vicmd '^P' toggle_oneline_prompt

  # Edit command line in $EDITOR
  bindkey -M viins '\ee' edit-command-line
  bindkey -M vicmd '\ee' edit-command-line

  # Clear the kill ring (paste history)
  bindkey -M viins '\ek' clear-kill-ring
  bindkey -M vicmd '\ek' clear-kill-ring

  # Insert a newline in the prompt
  # NOTE: Not bound in vicmd mode, as 'j' is used for navigation.
  bindkey -M viins '^J' self-insert


  # --- Special Bindings & Custom Widgets ---

  # WIDGET: Bring the last background job to the foreground (fg)
  bindkey -M viins '^[z]' fg-widget
  bindkey -M vicmd '^[z]' fg-widget
  
  bindkey -M viins '^[x]' zi-widget
  bindkey -M vicmd '^[x]' zi-widget


  zle -N fg-widget
  zle -N zi-widget
}






setopt autocd              # change directory just by typing its name
#setopt correct            # auto correct mistakes
setopt interactivecomments # allow comments in interactive mode
setopt magicequalsubst     # enable filename expansion for arguments of the form ‘anything=expression’
setopt nonomatch           # hide error message if there is no match for the pattern
setopt notify              # report the status of background jobs immediately
setopt numericglobsort     # sort filenames numerically when it makes sense
setopt promptsubst         # enable command substitution in prompt

WORDCHARS=${WORDCHARS//\/} # Don't consider certain characters part of the word

# hide EOL sign ('%')
PROMPT_EOL_MARK=""


stty -ixon # to stop the ctrl + s freezing the terminal (ctrl+q unfreezes terminal) so that I use ctrl + s as a prefix in tmux 

# configure key keybindings
bindkey -e                                        # emacs key bindings
# bindkey -v                                        # emacs key bindings
autoload -U edit-command-line
zle -N edit-command-line
bindkey '\ee' edit-command-line # Or use '\ev' if you prefer
bindkey ' ' magic-space                           # do history expansion on space
bindkey -r '^S'					  # Unbinding Ctrl+s (forward-i-search) this way stty -ixon works fine
bindkey '^U' backward-kill-line                   # ctrl + U
bindkey '^[[3;5~' kill-word                       # ctrl + Supr
# if you want to apply this to vim and everythig you can do
# the -a option for example bindkey -a tells zsh to apply this binding 
# to the viins keymap (Vi INSERT mode). just saying
bindkey '^K' kill-line                            # This binds Ctrl+K to the kill-line action, specifically for Vi's INSERT mode
bindkey '^[[3~' delete-char                       # delete
bindkey '^[[1;5C' forward-word                    # ctrl + ->
bindkey '^[[1;5D' backward-word                   # ctrl + <-
bindkey '^[[5~' beginning-of-buffer-or-history    # page up
bindkey '^[[6~' end-of-buffer-or-history          # page down
bindkey '^[[H' beginning-of-line                  # home
bindkey '^[[F' end-of-line                        # end
bindkey '^A' beginning-of-line                  # home
bindkey '^E' end-of-line                        # end
bindkey '^[[Z' undo                               # shift + tab undo last action
# Add Emacs-style yank/paste to Vi's INSERT mode
bindkey '^Y' yank
bindkey '\ey' yank-pop
# bindkey '^Y' redo                                 # Bind Ctrl+Y to redo
bindkey '^J' self-insert                        # Bind Alt+Enter, but it t does'work so ctrl+J is my next bet to insert a newline in the command line

bindkey -s ^f "tmux-sessionizer\r"
bindkey -s '\eh' "tmux-sessionizer -s 0\r"
bindkey -s '\et' "tmux-sessionizer -s 1\r"
bindkey -s '\en' "tmux-sessionizer -s 2\r"
bindkey -s '\es' "tmux-sessionizer -s 3\r"



# --[VI]-- [ VI keybinds for zsh ] --W32 Tue, 12 at 15:48--



# NOT_NEEDED this is not needed because we are trying to set up the
# zsh-vi-mode plugin W32 Tue, 12 at 15:47
#2 ---- [viins-insert keybinds] ----

# bindkey -M viins '^?' backward-delete-char
# bindkey -M viins '^W' backward-kill-word

#2 END---- [viins-insert keybinds] ----



# # -------------------------------------------------------------------
# # ZSH VI-MODE: The Final and Correct Architecture
# # -------------------------------------------------------------------
#
# # We must explicitly load the hook function system first.
# autoload -U add-zsh-hook
#
# # --- PART 1: The Foundation (Handles I/N modes) ---
# _update_prompt_and_cursor_interactively() {
#     case $KEYMAP in
#       vicmd)
#         if (( REGION_ACTIVE )); then
#           PROMPT_INDICATOR="%F{magenta}[V] "
#         else
#           PROMPT_INDICATOR="%F{yellow}[N] "
#         fi
#         echo -ne '\e[2 q'
#         ;;
#       viins|main)
#         PROMPT_INDICATOR="%F{cyan}[I] "
#         echo -ne '\e[6 q'
#         ;;
#     esac
#     zle .reset-prompt
# }
# zle -N zle-keymap-select _update_prompt_and_cursor_interactively
#
# # --- PART 2: The "New Line" Logic ---
# _set_prompt_for_new_line() {
#     PROMPT_INDICATOR="%F{cyan}[I] "
#     echo -ne '\e[6 q'
# }
# zle -N zle-line-init _set_prompt_for_new_line
# add-zsh-hook precmd _set_prompt_for_new_line
#
# # --- PART 3: Targeted "Scalpel" Widgets and Bindings ---
#
# # WIDGET 1: Hijacks 'v' in Normal mode for instant [V] indicator.
# _enter_visual_mode_and_update_prompt() {
#   zle .visual-mode
#   _update_prompt_and_cursor_interactively
# }
# zle -N _enter_visual_mode_and_update_prompt
# bindkey -M vicmd 'v' _enter_visual_mode_and_update_prompt
#
#
# _enter_visual_line_mode_and_update_prompt() {
#   zle .visual-line-mode
#   _update_prompt_and_cursor_interactively
# }
# zle -N _enter_visual_line_mode_and_update_prompt 
# bindkey -M vicmd 'V' _enter_visual_line_mode_and_update_prompt 
#
#
# # WIDGET 2 (NEW): Hijacks 'Esc' in Visual mode to exit and update.
# _exit_visual_mode_and_update_prompt() {
#   zle .deactivate-region
#   _update_prompt_and_cursor_interactively
# }
# zle -N _exit_visual_mode_and_update_prompt
# # Note: '^[' is the correct representation for the Escape key.
# bindkey -M visual '^[' _exit_visual_mode_and_update_prompt
#
# # WIDGET 3 (NEW): Hijacks 'y' in Visual mode to yank, exit, and update.
# _yank_and_exit_visual_mode() {
#   zle .vi-yank
#   echo -n "$CUTBUFFER" | xclip -i -selection clipboard
#   _update_prompt_and_cursor_interactively
# }
# zle -N _yank_and_exit_visual_mode
# bindkey -M visual 'y' _yank_and_exit_visual_mode
#
# # WIDGET 4 (NEW): Hijacks 'd' in Visual mode to delete, exit, and update.
# _delete_and_exit_visual_mode() {
#   zle .kill-region
#   _update_prompt_and_cursor_interactively
# }
# zle -N _delete_and_exit_visual_mode
# bindkey -M visual 'd' _delete_and_exit_visual_mode
#
#
# _paste_and_exit_visual_mode() {
#   zle .put-replace-selection # The perfect widget from your test
#   _update_prompt_and_cursor_interactively
# }
# zle -N _paste_and_exit_visual_mode
# bindkey -M visual 'p' _paste_and_exit_visual_mode
#
# # Your original keybinding for 'jjk' escape.
# _vim_jjk_escape() {
#   if [[ ${LBUFFER[-2,-1]} == 'jj' ]]; then
#     LBUFFER=${LBUFFER%jj}
#     zle vi-cmd-mode
#   else
#     zle self-insert
#   fi
# }
# zle -N _vim_jjk_escape
# bindkey -M viins 'k' _vim_jjk_escape
#
# END--[VI]-- [ VI keybinds for zsh ] END----











# enable completion features
autoload -Uz compinit
compinit -U -d ~/.cache/zcompdump # -U for security, -d to specify dump file

      
# Style for ZLE states like visual mode, search, etc.
# This is the modern and correct way to style selections.
# .zshrc
# zstyle ':zle:*' region_highlight 'bg=#FFCB6B'
# Style for ZLE states like visual mode, search, etc.
# This is the modern and correct way to style selections.
# --- ZLE HIGHLIGHT LABORATORY ---
# Use this block to experiment with styles.

## THE GOOD ONE
# zle_highlight=(
#   'default:none'
#   # 'visual:bg=#44475a'
#   'region:bg=#44475a,underline'
#   # 'isearch:bg=cyan,fg=black,bold'
#   # 'special:bg=red,fg=white'
#   # 'special:standout'
# )

# zle_highlight=(
#     'default:none'
#   'visual:bg=white,fg=black'
#   # 'region:bg=#44475a'
#   # 'region:bg=#44475a,fg=#f8f8f2'
#   # 'region:bg=#44475a,underline'
#   'region:bold,underline'
#   # 'region:bold'
#   'special:bg=red,fg=white'
#   'isearch:bg=green,fg=black,bold'
# )

# --- Test Theme 1: "High Contrast Inverted" ---
# zle_highlight=(
#   'default:none'
  # 'visual:bg=white,fg=black'
#   'region:bg=white,fg=black'
#   'isearch:bg=green,fg=black,bold'
#   'special:bg=red,fg=white'
# )

# --- Test Theme 2: "Cyberpunk Neon" ---
# zle_highlight=(
#   'default:none'
#   'visual:bg=#282a36,fg=magenta,bold'
#   'region:bg=#282a36,fg=magenta,bold'
#   'isearch:bg=cyan,fg=black'
#   'special:bg=red,fg=white,underline'
# )

# --- Test Theme 3: "Subtle & Modern" ---
# zle_highlight=(
#   'default:none'
#   'visual:bg=#44475a'
#   'region:bg=#44475a,underline'
#   'isearch:bg=yellow,fg=black'
#   'special:standout'
# )
# --- Test Theme 4: "Terminal Green" ---
# zle_highlight=(
#   'default:none'
#   'visual:bg=green,fg=black'
#   'region:bg=green,fg=black'
#   'isearch:bg=white,fg=green,bold'
#   'special:bg=red,fg=white'
# )
# --- Test Theme 5: "Just Underline" ---
# zle_highlight=(
#   # 'default:none'
#   # 'visual:bold,underline'
#   'region:bold,underline'
#   # 'isearch:standout'
#   # 'special:bg=red,fg=white'
# )
# --- Theme: "Dracula Selection" ---
# This matches the effect in your new screenshot by setting a specific
# background color for the selection.



zstyle ':completion:*:*:*:*:*' menu select
zstyle ':completion:*' auto-description 'specify: %d'
zstyle ':completion:*' completer _expand _complete
zstyle ':completion:*' format 'Completing %d'
zstyle ':completion:*' group-name ''
zstyle ':completion:*' list-colors ''
zstyle ':completion:*' list-prompt %SAt %p: Hit TAB for more, or the character to insert%s
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
zstyle ':completion:*' rehash true
zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s
zstyle ':completion:*' use-compctl false
zstyle ':completion:*' verbose true
zstyle ':completion:*:kill:*' command 'ps -u $USER -o pid,%cpu,tty,cputime,cmd'





# History configurations
HISTFILE=~/.zsh_history
HISTSIZE=10000 # Increased HISTSIZE
SAVEHIST=10000 # Increased SAVEHIST to match HISTSIZE for better retention
setopt hist_expire_dups_first # delete duplicates first when HISTFILE size exceeds HISTSIZE
setopt hist_ignore_dups       # ignore duplicated commands history list
setopt hist_ignore_space      # ignore commands that start with space
setopt hist_verify            # show command with history expansion to user before running it
#setopt share_history         # share command history data - uncomment if you use multiple zsh sessions simultaneously and want shared history immediately

# force zsh to show the complete history
alias history="history 0"

# configure `time` format
TIMEFMT=$'\nreal\t%E\nuser\t%U\nsys\t%S\ncpu\t%P'

# make less more friendly for non-text input files, see lesspipe(1)
# Ensure you have 'lesspipe' installed on Arch: sudo pacman -S lesspipe
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
# This is Debian-specific, can be commented out or removed on Arch if not needed.
# if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
#     debian_chroot=$(cat /etc/debian_chroot)
# fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color|kitty) color_prompt=yes;; # Added kitty
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
        # We have color support; assume it's compliant with Ecma-48
        # (ISO/IEC-6429). (Lack of such support is extremely rare, and such
        # a case would tend to support setf rather than setaf.)
        color_prompt=yes
    else
        color_prompt=
    fi
fi

configure_prompt() {
    prompt_symbol=㉿
    # Skull emoji for root terminal
    #[ "$EUID" -eq 0 ] && prompt_symbol=💀
    case "$PROMPT_ALTERNATIVE" in
        twoline)
            PROMPT=$'%F{%(#.blue.green)}┌──${debian_chroot:+($debian_chroot)─}${VIRTUAL_ENV:+($(basename $VIRTUAL_ENV))─}(%B%F{%(#.red.blue)}%n'$prompt_symbol$'%m%b%F{%(#.blue.green)})-[%B%F{reset}%(6~.%-1~/…/%4~.%5~)%b%F{%(#.blue.green)}]\n└─%B${PROMPT_INDICATOR}%(#.%F{red}#.%F{blue}$)%b%F{reset} '
                # Right-side prompt with exit codes and background processes
            #RPROMPT=$'%(?.. %? %F{red}%B⨯%b%F{reset})%(1j. %j %F{yellow}%B⚙%b%F{reset}.)'
            ;;
        oneline)
            PROMPT=$'${debian_chroot:+($debian_chroot)}${VIRTUAL_ENV:+($(basename $VIRTUAL_ENV))}%B%F{%(#.red.blue)}%n@%m%b%F{reset}:%B%F{%(#.blue.green)}%~%b%F{reset}%(#.#.$) '
            RPROMPT=
            ;;
        backtrack) # This was likely a custom name, keeping it.
            PROMPT=$'${debian_chroot:+($debian_chroot)}${VIRTUAL_ENV:+($(basename $VIRTUAL_ENV))}%B%F{red}%n@%m%b%F{reset}:%B%F{blue}%~%b%F{reset}%(#.#.$) '
            RPROMPT=
            ;;
    esac
    unset prompt_symbol
}


# ----- trying to remove capslock stupid letters ---- 

caps_lock_noop(){

}

zle -N caps_lock_noop
# bindkey "\e[387u" caps_lock_noop
# bindkey "387u" caps_lock_noop
# bindkey "\e^[[57387u" caps_lock_noop

bindkey "^[[57387u" caps_lock_noop
bindkey "^[[57387;2u" caps_lock_noop
# ----- trying to remove capslock stupid letters END ---- 

# The following block is surrounded by two delimiters.
# These delimiters must not be modified. Thanks.
# START KALI CONFIG VARIABLES
PROMPT_ALTERNATIVE=twoline
NEWLINE_BEFORE_PROMPT=yes
# STOP KALI CONFIG VARIABLES

if [ "$color_prompt" = yes ]; then
    # override default virtualenv indicator in prompt
    VIRTUAL_ENV_DISABLE_PROMPT=1

    configure_prompt





    # enable syntax-highlighting
    # ARCH LINUX: Path for zsh-syntax-highlighting is typically different.
    # Ensure you installed it via: sudo pacman -S zsh-syntax-highlighting
    ZSH_SYNTAX_HIGHLIGHTING_DIR="/usr/share/zsh/plugins/zsh-syntax-highlighting" # Common Arch path
    if [ -f "$ZSH_SYNTAX_HIGHLIGHTING_DIR/zsh-syntax-highlighting.zsh" ]; then
        . "$ZSH_SYNTAX_HIGHLIGHTING_DIR/zsh-syntax-highlighting.zsh"
        ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets pattern)
        ZSH_HIGHLIGHT_STYLES[default]=none
        ZSH_HIGHLIGHT_STYLES[unknown-token]=underline
        ZSH_HIGHLIGHT_STYLES[reserved-word]=fg=cyan,bold
        ZSH_HIGHLIGHT_STYLES[suffix-alias]=fg=green,underline
        ZSH_HIGHLIGHT_STYLES[global-alias]=fg=green,bold
        ZSH_HIGHLIGHT_STYLES[precommand]=fg=green,underline
        ZSH_HIGHLIGHT_STYLES[commandseparator]=fg=blue,bold
        ZSH_HIGHLIGHT_STYLES[autodirectory]=fg=green,underline
        ZSH_HIGHLIGHT_STYLES[path]=bold
        ZSH_HIGHLIGHT_STYLES[path_pathseparator]=
        ZSH_HIGHLIGHT_STYLES[path_prefix_pathseparator]=
        ZSH_HIGHLIGHT_STYLES[globbing]=fg=blue,bold
        ZSH_HIGHLIGHT_STYLES[history-expansion]=fg=blue,bold
        ZSH_HIGHLIGHT_STYLES[command-substitution]=none
        ZSH_HIGHLIGHT_STYLES[command-substitution-delimiter]=fg=magenta,bold
        ZSH_HIGHLIGHT_STYLES[process-substitution]=none
        ZSH_HIGHLIGHT_STYLES[process-substitution-delimiter]=fg=magenta,bold
        ZSH_HIGHLIGHT_STYLES[single-hyphen-option]=fg=green
        ZSH_HIGHLIGHT_STYLES[double-hyphen-option]=fg=green
        ZSH_HIGHLIGHT_STYLES[back-quoted-argument]=none
        ZSH_HIGHLIGHT_STYLES[back-quoted-argument-delimiter]=fg=blue,bold
        ZSH_HIGHLIGHT_STYLES[single-quoted-argument]=fg=yellow
        ZSH_HIGHLIGHT_STYLES[double-quoted-argument]=fg=yellow
        ZSH_HIGHLIGHT_STYLES[dollar-quoted-argument]=fg=yellow
        ZSH_HIGHLIGHT_STYLES[rc-quote]=fg=magenta
        ZSH_HIGHLIGHT_STYLES[dollar-double-quoted-argument]=fg=magenta,bold
        ZSH_HIGHLIGHT_STYLES[back-double-quoted-argument]=fg=magenta,bold
        ZSH_HIGHLIGHT_STYLES[back-dollar-quoted-argument]=fg=magenta,bold
        ZSH_HIGHLIGHT_STYLES[assign]=none
        ZSH_HIGHLIGHT_STYLES[redirection]=fg=blue,bold
        ZSH_HIGHLIGHT_STYLES[comment]=fg=white,bold
        ZSH_HIGHLIGHT_STYLES[named-fd]=none
        ZSH_HIGHLIGHT_STYLES[numeric-fd]=none
        ZSH_HIGHLIGHT_STYLES[arg0]=fg=cyan
        ZSH_HIGHLIGHT_STYLES[bracket-error]=fg=red,bold
        ZSH_HIGHLIGHT_STYLES[bracket-level-1]=fg=blue,bold
        ZSH_HIGHLIGHT_STYLES[bracket-level-2]=fg=green,bold
        ZSH_HIGHLIGHT_STYLES[bracket-level-3]=fg=magenta,bold
        ZSH_HIGHLIGHT_STYLES[bracket-level-4]=fg=yellow,bold
        ZSH_HIGHLIGHT_STYLES[bracket-level-5]=fg=cyan,bold
        ZSH_HIGHLIGHT_STYLES[cursor-matchingbracket]=standout
    else
        # Fallback or warning if not found
        # echo "Zsh Syntax Highlighting not found at $ZSH_SYNTAX_HIGHLIGHTING_DIR" >&2
        # You might also check /usr/share/zsh-syntax-highlighting/ if the above path doesn't work
        if [ -f /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]; then
             . /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
             # Apply styles here too if using this fallback
        fi
    fi
else
    PROMPT='${debian_chroot:+($debian_chroot)}%n@%m:%~%(#.#.$) ' # This prompt is used if no color. debian_chroot can be removed.
fi
unset color_prompt force_color_prompt

toggle_oneline_prompt(){
    if [ "$PROMPT_ALTERNATIVE" = oneline ]; then
        PROMPT_ALTERNATIVE=twoline
    else
        PROMPT_ALTERNATIVE=oneline
    fi
    configure_prompt
    zle reset-prompt
}
zle -N toggle_oneline_prompt
bindkey ^P toggle_oneline_prompt # Ctrl+P to toggle prompt style

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*|Eterm|aterm|kterm|gnome*|alacritty|kitty) # Added kitty
    TERM_TITLE=$'\e]0;${debian_chroot:+($debian_chroot)}${VIRTUAL_ENV:+($(basename $VIRTUAL_ENV))}%n@%m: %~\a'
    ;;
*)
    ;;
esac



# precmd() {
#     # Print the previously configured title
#     print -Pnr -- "$TERM_TITLE"
#
#     # Print a new line before the prompt, but only if it is not the first line
#     if [ "$NEWLINE_BEFORE_PROMPT" = yes ]; then
#         if [ -z "$_NEW_LINE_BEFORE_PROMPT" ]; then
#             _NEW_LINE_BEFORE_PROMPT=1
#         else
#             print ""
#         fi
#     fi
# }

_zsh_precmd_actions() {
    # Print the previously configured title
    print -Pnr -- "$TERM_TITLE"

    # Print a new line before the prompt, but only if it is not the first line
    if [ "$NEWLINE_BEFORE_PROMPT" = yes ]; then
        if [ -z "$_NEW_LINE_BEFORE_PROMPT" ]; then
            _NEW_LINE_BEFORE_PROMPT=1
        else
            print ""
        fi
    fi
}
add-zsh-hook precmd _zsh_precmd_actions


# enable color support of ls, less and man, and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    #alias dir='dir --color=auto' # Usually covered by ls
    #alias vdir='vdir --color=auto' # Usually covered by ls -l

	# ---- Time  ----

    # 2. Create the alias you want, which simply calls the function above.
    alias ]timer='_my_timer_func'
    alias streamlink='streamlink --player mpv'
    alias T='thunar .'
    alias tt='thunar .'
    alias qq='exit'
    alias ee='exit'
    alias aa='nohup alacritty --working-directory . >/dev/null 2>&1 & disown ; exit'

    # alias ]timer='date "+%T %d-%m"; echo " " ;start=$(date +%s); while true; do current=$(date +%s); elapsed=$((current - start)); printf "\r%02d:%02d" $((elapsed/60)) $((elapsed%60)); sleep 1; done' # Use nano if you prefer: alias nanc='nano ~/.zshrc'


    # ---- Time  END----





    
    alias py='python' # The space at the end tells the shell to perfom alias expansion on the word following sudo
    alias msgbox='zenity' # The space at the end tells the shell to perfom alias expansion on the word following sudo
    alias sudo='sudo ' # The space at the end tells the shell to perfom alias expansion on the word following sudo
    alias ob='obsidian-cli' # https://github.com/Yakitrak/obsidian-cli make sure you have this. really useful
    alias obo='ob o t -v' # https://github.com/Yakitrak/obsidian-cli make sure you have this. really useful
    alias obsearch='obsidian-cli search --vault' # https://github.com/Yakitrak/obsidian-cli make sure you have this. really useful
    alias obsh='obsidian-cli search --vault' # https://github.com/Yakitrak/obsidian-cli make sure you have this. really useful
    alias obshc='obsidian-cli search-content' # https://github.com/Yakitrak/obsidian-cli make sure you have this. really useful
    alias obsec='obsidian-cli search-content' # https://github.com/Yakitrak/obsidian-cli make sure you have this. really useful
    alias obc='obsidian-cli search-content' # https://github.com/Yakitrak/obsidian-cli make sure you have this. really useful
    alias obse='obsidian-cli search-content' # https://github.com/Yakitrak/obsidian-cli make sure you have this. really useful
    alias obsec='obsidian-cli search-content' # https://github.com/Yakitrak/obsidian-cli make sure you have this. really useful
    alias obsearchc='obsidian-cli search-content' # https://github.com/Yakitrak/obsidian-cli make sure you have this. really useful
    alias obset='obsidian-cli set-default' # https://github.com/Yakitrak/obsidian-cli make sure you have this. really useful
    alias obd='obsidian-cli set-default' # https://github.com/Yakitrak/obsidian-cli make sure you have this. really useful
    alias obsd='obsidian-cli set-default' # https://github.com/Yakitrak/obsidian-cli make sure you have this. really useful
    alias o='less' # https://github.com/Yakitrak/obsidian-cli make sure you have this. really useful
    alias c='cd' # https://github.com/Yakitrak/obsidian-cli make sure you have this. really useful
    alias cdfp='cd $(dirname "$(fp)")' # Use nano if you prefer: alias nanc='nano ~/.zshrc'
    alias vim='nvim' # Use nano if you prefer: alias nanc='nano ~/.zshrc'
    alias hx='helix'
    alias ]exe='chmod +x'
    alias ]cpuinfo='cpupower frequency-info'
    alias ]cp=' col -b | xclip -selection clipboard'
    alias ls='ls --color=auto'
    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
    alias diff='diff --color=auto'
    alias ip='ip --color=auto'
    # Add this to your ~/.bashrc or ~/.zshrc on Arch Linux
    alias sc='scrcpy -b 20M -m 1920'
    # ARCH LINUX: Changed ']]c' to 'cls' for clear, more common, and ']]r' to 'src', ']]ev' to 'virc'
    alias ]c='clear'
    alias c.d='cd ~/Desktop' # Keep if you use it, otherwise 'cd ~/Desktop' works fine
    alias c.dd='cd ~/Downloads' # Keep if you use it, otherwise 'cd ~/Desktop' works fine
    alias src='source ~/.zshrc'
    alias md='mkdir -p' # Use nano if you prefer: alias nanc='nano ~/.zshrc'

    # very useful to quickly open .zshrc
    alias ]rc='nvim ~/.zshrc' # Use nano if you prefer: alias nanc='nano ~/.zshrc'
    alias nvrc='nvim ~/.zshrc' # Use nano if you prefer: alias nanc='nano ~/.zshrc'
	alias ]nv='nvim ~/.config/nvim/'
	alias nvnv='nvim ~/.config/nvim/'
    alias ]xnv='xset r rate 178 63;xset q | grep delay'
    alias ]xnv2='xset r rate 173 66;xset q | grep delay'
    alias ]xset='xset r rate 176 59;xset q | grep delay'
    alias ]pc='fastfetch'

	alias ]]r='source ~/.zshrc'
	alias ]p='pwd'
	alias ]h='tldr'
	alias ]w='whoami'
	alias ]i='ifconfig'
	alias ]o='pacman -Qo'
	alias kdex='dex@192.168.11.102'
	alias ]st='systemctl status'
	alias ]ss='systemctl start'
	alias ]sp='systemctl stop'
	alias ]se='systemctl enable'
	alias ]show='pacman -Si'
	alias ]pac='pacman -Qi'
    export LESS_TERMCAP_mb=$'\E[1;31m'     # begin blink
    export LESS_TERMCAP_md=$'\E[1;36m'     # begin bold
    export LESS_TERMCAP_me=$'\E[0m'        # reset bold/blink
    export LESS_TERMCAP_so=$'\E[01;33m'    # begin reverse video
    export LESS_TERMCAP_se=$'\E[0m'        # reset reverse video
    export LESS_TERMCAP_us=$'\E[1;32m'     # begin underline
    export LESS_TERMCAP_ue=$'\E[0m'        # reset underline

    # Take advantage of $LS_COLORS for completion as well
    zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
    zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'
fi

# some more ls aliases
alias ll='ls -alhF' # Added -h for human-readable, -F for type indicators
alias la='ls -AlhF' # Added -h
alias l='ls -CF'

# enable auto-suggestions based on the history
# ARCH LINUX: Path for zsh-autosuggestions is typically different.
# Ensure you installed it via: sudo pacman -S zsh-autosuggestions
ZSH_AUTOSUGGESTIONS_DIR="/usr/share/zsh/plugins/zsh-autosuggestions" # Common Arch path
if [ -f "$ZSH_AUTOSUGGESTIONS_DIR/zsh-autosuggestions.zsh" ]; then
    . "$ZSH_AUTOSUGGESTIONS_DIR/zsh-autosuggestions.zsh"
    # change suggestion color
    ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=#999' # This is good, visible but not intrusive
else
    # Fallback or warning if not found
    # echo "Zsh Autosuggestions not found at $ZSH_AUTOSUGGESTIONS_DIR" >&2
    # You might also check /usr/share/zsh-autosuggestions/ if the above path doesn't work
    if [ -f /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh ]; then
        . /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh
        ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=#999'
    fi
fi

# enable command-not-found if installed
# ARCH LINUX: Use pkgfile's command-not-found handler
# Ensure you installed it via: sudo pacman -S pkgfile AND ran sudo pkgfile --update
if [ -f /usr/share/doc/pkgfile/command-not-found.zsh ]; then
    source /usr/share/doc/pkgfile/command-not-found.zsh
elif [ -f /usr/share/pkgfile/command-not-found.zsh ]; then # Alternative path for pkgfile hook
    source /usr/share/pkgfile/command-not-found.zsh
fi

# You can add any of your personal aliases or functions below this line
# source <(fzf --zsh)

# 1. Free up Ctrl+R completely by unbinding it from both modes.
bindkey -r -M viins '^R' # Unbind from INSERT mode
bindkey -r -M vicmd '^R' # Unbind from NORMAL mode (This was the missing piece!)

# 2. Bind Alt+R to the FZF history widget in BOTH modes.
bindkey -M viins '\er' fzf-history-widget # Bind for INSERT mode
bindkey -M vicmd '\er' fzf-history-widget # Bind for NORMAL mode

# bind alt+e in normal mode to edit in editor
bindkey -M vicmd '\ee' edit-command-line

# 3. Bind Ctrl+R to the native `redo` command, but ONLY in normal mode.
bindkey -M vicmd '^R' redo
# ---- functions i made with ai asstantce ---- 

#------------------------------------------------------------------
#  SMART "FZF OPEN" AND "FZF PREVIEW" FUNCTIONS
#------------------------------------------------------------------


# fo
# look for file and open it 
source $HOME/.config/zsh/functions/fo.zsh

# pw
# some old sushi preview thing on the file, meh still useful
source $HOME/.config/zsh/functions/pw.zsh

# ---[FUNCTIONS]-- [ myfuncs ] [ my functions] ---------


# fp.scuffed.video.preview.zsh
# some unfinished fzf file preview for vids
source $HOME/.config/zsh/functions/fp.scuffed.video.preview.zsh

# fp
# fzf file preview
source $HOME/.config/zsh/functions/fp.zsh

#fp
#fzf file preview
source $HOME/.config/zsh/functions/fpp.zsh

# fastfetch

# --------------------------------------------------------------------
#  Alacritty Dynamic Window Title
#  This code tells Zsh to update the terminal title automatically.
# --------------------------------------------------------------------

# This function runs just BEFORE a command is executed.
# It sets the title to the command being run.
alacritty_preexec() {
  # \e]0; is the "start setting title" command.
  # $1 is the first argument, which is the command itself.
  # \a is the "finish setting title" command.
  print -Pn "\e]0;$1\a"
}

# This function runs just BEFORE the prompt is displayed (i.e., after a command finishes).
# It resets the title to the current directory.
alacritty_precmd() {
  # %~ is Zsh's special character for the current path (e.g., ~/Code/project).
  print -Pn "\e]0;%~\a"
}

# Add our functions to Zsh's hook arrays.
# This tells Zsh to actually run them at the right times.
if [[ "$TERM" == "alacritty" ]]; then
  add-zsh-hook preexec alacritty_preexec
  add-zsh-hook precmd alacritty_precmd
fi


# 1. Define the readable function with a safe, valid name.
#    The leading underscore is a common convention for "helper" functions.
_my_timer_func() {
  # Print the start time and date
  date "+%T %a, %d-%m"
  echo "" # Add a newline

  # Get the starting time in seconds since 1970-01-01
  local start=$(date +%s)
  local last_mins=-1 # Initialize with a value that won't match the first minute

  # Loop forever until you press Ctrl+C
  while true; do
    # Get the current time and calculate total elapsed seconds
    local current=$(date +%s)
    local elapsed=$((current - start))

    # Calculate hours and minutes from total elapsed seconds
    local hours=$((elapsed / 3600))
    local mins=$(((elapsed / 60) % 60))

    # Check if the minute has changed since the last time it was printed
    if [ "$mins" -ne "$last_mins" ]; then
      # Print the formatted time, using \r to return to the start of the line
      printf "\r%02d:%02d" $hours $mins
      # Update the last printed minute
      last_mins=$mins
    fi

    # Wait for one second
    sleep 1
  done
}
# Function to get detailed info for a specific IP address
# Usage: ipinfo 8.8.8.8
ipinfo() {
    # Check if an IP address was provided as an argument
    if [ -z "$1" ]; then
        # If no IP is given, show info for our own IP
        curl ipinfo.io
    else
        # If an IP is given, look it up
        curl ipinfo.io/"$1"
    fi
}


# Function to copy the Nth item from CopyQ (using 1-based counting)
# Usage: cpc 2  (to copy the 2nd item)
cpc() {
  if [[ -z "$1" ]]; then
    echo "Usage: cpc <position>"
    return 1
  fi
  # Subtract 1 from the input to get the correct zero-based index
  copyq select $(($1 - 1))
}
# --- Custom Widget to Clear the Kill Ring ---

# 1. Define a function that will be run by the line editor.
#    This function runs in the correct scope to modify the real killring.
_clear_kill_ring() {
  # This is the core logic that empties the actual killring array.
  killring=()

  # This provides visual feedback so you know it worked.
  # zle -M "Kill ring cleared."
}

# 2. Register the shell function as a ZLE widget.
#    This makes the function available to `bindkey`.
zle -N clear-kill-ring _clear_kill_ring

# 3. Bind the new widget to a key.
#    Alt+K is a good choice (mnemonic for "Kill the Kill-ring").
#    We bind it for both Insert and Normal mode for convenience.
bindkey '\ek' clear-kill-ring      # For Vi INSERT mode

# xdotool mousemove --window $(xdotool getactivewindow) --polar 0 0


if command -v keychain > /dev/null; then

    eval $(keychain --eval --quiet id_ed25519)
    eval $(keychain --eval --quiet ssh)
fi


if command -v zoxide > /dev/null; then
    # 
    # eval "$(zoxide init zsh --cmd cd)"
    eval "$(zoxide init zsh)"
fi


cdcp() {
  if [ -z "$1" ]; then
    echo "Usage: cdcp <filename>"
    return 1
  fi

  ABS_FILE_PATH="$(pwd)/$1"

  REL_FILE_PATH="${ABS_FILE_PATH/#$HOME/~}"

  echo "Full Path:\n\n$(pwd)\n"

  echo "Relative to user home if file within /home/user (!Not smart!:\n\n$REL_FILE_PATH\n"

  echo -n "$ABS_FILE_PATH" | xclip -selection clipboard
}




# A better ls | grep, handles no arguments and adds color
lag() {
  if [ -z "$1" ]; then
    # If no argument is given, just do a normal ls -la
    ls -la
  else
    # If there is an argument, pipe ls to grep
    # --color=auto highlights the match
    ls -la | grep -i --color=auto "$1"
  fi
}


# A better ls | grep, handles no arguments and adds color
lg() {
  if [ -z "$1" ]; then
    # If no argument is given, just do a normal ls -la
    ls -l
  else
    # If there is an argument, pipe ls to grep
    # --color=auto highlights the match
    ls -la | grep -i --color=auto "$1"
  fi
}

obcd() {
    local result=$(obsidian-cli print-default --path-only)
    [ -n "$result" ] && cd -- "$result"
}


fg-widget() {
    BUFFER="fg"
    zle accept-line
}

zi-widget() {
    BUFFER="zi"
    zle accept-line
}

function y() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
	yazi "$@" --cwd-file="$tmp"
	IFS= read -r -d '' cwd < "$tmp"
	[ -n "$cwd" ] && [ "$cwd" != "$PWD" ] && builtin cd -- "$cwd"
	rm -f -- "$tmp"
}

# Custom function for xdg-open
oo() {
  xdg-open "$@"
}

# ---[FUNCTIONS]-- [ myfuncs ] [ my functions] ---------

