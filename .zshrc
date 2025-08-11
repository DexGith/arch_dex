# ~/.zshrc file for zsh interactive shells.
KEYTIMEOUT=1

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
bindkey -v                                        # emacs key bindings
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



# ---- VI keybinds for zsh ----


#2 ---- [viins-insert keybinds] ----

bindkey -M viins '^?' backward-delete-char



#2 END---- [viins-insert keybinds] ----



# -------------------------------------------------------------------
# ZSH VI-MODE CURSOR AND PROMPT INDICATOR (Final Architecture)
# -------------------------------------------------------------------

# -------------------------------------------------------------------
# ZSH VI-MODE: The Final and Correct Architecture
# -------------------------------------------------------------------

# END----# -------------------------------------------------------------------
# ZSH VI-MODE: The Final and Correct Architecture
# -------------------------------------------------------------------

# We must explicitly load the hook function system first.
autoload -U add-zsh-hook

# --- PART 1: The Foundation (Handles I/N modes) ---
_update_prompt_and_cursor_interactively() {
    case $KEYMAP in
      vicmd)
        if (( REGION_ACTIVE )); then
          PROMPT_INDICATOR="%F{magenta}[V] "
        else
          PROMPT_INDICATOR="%F{yellow}[N] "
        fi
        echo -ne '\e[2 q'
        ;;
      viins|main)
        PROMPT_INDICATOR="%F{cyan}[I] "
        echo -ne '\e[6 q'
        ;;
    esac
    zle .reset-prompt
}
zle -N zle-keymap-select _update_prompt_and_cursor_interactively

# --- PART 2: The "New Line" Logic ---
_set_prompt_for_new_line() {
    PROMPT_INDICATOR="%F{cyan}[I] "
    echo -ne '\e[6 q'
}
zle -N zle-line-init _set_prompt_for_new_line
add-zsh-hook precmd _set_prompt_for_new_line

# --- PART 3: Targeted "Scalpel" Widgets and Bindings ---

# WIDGET 1: Hijacks 'v' in Normal mode for instant [V] indicator.
_enter_visual_mode_and_update_prompt() {
  zle .visual-mode
  _update_prompt_and_cursor_interactively
}
zle -N _enter_visual_mode_and_update_prompt
bindkey -M vicmd 'v' _enter_visual_mode_and_update_prompt

# WIDGET 2 (NEW): Hijacks 'Esc' in Visual mode to exit and update.
_exit_visual_mode_and_update_prompt() {
  zle .deactivate-region
  _update_prompt_and_cursor_interactively
}
zle -N _exit_visual_mode_and_update_prompt
# Note: '^[' is the correct representation for the Escape key.
bindkey -M visual '^[' _exit_visual_mode_and_update_prompt

# WIDGET 3 (NEW): Hijacks 'y' in Visual mode to yank, exit, and update.
_yank_and_exit_visual_mode() {
  zle .vi-yank
  _update_prompt_and_cursor_interactively
}
zle -N _yank_and_exit_visual_mode
bindkey -M visual 'y' _yank_and_exit_visual_mode

# WIDGET 4 (NEW): Hijacks 'd' in Visual mode to delete, exit, and update.
_delete_and_exit_visual_mode() {
  zle .kill-region
  _update_prompt_and_cursor_interactively
}
zle -N _delete_and_exit_visual_mode
bindkey -M visual 'd' _delete_and_exit_visual_mode


_paste_and_exit_visual_mode() {
  zle .put-replace-selection # The perfect widget from your test
  _update_prompt_and_cursor_interactively
}
zle -N _paste_and_exit_visual_mode
bindkey -M visual 'p' _paste_and_exit_visual_mode

# Your original keybinding for 'jjk' escape.
_vim_jjk_escape() {
  if [[ ${LBUFFER[-2,-1]} == 'jj' ]]; then
    LBUFFER=${LBUFFER%jj}
    zle vi-cmd-mode
  else
    zle self-insert
  fi
}
zle -N _vim_jjk_escape
bindkey -M viins 'k' _vim_jjk_escape

