#!/usr/bin/env zsh

# ===== CORE SETUP =====
[[ $- != *i* ]] && return

# ===== HOME BREW =====
if [[ -x /opt/homebrew/bin/brew ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
elif [[ -x /usr/local/bin/brew ]]; then
  eval "$(/usr/local/bin/brew shellenv)"
fi

# ===== VISUAL DESIGN =====
PROMPT='%F{#5FD7FF}%1~%f %F{#00AF87}❯%f '
export LS_COLORS='di=34;1:ln=35;1:so=32;1:pi=33;1:ex=31;1:bd=34;1:cd=34;1:su=30;41:sg=30;46:tw=30;42:ow=30;43'
export BAT_THEME='OneHalfDark'

# ===== PLUGINS =====
() {
  local plugin_dir="${ZDOTDIR:-$HOME}/.zsh-plugins"
  local plugins=(
    zsh-users/zsh-autosuggestions
    zsh-users/zsh-syntax-highlighting 
    agkozak/zsh-z
    MichaelAquilina/zsh-auto-notify
  )

  mkdir -p "$plugin_dir"
  for plugin in "${plugins[@]}"; do
    local name=${plugin##*/}
    if [[ ! -d "$plugin_dir/$name" ]]; then
      git clone --depth=1 "https://github.com/$plugin" "$plugin_dir/$name" || continue
    fi
    source "$plugin_dir/$name/$name.zsh" 2>/dev/null
  done

  ZSH_AUTOSUGGEST_STRATEGY=(history completion)
  ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=244'
  AUTO_NOTIFY_THRESHOLD=30
}

# ===== ALIASES (UPDATED FOR EZA) =====
alias v='nvim'
alias g='git'
alias ..='cd ..'
alias ls='eza --group-directories-first --icons'       # Changed exa → eza
alias ll='eza -l --git --group-directories-first --icons'
alias lt='eza -T --git-ignore --icons'

# ===== HISTORY =====
HISTFILE=~/.zsh_history
HISTSIZE=9000
SAVEHIST=8000
setopt HIST_IGNORE_SPACE

# ===== COMPLETION =====
autoload -Uz compinit && compinit
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'

# ===== TOOLS =====
export EDITOR='nvim'
export VISUAL='nvim'
eval "$(zoxide init zsh)"
eval "$(direnv hook zsh)"
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh