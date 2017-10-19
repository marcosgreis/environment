if [ "$TMUX" == "" ]; then
    tmux
fi

alias ll='ls -l'
alias f='find . -name'
alias vi='vim'

PS1='\[\e]0;\w\a\]\n\[\e[32m\]\u@\h \[\e[33m\]\w \[\e[34m\]$(__git_ps1)\n\[\e[0m\]o/ '

#export TERM=xterm-256color

export PATH=~/environment/bin:/opt/local/bin:$PATH

source ~/environment/scripts/git-completion.bash
source ~/environment/scripts/git-prompt.sh

if [ -f ~/environment/extra/bashrc ]; then
    source ~/environment/extra/bashrc
fi
