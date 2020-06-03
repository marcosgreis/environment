
## Imports
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

## EXPORTS
export EDITOR=/usr/local/bin/vim
export PATH=~/environment/bin:/opt/local/bin:~/bin:$PATH
export FZF_DEFAULT_COMMAND='rg --files .'
export HISTCONTROL=ignoredups

## FUNCTIONS
function f() {
    find . -name "*${1}*"
}

function virg() {
    files="`rg $1 -l`"
    vi -p $files
}

function format_check()
{
    checknotes
    echo "Do you want to run formatter? (y/N)"
    read VALUE
    case $VALUE in
        "Y" )
            formatter
            ;;
        "y" )
            formatter
            ;;
    esac
    echo
    echo "--------------------------"
    git s; read
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


## ALIASES
alias ls='ls -G'
alias ll='ls -l'
alias vi='nvim -u ~/.vimrc'

alias notecheck=checknotes
alias workcheck=checkwork

## Git
alias gc='format_check; git commit'
alias gcrev='gc -m"Code review"; push_check'
alias gcam='gc --amend'
alias gcwip='git commit -m"WIP"'
alias gcfix='gc -m"Fix"; push_check'
alias gt='git t'
alias gs='git s'
alias grm='git fetch --all; git rebase --interactive origin/master'
function gtm()
{
    BRANCHES="$(git branch | awk '{ print $NF }')"
    gt ${BRANCHES}
}

## PROMPT
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


source ~/environment/scripts/git-prompt.sh
FIRST_LINE="%F{green}%n@%m %F{yellow}%~ $(git_color)$(__git_ps1)"
SECOND_LINE="%F{none}o/ "
PROMPT=$'\n'"$FIRST_LINE"$'\n'"$SECOND_LINE"
