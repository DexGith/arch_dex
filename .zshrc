# ~/.zshrc file for zsh interactive shells.

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
bindkey ' ' magic-space                           # do history expansion on space
bindkey -r '^S'					  # Unbinding Ctrl+s (forward-i-search) this way stty -ixon works fine
bindkey '^U' backward-kill-line                   # ctrl + U
bindkey '^[[3;5~' kill-word                       # ctrl + Supr
bindkey '^[[3~' delete-char                       # delete
bindkey '^[[1;5C' forward-word                    # ctrl + ->
bindkey '^[[1;5D' backward-word                   # ctrl + <-
bindkey '^[[5~' beginning-of-buffer-or-history    # page up
bindkey '^[[6~' end-of-buffer-or-history          # page down
bindkey '^[[H' beginning-of-line                  # home
bindkey '^[[F' end-of-line                        # end
bindkey '^[[Z' undo                               # shift + tab undo last action

# enable completion features
autoload -Uz compinit
compinit -U -d ~/.cache/zcompdump # -U for security, -d to specify dump file
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
            PROMPT=$'%F{%(#.blue.green)}┌──${debian_chroot:+($debian_chroot)─}${VIRTUAL_ENV:+($(basename $VIRTUAL_ENV))─}(%B%F{%(#.red.blue)}%n'$prompt_symbol$'%m%b%F{%(#.blue.green)})-[%B%F{reset}%(6~.%-1~/…/%4~.%5~)%b%F{%(#.blue.green)}]\n└─%B%(#.%F{red}#.%F{blue}$)%b%F{reset} '
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
        ZSH_HIGHLIGHT_STYLES[comment]=fg=black,bold
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

precmd() {
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

# enable color support of ls, less and man, and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    #alias dir='dir --color=auto' # Usually covered by ls
    #alias vdir='vdir --color=auto' # Usually covered by ls -l
	export LS_COLORS="$LS_COLORS:ow=30;44:" # fix ls color for folders with 777 permissions
	export PATH="$PATH:/home/dex/.local/bin"
	export PATH="$PATH:/home/dex/.cargo/bin/"
	export EDITOR=nvim # this is so that visudo works i guess, you can specify any EDITOR or before visudo type EDITOR=.... to like you know change the env var and what not... you got the idea
	export MANPAGER='nvim +Man!'
	export PATH="$PATH:/home/dex/scripts/ddesk/:/home/dex/scripts/ddesk/[:/home/dex/scripts/ddesk/]:/home/dex/scripts/ddesk/]]:/home/dex/scripts/ddesk/nothing"
        export QT_QPA_PLATFORMTHEME=qt6ct
	# ---- export for python versions pyenv ----

	export PATH="$PYENV_ROOT/bin:$PATH"
	export PYENV_ROOT="$HOME/.pyenv"
	eval "$(pyenv init --path)"
	eval "$(pyenv init -)"


	# ---- export for python versions pyenv end----







    alias cdfp='cd $(dirname "$(fp)")' # Use nano if you prefer: alias nanc='nano ~/.zshrc'
    alias nv='nvim' # Use nano if you prefer: alias nanc='nano ~/.zshrc'
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
#             ;;
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

