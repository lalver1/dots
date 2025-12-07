# Setup Homebrew
eval "$(/opt/homebrew/bin/brew shellenv)"

# Use pyenv
export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"

# Setup Ruby
source $(brew --prefix)/opt/chruby/share/chruby/chruby.sh
source $(brew --prefix)/opt/chruby/share/chruby/auto.sh
chruby ruby-3.1.3

# Use Rust
[ -f  "$HOME/.cargo/env" ] && . "$HOME/.cargo/env"

# Use Bash completion
source "${HOMEBREW_PREFIX}/etc/profile.d/bash_completion.sh"

# Setup prompt
source "${HOMEBREW_PREFIX}/Cellar/git/2.49.0/etc/bash_completion.d/git-prompt.sh"
PS1="\[\033[32m\]\w\[\033[33m\]\$(GIT_PS1_SHOWUNTRACKEDFILES=1 GIT_PS1_SHOWDIRTYSTATE=1 __git_ps1)\[\033[00m\]\n$ "

# Setup Starship prompt
#eval "$(starship init bash)"

# Aliases
alias lsa='ls -GFlah'

# Terraform
export PATH="$PATH:/Users/lalver1/bin"
