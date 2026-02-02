if [ "$TMUX" == "" ] && [ "$TERM_PROGRAM" != "vscode" ]; then
    tmux
fi

export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

alias ls='ls -G'
alias ll='ls -l'
alias vi='nvim -u ~/.vimrc'
alias vim='nvim -u ~/.vimrc'
alias cdf='cd `dirname $(fzf)`'
alias cdw="cd /Users/$USER/work/\`find ~/work/ -maxdepth 3 | sed \"s/\\/Users\\/$USER\\/work\\///g\" | fzf\`"
alias cdd="cd \`find . -maxdepth 3 | sed \"s/\\/Users\\/$USER\\/work\\///g\" | fzf\`"

function f() {
    find . -name "*${1}*"
}

name_window()
{
    export TPREFIX="$1"
    tmux rename-window "$TPREFIX"
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

git_prompt() {
    echo "\$(git_color)"'$(__git_ps1)'
}

get_prefix() {
    echo "\033[0;35m "'[$TPREFIX]'
}

set_prompt() {
    PS1='\[\e]0;\w\a\]\n\[\e[32m\]\u@\h \[\e[33m\]\w \[\e[34m\]'
    PS1+="$(git_prompt)"
    PS1+="$(get_prefix)"
    PS1+='\n\[\e[0m\]'
    PS1+='o/ '

    export PS1
}

ps1_simple_version() {
    PS1='\[\e]0;\w\a\]\n\[\e[32m\]\u@\h \[\e[33m\]\w \[\e[34m\]'
    PS1+='\n\[\e[0m\]o/ '

    export PS1
}

function virg() {
    files="`rg "$1" -l`"
    vi -p $files
}


#export TERM=xterm-256color

export EDITOR=/usr/local/bin/vim
export PATH=~/environment/bin:/opt/local/bin:~/bin:$PATH

source ~/environment/scripts/git-completion.bash
source ~/environment/scripts/git-prompt.sh

if [ -f ~/environment/extra/bashrc ]; then
    source ~/environment/extra/bashrc
fi

alias notecheck=checknotes

function format_check()
{
    checknotes
    # echo "Do you want to run formatter? (y/N)"
    # read VALUE
    # case $VALUE in
    #     "Y" )
    #         formatter
    #         ;;
    #     "y" )
    #         formatter
    #         ;;
    # esac
    # echo
    # echo "--------------------------"
    git s; pause
    gitall
}

function push_check()
{ 
    BRANCH_NAME="$(git branch -vv | grep '^\*')"

    echo "${BRANCH_NAME}"
    echo "Push? (y/N)"
    read VALUE
    case $VALUE in
        "Y" )
            git push
            ;;
        "y" )
            git push
            ;;
    esac
}

# alias gmain='if grep -q "main" <<< "`git branch -r`" ; then echo "origin/main"; else echo "origin/master"; fi'
alias gc='format_check && git commit'
alias gcrev='gc -m"Code review" && push_check'
alias gcam='gtt -5 && gc --amend'
alias gcwip='git commit -m"WIP: $(git branch --show-current)"'
alias gcm='git commit -m'
alias gcfix='gc -m"Fix" && push_check'
alias gt='git t'
alias gtt='git t'
alias gs='git s'
alias grm='git fetch --all && git rebase --interactive `gmain`'
alias grd='git fetch --all && git rebase --interactive origin/develop'
alias gbm='git branch -a | grep marcos'
alias gocheck='goimports -w .; golint .'
alias greset='gcwip -a; git fetch --all && git reset --hard `gmain`'

function gtm()
{
    BRANCHES="$(git branch | awk '{ print $NF }')"
    gtt ${BRANCHES}
}

set_prompt

[ -f ~/.fzf.bash ] && source ~/.fzf.bash

export FZF_DEFAULT_COMMAND='rg --files .'
export HISTCONTROL=ignoredups

# Eternal bash history.
# ---------------------
# Undocumented feature which sets the size to "unlimited".
# http://stackoverflow.com/questions/9457233/unlimited-bash-history
export HISTFILESIZE=
export HISTSIZE=
export HISTTIMEFORMAT="[%F %T] "
# Change the file location because certain bash sessions truncate .bash_history file upon close.
# http://superuser.com/questions/575479/bash-history-truncated-to-500-lines-on-each-login
export HISTFILE=~/.bash_eternal_history
# Force prompt to write history after every command.
# http://superuser.com/questions/20900/bash-history-loss
PROMPT_COMMAND="history -a; $PROMPT_COMMAND"
