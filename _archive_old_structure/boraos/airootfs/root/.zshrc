# BoraOS 0.1 - Root User Zsh Configuration

# Enable Powerlevel10k instant prompt
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# History configuration
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt appendhistory

# Basic zsh options
setopt autocd
setopt extendedglob
setopt nomatch
setopt notify

# Auto-completion
autoload -Uz compinit
compinit

# Aliases
alias ls='lsd'
alias ll='lsd -lah'
alias la='lsd -a'
alias cat='bat'
alias grep='grep --color=auto'
alias df='df -h'
alias free='free -h'
alias vim='nvim'

# BoraOS specific aliases
alias install='archinstall'
alias start-hyprland='Hyprland'

# Welcome message for live environment
echo ""
echo "Welcome to BoraOS 0.1 Live Environment"
echo "Type 'archinstall' to begin installation"
echo ""
