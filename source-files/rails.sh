alias rc='./bin/rails c'
alias bd='./bin/dev'
alias rs='./bin/rails s'
alias trs='RAILS_ENV=test bundle exec ./bin/rails s'
alias tjw='RAILS_ENV=test bundle exec rake jobs:work'
alias rg='rails g'
alias wds='./bin/webpack-dev-server'
alias fs="foreman start -f Procfile.dev"

alias lwds="NODE_OPTIONS=--openssl-legacy-provider ./bin/webpack-dev-server"

alias be="bundle exec"

alias rr='be ./bin/rails routes'
alias rt='be rake -T'
alias jw='be rake jobs:work'
alias tjw='RAILS_ENV=test jw'
alias rfd="be rake db:reset_with_fake_data"

pgrm() {
  pg_restore $1 -d mir_site_development -O
}

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

findUnusedassets(){
  files=$(ls $1)

  for file in $files; do
    # remove extension three times, for .css.scss.erb files
    nameWithoutExtension="${file%.*}"
    nameWithoutExtension="${nameWithoutExtension%.*}"
    nameWithoutExtension="${nameWithoutExtension%.*}"

    # remove "_" to prevent css inclusions from not counting
    cleanName=${nameWithoutExtension/#_/}
    if [ "$(grep -r $cleanName app | wc -l)" -eq 0 ]; then
      echo "$file"
    fi
  done
}

removeUnusedAssets(){
  files=$(ls $1)

  for file in $files; do
    # remove extension three times, for .css.scss.erb files
    nameWithoutExtension="${file%.*}"
    nameWithoutExtension="${nameWithoutExtension%.*}"
    nameWithoutExtension="${nameWithoutExtension%.*}"

    # remove "_" to prevent css inclusions from not counting
    cleanName=${nameWithoutExtension/#_/}
    if [ "$(grep -r $cleanName app | wc -l)" -eq 0 ]; then
      if [ -f "$1/$file" ]; then
        echo "Removing $1/$file"
        rm "$1/$file"
      fi
    fi
  done
}

eslintFixStaged() {
  yarn eslint --fix $(git diff --staged --name-only | grep -E "(.js$|.ts$|.tsx$)")
}

prettierWriteStaged() {
  yarn prettier -w $(git diff --staged --name-only | grep -E "(.js$|.ts$|.tsx$)")
}
