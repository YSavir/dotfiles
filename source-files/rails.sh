alias rc='rails c'
alias rs='rails s'
alias rg='rails g'
alias rr='rake routes'
alias rt='rake -T'

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
  echo "...done"
  echo "creating database..."
  rake db:create
  echo "...done"
  echo "migrating database..."
  rake db:migrate
  echo "...done"
  echo "seeding database..."
  rake db:seed
  echo "...done"
  echo "Database reset"
}

mkdirView(){
  for dir in "$@"; do
    mkdir app/views/"$dir"
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
