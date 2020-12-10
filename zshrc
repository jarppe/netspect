#
# .zshrc
#

autoload -U compinit && compinit
autoload -U colors && colors
autoload -U promptinit && promptinit
autoload bashcompinit && bashcompinit

bindkey -v

# Ctrl + left/right
bindkey '^[[1;5D' backward-word
bindkey '^[[1;5C' forward-word

# Search history
bindkey '^R' history-incremental-search-backward

setopt pushdsilent
setopt pushdtohome
setopt prompt_subst
unsetopt share_history

MN="[$(hostname)]"
PS1="%{$fg_bold[white]%}[netspect]%~>%{$reset_color%} "

# direnv
eval "$(direnv hook zsh)"

# kubectl
source <(kubectl completion zsh)
alias k=kubectl
complete -F __start_kubectl k

# GCP CLI
source /usr/share/google-cloud-sdk/completion.zsh.inc

# AWS CLI
complete -C '/usr/local/bin/aws_completer' aws

# Some aliases:

alias l='exa'
alias ll='exa -l'
alias lll='exa -la'
alias m=less
alias cd=pushd
alias dc=docker-compose
alias which='alias | /usr/bin/which --tty-only --read-alias --show-dot --show-tilde'
