#!/bin/zsh

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

# alias sf="docker-compose exec php bin/console"
# alias dc="docker-compose exec php composer"

# WSL specific things
if grep --quiet microsoft /proc/version 2>/dev/null; then
  alias idea="(pkill -f 'java.*idea' || true) && screen -d -m /opt/idea/bin/idea.sh"
  alias wslb="PowerShell.exe 'Start-Process PowerShell -Verb RunAs \"PowerShell -File \$env:USERPROFILE\\wsl2-bridge.ps1\"'"
  # alias dcs="sudo /etc/init.d/docker start"
fi

alias sz='exec zsh'     # Easily source your ~/.zshrc file.
alias ls='pwd; ls --color'     # Alias 'ls' to: pwd + ls + color.

# alias kill='sudo kill'  # promote kill to sudo kill
alias logmaas="code ~/.omw/output/1.0.0-9999-SNAPSHOT/deploy/"
alias loggateway="code ~/.omw/output/1.0.0-9999-SNAPSHOT/deploy/tomcat/gateway-tomcat/logs/"
alias c2s="omw build:config package:package deploy:deploy prepare:prepare start:start"
alias kgp="kubectl get pods"
alias kgs="kubectl get svc"
alias kgi="kubectl get ing"
alias kgd="kubectl get deployment"
alias updateomw="cd $MAAS_HOME/omw; zsh ./update.sh"
