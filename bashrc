if [ "$TMUX" == "" ] && [ "$TERM_PROGRAM" != "vscode" ]; then
    tmux
fi

alias ls='ls -G'
alias ll='ls -l'
alias vi='nvim -u ~/.vimrc'
alias vim='nvim -u ~/.vimrc'
alias cdf='cd `dirname $(fzf)`'

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

git_prompt() {
    echo "\$(git_color)"'$(__git_ps1)'
}

set_prompt() {
    PS1='\[\e]0;\w\a\]\n\[\e[32m\]\u@\h \[\e[33m\]\w \[\e[34m\]'
    PS1+="$(git_prompt)"
    PS1+='\n\[\e[0m\]o/ '

    export PS1
}

ps1_simple_version() {
    PS1='\[\e]0;\w\a\]\n\[\e[32m\]\u@\h \[\e[33m\]\w \[\e[34m\]'
    PS1+='\n\[\e[0m\]o/ '

    export PS1
}

function virg() {
    files="`rg $1 -l`"
    vi -p $files
}


#export TERM=xterm-256color

export EDITOR=/usr/local/bin/vim
export PATH=~/environment/bin:/opt/local/bin:~/bin:~/work/bin:$PATH

source ~/environment/scripts/git-completion.bash
source ~/environment/scripts/git-prompt.sh

source ~/.bazel/bin/bazel-complete.bash

if [ -f ~/environment/extra/bashrc ]; then
    source ~/environment/extra/bashrc
fi

alias notecheck=checknotes

function format_check()
{
    checknotes
    if [[ "$CLEANER" != "" ]]; then
        echo "cleaning..."
        $CLEANER
    fi
    if [[ "$FORMATTER" != "" ]]; then
        echo "formatting..."
        $FORMATTER
    else 
        echo -e "\033[0;31mFORMATTER NOT SET\033[0;00m"
    fi

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
alias gcam='gt -5 && gc --amend'
alias gcwip='git commit --no-verify -m"WIP: $(git branch --show-current)"'
alias gcm='git commit -m'
alias gcfix='gc -m"Fix" && push_check'
alias gt='git t'
alias gs='git s'
alias grm='git fetch --all && git rebase --interactive `gmain`'
alias grd='git fetch --all && git rebase --interactive origin/develop'
alias gbm='git branch -a | grep marcos'
alias gocheck='goimports -w .; golint .'
alias greset='gcwip -a; git fetch --all && git reset --hard `gmain`'

function gtm()
{
    BRANCHES="$(git branch | awk '{ print $NF }')"
    gt ${BRANCHES}
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
