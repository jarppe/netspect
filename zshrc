#
# .zshrc
#

autoload -U compinit && compinit
autoload -U colors && colors
autoload -U promptinit && promptinit

bindkey -v

# Ctrl + left/right
bindkey '^[[1;5D' backward-word
bindkey '^[[1;5C' forward-word

# Search history
bindkey '^R' history-incremental-search-backward

#typeset -ga preexec_functions
#typeset -ga precmd_functions
#typeset -ga chpwd_functions

setopt pushdsilent
setopt pushdtohome
setopt prompt_subst
unsetopt share_history

MN="[$(hostname)]"
PS1="%{$fg_bold[white]%}${MN}%~>%{$reset_color%} "

alias l='exa'
alias ll='exa -l'
alias lll='exa -la'
alias m=less
alias cd=pushd
alias dc=docker-compose
alias which='alias | /usr/bin/which --tty-only --read-alias --show-dot --show-tilde'

eval "$(direnv hook zsh)"

source <(kubectl completion zsh)
alias k=kubectl
complete -F __start_kubectl k
