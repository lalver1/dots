# Setup prompt
source "/usr/lib/git-core/git-sh-prompt"
PS1="\[\033[32m\]\w\[\033[33m\]\$(GIT_PS1_SHOWUNTRACKEDFILES=1 GIT_PS1_SHOWDIRTYSTATE=1 __git_ps1)\[\033[00m\]\n$ "

# Aliases
alias lsa='ls -GFlah --color'