if [ "$TMUX" == "" ]; then
    tmux
fi

alias ll='ls -l'
alias vi='vim'

function f() {
    find . -name "*${1}*"
}

git_color()
{
    local git_status="$(git status 2> /dev/null)"

    if [[ $git_status =~ "Changes to be committed" ]]; then
        echo -e "\033[0;32m" # green
    elif [[ $git_status =~ "have diverged" ]]; then
        echo -e "\033[0;37m" # gray
    elif [[ $git_status =~ "Your branch is ahead of" ]]; then
        echo -e "\033[0;37m" # gray
    elif [[ ! $git_status =~ "working tree clean" ]]; then
        echo -e "\033[0;31m" # red
    elif [[ $git_status =~ "nothing to commit" ]]; then
        echo -e "\033[0;34m" # blue
    else
        echo -e "\033[0;33m" # yellow
    fi
}

git_prompt()
{
    echo "\$(git_color)"'$(__git_ps1)'
}

set_prompt()
{
    PS1='\[\e]0;\w\a\]\n\[\e[32m\]\u@\h \[\e[33m\]\w \[\e[34m\]'
    PS1+="$(git_prompt)"
    PS1+='\n\[\e[0m\]o/ '

    export PS1
}

#export TERM=xterm-256color

export EDITOR=/usr/local/bin/vim
export PATH=~/environment/bin:/opt/local/bin:$PATH

source ~/environment/scripts/git-completion.bash
source ~/environment/scripts/git-prompt.sh

if [ -f ~/environment/extra/bashrc ]; then
    source ~/environment/extra/bashrc
fi

alias notecheck=checknotes
alias workcheck=checkwork

alias gcrev='git commit -m"Code review"'
alias gcam='git commit --amend'
alias gcwip='git commit -m"WIP"'
alias gc='git commit'
alias gt='git t'
alias gs='git s'

set_prompt
