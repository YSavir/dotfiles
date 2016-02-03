alias rc='rails c'
alias rs='rails s'
alias trs='RAILS_ENV=test rs'
alias rg='rails g'

alias be="bundle exec"

alias rr='be rake routes'
alias rt='be rake -T'
alias jw='be rake jobs:work'
alias tjw='RAILS_ENV=test jw'

rSetup(){
  if [ -z $1 ]; then
    echo 'Error-- No name provided for Rails application'
    return 1
  fi
  rails new $1 -Td postgresql
}

resetDB(){
  echo "dropping database..."
  rake db:drop
  echo "creating database..."
  rake db:create
  echo "setting up database..."
  rake db:schema:load
  echo "seeding database..."
  rake db:seed
  echo "database has been reset"
}

mkdirView(){
  for dir in "$@"; do
    mkdir ./app/views/"$dir"
    echo "made directory app/views/$1"
  done
}

mkview(){
  view_dir=$1
  if [ ! -d "app/views/$1" ]; then
    mkdirView "$1"
  fi

  shift
  for view in "$@"; do
    touch app/views/"$view_dir"/"$view".html.erb;
    echo "creating view $view_dir/$view"
  done
}

compileTestTemplates() {
 handlebars app/assets/javascripts/templates/ -m -f test/indexes/javascripts/templates.js -n "HandlebarsTemplates" -e hbs 
}
