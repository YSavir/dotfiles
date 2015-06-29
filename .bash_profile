source_files='auths '\
'env '\
'git '\
'rails '\
'utils '\
'fetchers '\
'games '\
'prompt'

for source_file in $source_files; do
  source ~/dotfiles/source-files/$source_file.sh
done 

[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*

