export PG_USER='Yaniv'
###use <%= ENV['PG_USER'] %> to access

export APP_ENV="development"

alias serveThis='ruby -run -e httpd . -p 9090'

### EDITOR
#export EDITOR="/usr/bin/vim"

### RBENV

export RBENV_ROOT="${HOME}/.rebenv"

if [ -d $RBENV_ROOT ]; then
  export PATH="${RBENV_ROOT}/bin:${PATH}"
  eval "$(rbenv init -)"
fi
  
