alias rc='rails c'
alias rs='rails s'
alias rg='rails g'
alias rr='rake routes'
alias rt='rake -T'

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