# END---- VI keybinds for zsh END---- VI keybinds for zsh END----











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

zle_highlight=(
    'default:none'
  'visual:bg=white,fg=black'
  # 'region:bg=#44475a'
  # 'region:bg=#44475a,fg=#f8f8f2'
  # 'region:bg=#44475a,underline'
  'region:bold,underline'
  # 'region:bold'
  'special:bg=red,fg=white'
  'isearch:bg=green,fg=black,bold'
)

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

    # alias ]timer='date "+%T %d-%m"; echo " " ;start=$(date +%s); while true; do current=$(date +%s); elapsed=$((current - start)); printf "\r%02d:%02d" $((elapsed/60)) $((elapsed%60)); sleep 1; done' # Use nano if you prefer: alias nanc='nano ~/.zshrc'


    # ---- Time  END----





    
    alias msgbox='zenity' # The space at the end tells the shell to perfom alias expansion on the word following sudo
    alias sudo='sudo ' # The space at the end tells the shell to perfom alias expansion on the word following sudo
    alias ob='obsidian-cli' # https://github.com/Yakitrak/obsidian-cli make sure you have this. really useful
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
    alias src='source ~/.zshrc'
    alias md='mkdir -p' # Use nano if you prefer: alias nanc='nano ~/.zshrc'
    alias nvrc='nvim ~/.zshrc' # Use nano if you prefer: alias nanc='nano ~/.zshrc'
    alias ]xnv='xset r rate 178 63;xset q | grep delay'
    alias ]xnv2='xset r rate 173 66;xset q | grep delay'
    alias ]xset='xset r rate 180 60;xset q | grep delay'
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
	alias ]e.nv='nvim ~/.config/nvim/init.vim'
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
source <(fzf --zsh)

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

