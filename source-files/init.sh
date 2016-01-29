source_files='env '\
'git '\
'rails '\
'utils '\
'fetchers '\
'path '\
'prompt '\
'work'

for source_file in $source_files; do
  file="~/dotfiles/source-files/$source_file.sh"
  if [ -e "$file" ]
  then
    source "$file"
  fi
done 

[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*

