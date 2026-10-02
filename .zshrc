#!/usr/bin/env zsh

# ===== CORE =====
[[ $- != *i* ]] && return

# ===== HOMEBREW =====
if [[ -x /opt/homebrew/bin/brew ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
elif [[ -x /usr/local/bin/brew ]]; then
  eval "$(/usr/local/bin/brew shellenv)"
fi

# ===== ENV =====
export EDITOR='nvim'
export VISUAL='nvim'
export BAT_THEME='OneHalfDark'

export LS_COLORS='di=34;1:ln=35;1:so=32;1:pi=33;1:ex=31;1:bd=34;1:cd=34;1:su=30;41:sg=30;46:tw=30;42:ow=30;43'

# ===== PROMPT =====
PROMPT='%F{#5FD7FF}%1~%f %F{#00AF87}❯%f '

# ===== HISTORY =====
HISTFILE="$HOME/.zsh_history"
HISTSIZE=10000
SAVEHIST=10000

setopt APPEND_HISTORY
setopt SHARE_HISTORY
setopt HIST_IGNORE_SPACE
setopt HIST_IGNORE_DUPS
setopt HIST_FIND_NO_DUPS

# ===== ZINIT =====
export XDG_DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"
ZINIT_HOME="$XDG_DATA_HOME/zinit/zinit.git"

if [[ ! -f "$ZINIT_HOME/zinit.zsh" ]]; then
  mkdir -p "$(dirname "$ZINIT_HOME")"
  git clone --depth=1 \
    https://github.com/zdharma-continuum/zinit.git \
    "$ZINIT_HOME"
fi

source "$ZINIT_HOME/zinit.zsh"

# ===== COMPLETION =====
zinit light zsh-users/zsh-completions

autoload -Uz compinit
compinit

zstyle ':completion:*' menu no
zstyle ':completion:*' matcher-list \
  'm:{a-zA-Z}={A-Za-z}' \
  'r:|[._-]=* r:|=*'

zstyle ':completion:*' group-name ''
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}

# ===== FZF-TAB =====
zinit light Aloxaf/fzf-tab

zstyle ':fzf-tab:*' switch-group '<' '>'
zstyle ':fzf-tab:*' fzf-flags --height=60% --layout=reverse

# Directory preview
zstyle ':fzf-tab:complete:cd:*' \
  fzf-preview 'eza --all --color=always --icons "$realpath" 2>/dev/null || ls -la "$realpath"'

# zoxide directory preview
zstyle ':fzf-tab:complete:__zoxide_z:*' \
  fzf-preview 'eza --all --color=always --icons "$realpath" 2>/dev/null || ls -la "$realpath"'

# ===== AUTOSUGGESTIONS =====
ZSH_AUTOSUGGEST_STRATEGY=(history completion)
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=244'

zinit light zsh-users/zsh-autosuggestions

# ===== HISTORY SEARCH =====
zinit light zsh-users/zsh-history-substring-search

bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down

# ===== AUTO NOTIFY =====
AUTO_NOTIFY_THRESHOLD=30

zinit light MichaelAquilina/zsh-auto-notify

# ===== OMZ PLUGINS =====
zinit snippet OMZP::git
zinit snippet OMZP::sudo
zinit snippet OMZP::extract
zinit snippet OMZP::copyfile
zinit snippet OMZP::copypath

# ===== ALIASES =====
alias v='nvim'
alias g='git'

alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'

alias ls='eza --group-directories-first --icons'
alias ll='eza -lah --git --group-directories-first --icons'
alias lt='eza -T --git-ignore --icons'

# ===== ZOXIDE =====
if command -v zoxide >/dev/null 2>&1; then
  eval "$(zoxide init zsh)"
fi

# ===== DIRENV =====
if command -v direnv >/dev/null 2>&1; then
  eval "$(direnv hook zsh)"
fi

# ===== FZF =====
if command -v fzf >/dev/null 2>&1; then
  source <(fzf --zsh)

  export FZF_DEFAULT_OPTS="
    --height=60%
    --layout=reverse
    --border
    --info=inline
  "

  if command -v fd >/dev/null 2>&1; then
    export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
    export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
  fi
fi

# ===== KEYBINDINGS =====

# Tab -> interactive completion
bindkey '^I' fzf-tab-complete

# Right arrow -> accept autosuggestion
bindkey '^[[C' forward-char

# ===== SYNTAX HIGHLIGHTING =====
# Keep this last.
zinit light zsh-users/zsh-syntax-highlighting
