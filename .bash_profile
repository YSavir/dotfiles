export PATH=$PATH:/Users/Yaniv/anaconda/bin:/Users/Yaniv/anaconda/bin:/Users/Yaniv/anaconda/bin:/Users/Yaniv/anaconda/bin:/Users/Yaniv/anaconda/bin:/Users/Yaniv/anaconda/bin:/Users/Yaniv/anaconda/bin:/Users/Yaniv/.rvm/gems/ruby-2.0.0-p247@rails4/bin:/Users/Yaniv/.rvm/gems/ruby-2.0.0-p247@global/bin:/Users/Yaniv/.rvm/rubies/ruby-2.0.0-p247/bin:/Users/Yaniv/.rvm/bin:/Users/Yaniv/bin:/Users/Yaniv/.wdi/command_line_tools/bin:/Applications/Postgres93.app/Contents/MacOS/bin:/Users/Yaniv/anaconda/bin:/usr/bin:/bin:/usr/sbin:/sbin:/usr/local/bin:/opt/X11/bin

rvm_bin_path=/Users/Yaniv/.rvm/bin

source_files='auths.sh '\
'env.sh '\
'git.sh '\
'rails.sh '\
'utils.sh '\
'fetchers.sh '\
'games.sh'


for source_file in $source_files; do
  source ~/dotfiles/source-files/$source_file
done 

[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*
