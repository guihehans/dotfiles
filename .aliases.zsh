alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."

alias ls='ls -G'
if [[ $(uname) != "Darwin" ]]
then
  alias ls='ls --color=auto'
fi
alias lsa='ls -lah'
alias l='ls -lah'
alias ll='ls -lh'
alias la='ls -lAh'

alias grep="grep --color=auto --exclude-dir={.bzr,CVS,.git,.hg,.svn}"

alias sf="docker-compose exec php bin/console"
alias dc="docker-compose exec php composer"