# Smart "fzf open" function
# - If the selected file is text-based, opens it in Neovim (in a new Kitty window).
# - Otherwise, opens it with the default GUI application (like Dolphin, Gwenview, etc).
fo() {
  # 1. Use 'local' to keep variables from polluting your shell.
  local file
  local mime_type

  # 2. Find a file using fzf.
  file=$(fd --hidden --type file . | fzf --height 60% --reverse)

  # 3. Check if a file was actually selected (the user didn't press Esc).
  if [[ -n "$file" ]]; then
    # 4. THE MAGIC: Use the `file` command to get the MIME type.
    #    --brief hides the filename, --mime-type gives output like "text/plain".
    mime_type=$(file --brief --mime-type "$file")

    # 5. THE DECISION: Check if the MIME type starts with "text/".
    if [[ "$mime_type" == text/* ]]; then
      echo "Opening text file in Neovim: $file"
      # This matches the command from your .desktop file.
      kitty -e nvim "$file"
    else
      echo "Opening with default app: $file"
      # Use xdg-open for non-text files (images, PDFs, videos...).
      # '&> /dev/null' hides any output from the GUI app in your terminal.
      xdg-open "$file" &> /dev/null
    fi
  fi
}


pw() {
  # Check for tools
  if ! command -v sushi &> /dev/null || ! command -v xdotool &> /dev/null || ! command -v wmctrl &> /dev/null; then
    echo "Error: Missing required tools." >&2; return 1;
  fi

  local sushi_class="Org.gnome.NautilusPreviewer"

  # Find an item
  local item
  item=$(fd --hidden . | fzf --height 60% --reverse)

  if [[ -n "$item" ]]; then
    # --- MONITOR-AWARE LOGIC ---
    eval "$(xdotool getmouselocation --shell)"
    local current_mouse_x=$X
    local original_mouse_y=$Y

    local target_center_x
    local target_center_y

    # Use your tested, hardcoded coordinates
    if [[ "$current_mouse_x" -lt 1920 ]]; then
      target_center_x=828
      target_center_y=551
    else
      target_center_x=2567
      target_center_y=370
    fi

    # Launch sushi
    sushi "$item" &

    # Poll for the window ID to know when it's ready
    local sushi_window_id=""
    local -i maxtries=50; local -i count=0
    while [[ -z "$sushi_window_id" && "$count" -lt "$maxtries" ]]; do
      sushi_window_id=$(xdotool search --class "$sushi_class" | tail -1)
      sleep 0.1
      ((count++))
    done

    # If the window appeared...
    if [[ -n "$sushi_window_id" ]]; then
      # STEP 1: FOCUS THE WINDOW
      # Move mouse, click to focus, and move back instantly.
      sleep 0.1
      xdotool mousemove "$target_center_x" "$target_center_y" click 1 mousemove "$current_mouse_x" "$original_mouse_y"

      # STEP 2: ADD "ALWAYS ON TOP"
      # This is the part from your inspiration. We target the window that
      # is now ":ACTIVE:" because of our click.
      sleep 0.1
      wmctrl -r :ACTIVE: -b add,above

    else
      echo "Error: Timed out waiting for the sushi window." >&2
    fi
  fi
}

# ---------- simple fzf preview setup template------------- 
# fp() {
#   local missing_tools=()
#   command -v exa &>/dev/null || missing_tools+=('exa')
#   command -v bat &>/dev/null || missing_tools+=('bat')
#   command -v chafa &>/dev/null || missing_tools+=('chafa')
#   command -v pdftotext &>/dev/null || missing_tools+=('poppler')
#   command -v mediainfo &>/dev/null || missing_tools+=('mediainfo')
#   if ((${#missing_tools[@]} > 0)); then
#     echo "Missing tools: ${missing_tools[*]}" >&2
#     return 1
#   fi

#   fd --hidden . | fzf --height 80% --layout=reverse --border \
#     --preview-window 'right:50%:wrap' \
#     --preview 'sh -c "
#       file_path=\"\$1\"
#       # Calculate preview window dimensions (approximate)
#       width=\$(( \$(tput cols 2>/dev/null || echo 80) / 2 ))
#       height=\$(( \$(tput lines 2>/dev/null || echo 25) * 7 / 10 ))

#       if [ -d \"\$file_path\" ]; then
#         exa --tree --color=always \"\$file_path\" | head -200
#       else
#         mime_type=\$(file --brief --mime-type \"\$file_path\")
#         case \"\$mime_type\" in
#           image/*)
#             # Adjust dimensions for better fit
#             width=\$(( width - 2 ))  # Account for borders
#             height=\$(( height - 2 ))
#             # Set minimum dimensions
#             [ \$width -lt 20 ] && width=20
#             [ \$height -lt 10 ] && height=10
#             chafa \
#               -f symbols \
#               --fg-only \
#               --optimize=4 \
#               --scale-method=fit \
#               -s \${width}x\${height} \
#               --animate off \
#               \"\$file_path\"
#             echo \"\nFile: \$file_path\"
#             file \"\$file_path\"
#               kk ;;
#           application/pdf)
#             pdftotext \"\$file_path\" - | head -200
#             ;;
#           video/*|audio/*)
#             mediainfo \"\$file_path\"
#             ;;
#           text/*)
#             bat --color=always --style=numbers --line-range=:200 \"\$file_path\"
#             ;;
#           *)
#             file \"\$file_path\"
#             ;;
#         esac
#       fi
#     " sh {}'
# }

# ---------- simple fzf preview setup template END------------- 



# --- myfuncs - my functions - functions ---------


fp.scuffed.video.preview() {
  local missing_tools=()
  command -v exa &>/dev/null || missing_tools+=('exa')
  command -v bat &>/dev/null || missing_tools+=('bat')
  command -v timg &>/dev/null || missing_tools+=('timg')
  command -v pdftotext &>/dev/null || missing_tools+=('poppler')
  command -v mediainfo &>/dev/null || missing_tools+=('mediainfo')
  if ((${#missing_tools[@]} > 0)); then
    echo "Missing tools: ${missing_tools[*]}" >&2
    return 1
  fi

  fd --hidden . | fzf --height 80% --layout=reverse --border \
    --preview-window 'right:50%:wrap' \
    --preview 'sh -c "
      file_path=\"\$1\"
      width=\$(( \$(tput cols 2>/dev/null || echo 80) / 2 - 2 ))
      height=\$(( \$(tput lines 2>/dev/null || echo 25) / 2 ))

      if [ -d \"\$file_path\" ]; then
        exa --tree --color=always \"\$file_path\" | head -200
      else
        mime_type=\$(file --brief --mime-type \"\$file_path\")
        case \"\$mime_type\" in
          image/*)
            echo \"📷 \$(basename \"\$file_path\")\"
            echo \"\"
            if [ \"\$TERM\" = \"xterm-kitty\" ]; then
              timg -pk --compress=0 -g \${width}x\${height} --center \"\$file_path\" 2>/dev/null
            else
              timg -ps -g \${width}x\${height} --center \"\$file_path\" 2>/dev/null
            fi
            ;;
          video/*)
            echo \"🎬 \$(basename \"\$file_path\")\"
            echo \"\"
            echo \"\"
            echo \"\"
            
            if command -v ffmpeg &>/dev/null; then
              temp_dir=\"/tmp/fpp_frames_\$\$\"
              mkdir -p \"\$temp_dir\"
              
              # Extract frames quickly
              for i in 1 2 3 4 5; do
                time_point=\$((i * 2))
                frame_file=\"\$temp_dir/frame_\${i}.jpg\"
                ffmpeg -ss \$time_point -i \"\$file_path\" -vframes 1 -q:v 2 -s 800x600 -preset ultrafast -y \"\$frame_file\" 2>/dev/null &
              done
              wait
              
              # Position cursor for stationary animation
              echo \"\"
              
              # Loop slideshow
              while true; do
                for i in 1 2 3 4 5; do
                  frame_file=\"\$temp_dir/frame_\${i}.jpg\"
                  if [ -f \"\$frame_file\" ]; then
                    
                    # Move cursor back to image position
                    printf \"\\033[10A\"
                    
                    if [ \"\$TERM\" = \"xterm-kitty\" ]; then
                      timg -pk --compress=0 -g \${width}x\${height} --center \"\$frame_file\" 2>/dev/null
                    else
                      timg -ps -g \${width}x\${height} --center \"\$frame_file\" 2>/dev/null
                    fi
                    
                    sleep 0.6
                  fi
                done
              done &
              
              # Clean up after 30 seconds
              sleep 30
              kill \$! 2>/dev/null
              rm -rf \"\$temp_dir\" 2>/dev/null
            else
              echo \"Video preview unavailable\"
            fi
            ;;
          application/pdf)
            echo \"📄 \$(basename \"\$file_path\")\"
            echo \"---\"
            pdftotext \"\$file_path\" - 2>/dev/null | head -30 || echo \"PDF preview failed\"
            ;;
          audio/*)
            echo \"🎵 \$(basename \"\$file_path\")\"
            echo \"---\"
            mediainfo --Inform=\"General;Duration: %Duration/String%\\nBitrate: %BitRate/String%\\nFormat: %Format%\" \"\$file_path\" 2>/dev/null || \
            echo \"Audio info unavailable\"
            ;;
          text/*)
            bat --color=always --style=numbers --line-range=:30 \"\$file_path\" 2>/dev/null || \
            cat \"\$file_path\" | head -30
            ;;
          *)
            file \"\$file_path\"
            ;;
        esac
      fi
    " sh {}'
}

fp() {
  # This part is unchanged
  local missing_tools=()
  command -v exa &>/dev/null || missing_tools+=('exa')
  command -v bat &>/dev/null || missing_tools+=('bat')
  command -v timg &>/dev/null || missing_tools+=('timg')
  command -v pdftotext &>/dev/null || missing_tools+=('poppler')
  command -v mediainfo &>/dev/null || missing_tools+=('mediainfo')
  if ((${#missing_tools[@]} > 0)); then
    echo "Missing tools: ${missing_tools[*]}" >&2
    return 1
  fi

  # This is the fzf command with the modified preview script
  fd --hidden . | fzf --height 80% --layout=reverse --border \
    --preview-window 'right:50%:wrap' \
    --bind '?:toggle-preview' \
    --preview 'sh -c "
      # --- START OF DEBUG MODIFICATIONS ---
      DEBUG_LOG=\"/tmp/fzf_debug.log\"
      echo \"--- New Preview Run ---\" >> \"\$DEBUG_LOG\"
      echo \"File: \$1\" >> \"\$DEBUG_LOG\"
      echo \"TERM variable is: [\$TERM]\" >> \"\$DEBUG_LOG\"
      # --- END OF DEBUG MODIFICATIONS ---

      printf \"\033[2J\"
      
      file_path=\"\$1\"
      width=\$(( \$(tput cols 2>/dev/null || echo 80) / 2 ))
      height=\$(( \$(tput lines 2>/dev/null || echo 25) * 7 / 10 ))

      is_graphics_term=false
      if [[ \"\$TERM\" == \"xterm-kitty\" || \"\$TERM\" == \"xterm-ghostty\" ]]; then
        is_graphics_term=true
      fi

      # --- MORE DEBUGGING ---
      echo \"is_graphics_term evaluated to: [\$is_graphics_term]\" >> \"\$DEBUG_LOG\"

      if [ \"\$is_graphics_term\" = true ]; then
        echo \"ATTEMPTING to run clear command.\" >> \"\$DEBUG_LOG\"
        printf \"\033_Ga=d\033\\\\\"
      else
        echo \"SKIPPING clear command.\" >> \"\$DEBUG_LOG\"
      fi

      # The rest of the script is the same
      if [ -d \"\$file_path\" ]; then
        exa --tree --color=always \"\$file_path\" | head -200
      else
        mime_type=\$(file --brief --mime-type \"\$file_path\")
        case \"\$mime_type\" in
          image/*)
            # This part is unchanged...
            img_width=\$(( width - 2 ))
            img_height=\$(( height - 4 ))
            [ \$img_height -lt 10 ] && img_height=10
            [ \$img_width -lt 20 ] && img_width=20
            echo \"File: \$file_path\"; file \"\$file_path\"; echo \"---\"
            if [ \"\$is_graphics_term\" = true ] && command -v kitty &>/dev/null; then
              kitty +kitten icat --transfer-mode=memory --stdin=no \
                --place=\${img_width}x\${img_height}@0x3 \"\$file_path\" 2>/dev/null
            elif timg -pk --center -g \${img_width}x\${img_height} \"\$file_path\" 2>/dev/null; then
              :
            else
              echo \"Preview unavailable.\"; file \"\$file_path\"; identify \"\$file_path\" 2>/dev/null || true
            fi
            ;;
          *) # Simplified the rest for clarity, it does not affect the image part
            bat --color=always --style=numbers --line-range=:200 \"\$file_path\" || file \"\$file_path\"
            ;;
        esac
      fi
    " sh {}'
}

fpp() {
  # Tool check remains the same
  local missing_tools=()
  command -v exa &>/dev/null || missing_tools+=('exa')
  command -v bat &>/dev/null || missing_tools+=('bat')
  command -v timg &>/dev/null || missing_tools+=('timg')
  command -v pdftotext &>/dev/null || missing_tools+=('poppler')
  command -v mediainfo &>/dev/null || missing_tools+=('mediainfo')
  if ((${#missing_tools[@]} > 0)); then
    echo "Missing tools: ${missing_tools[*]}" >&2
    return 1
  fi

  fd --hidden . | fzf --height 80% --layout=reverse --border \
    --preview-window 'right:50%:wrap' \
    --bind '?:toggle-preview' \
    --preview 'sh -c "
      file_path=\"\$1\"
      width=\$(( \$(tput cols 2>/dev/null || echo 80) / 2 ))
      height=\$(( \$(tput lines 2>/dev/null || echo 25) * 7 / 10 ))
      img_width=\$(( width - 2 ))
      img_height=\$(( height - 4 ))
      [ \$img_height -lt 10 ] && img_height=10
      [ \$img_width -lt 20 ] && img_width=20

      # Terminal capability detection
      if [[ \"$TERM\" == \"xterm-kitty\"* ]] && command -v kitty &>/dev/null; then
        # Kitty terminal with graphics support
        printf \"\033[2J\033_Ga=d\033\\\\\"
        if [ -d \"\$file_path\" ]; then
          exa --tree --color=always \"\$file_path\" | head -200
        else
          mime_type=\$(file --brief --mime-type \"\$file_path\")
          case \"\$mime_type\" in
            image/*)
              echo \"File: \$file_path\"; file \"\$file_path\"; echo \"---\"
              kitty +kitten icat --transfer-mode=memory --stdin=no \
                --place=\${img_width}x\${img_height}@0x3 \"\$file_path\" 2>/dev/null
              ;;
            *) bat --color=always --style=numbers --line-range=:200 \"\$file_path\" || file \"\$file_path\" ;;
          esac
        fi
      elif [[ \"$TERM\" == \"xterm-ghostty\"* ]] || [[ \"$TERM\" == \"alacritty\"* ]]; then
        # Ghostty or Alacritty - use timg with different flags
        printf \"\033[2J\"
        if [ -d \"\$file_path\" ]; then
          exa --tree --color=always \"\$file_path\" | head -200
        else
          mime_type=\$(file --brief --mime-type \"\$file_path\")
          case \"\$mime_type\" in
            image/*)
              echo \"File: \$file_path\"; file \"\$file_path\"; echo \"---\"
              if [[ \"$TERM\" == \"alacritty\"* ]]; then
                # Special flags for Alacritty
                timg -p --center -g \${img_width}x\${img_height} \"\$file_path\" 2>/dev/null || \
                  echo \"Preview unavailable.\"; file \"\$file_path\"
              else
                # Ghostty
                timg -pk --center -g \${img_width}x\${img_height} \"\$file_path\" 2>/dev/null || \
                  echo \"Preview unavailable.\"; file \"\$file_path\"
              fi
              ;;
            *) bat --color=always --style=numbers --line-range=:200 \"\$file_path\" || file \"\$file_path\" ;;
          esac
        fi
      else
        # Fallback for other terminals
        printf \"\033[2J\"
        if [ -d \"\$file_path\" ]; then
          exa --tree --color=always \"\$file_path\" | head -200
        else
          mime_type=\$(file --brief --mime-type \"\$file_path\")
          case \"\$mime_type\" in
            image/*)
              echo \"File: \$file_path\"; file \"\$file_path\"; echo \"---\"
              timg -p --center -g \${img_width}x\${img_height} \"\$file_path\" 2>/dev/null || \
                echo \"Preview unavailable.\"; file \"\$file_path\"
              ;;
            *) bat --color=always --style=numbers --line-range=:200 \"\$file_path\" || file \"\$file_path\" ;;
          esac
        fi
      fi
    " sh {}'
}

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

  # Loop forever until you press Ctrl+C
  while true; do
    # Get the current time and calculate total elapsed seconds
    local current=$(date +%s)
    local elapsed=$((current - start))

    # Calculate hours, minutes, and seconds from total elapsed seconds
    local hours=$((elapsed / 3600))
    local mins=$(((elapsed / 60) % 60))
    local secs=$((elapsed % 60))

    # Print the formatted time, using \r to return to the start of the line
    printf "\r%02d:%02d:%02d" $hours $mins $secs

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


eval $(keychain --eval --quiet id_ed25519)
eval $(keychain --eval --quiet ssh)
